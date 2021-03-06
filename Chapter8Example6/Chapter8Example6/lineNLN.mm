//
//  lineNLN.mm
//  Chapter8Example6
//
//  Created by 张琳琪 on 2017/6/1.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>
#include <math.h>
#include "lineNLN.h"
#include "linebres.h"

GLfloat m1, m2, m3, m4;

const GLint winLeftBitCode = 0x1; // 直接为1也没问题
const GLint winRightBitCode = 0x2;
const GLint winBottomBitCode = 0x4;
const GLint winTopBitCode = 0x8;

typedef GLfloat Matrix3x3 [3][3];
Matrix3x3 matRotate;
Matrix3x3 matComposite;
const GLdouble pi = 3.14159;
GLfloat delta;
wcPt2D center;

inline GLint inside (GLint code)
{
    return GLint (!(code));
}
inline GLint reject (GLint code1, GLint code2)
{
    return GLint (code1 & code2);
}
inline GLint accept (GLint code1, GLint code2)
{
    return GLint (!(code1 | code2));
}

GLubyte encode (wcPt2D pt, wcPt2D winMin, wcPt2D winMax)
{
    GLubyte code = 0x00;
    
    if(pt.getx() < winMin.getx())
        code = code | winLeftBitCode;
    if(pt.getx() > winMax.getx())
        code = code | winRightBitCode;
    if(pt.gety() < winMin.gety())
        code = code | winBottomBitCode;
    if(pt.gety() > winMax.gety())
        code = code | winTopBitCode;
    
    return code;
}

void swapPts (wcPt2D * p1, wcPt2D * p2) // TODO 为什么要用指针？
{
    wcPt2D tmp;
    tmp = * p1; * p1 = * p2; * p2 = tmp;
}

void swapCode (GLubyte * c1, GLubyte * c2)
{
    GLubyte tmp;
    tmp = * c1; * c1 = * c2; * c2 = tmp;
}

void renewWinVertexes (wcPt2D * winMin, wcPt2D * winMax)
{
    wcPt2D tmp1, tmp2;
    tmp1.setCoords(fmin(winMin->getx(), winMax->getx()), fmin(winMin->gety(), winMax->gety()));
    tmp2.setCoords(fmax(winMin->getx(), winMax->getx()), fmax(winMin->gety(), winMax->gety()));
    * winMin = tmp1;
    * winMax = tmp2;
}

void matrix3x3SetIdentity (Matrix3x3 matIden3x3)
{
    GLint row, col;
    for(row = 0; row < 3; row++)
    {
        for(col = 0; col < 3; col++)
        {
            matIden3x3[row][col] = (row == col);
        }
    }
}

void matrix3x3Premultiply (Matrix3x3 m1, Matrix3x3 m2)
{
    GLint row, col;
    Matrix3x3 matTemp;
    
    for(row = 0; row < 3; row++)
    {
        for(col = 0; col < 3; col++)
        {
            matTemp[row][col] = m1[row][0] * m2 [0][col] + m1[row][1] * m2 [1][col] + m1[row][2] * m2 [2][col];
        }
    }
    
    for(row = 0; row < 3; row++)
    {
        for(col = 0; col < 3; col++)
        {
            m2[row][col] = matTemp[row][col];
        }
    }
}

void rotate2D (wcPt2D pivotPt, GLfloat theta)
{
    matrix3x3SetIdentity(matRotate);
    
    matRotate[0][0] = cos(theta);
    matRotate[0][1] = -sin(theta);
    matRotate[0][2] = pivotPt.getx() * (1 - cos(theta)) + pivotPt.gety() * sin(theta);
    matRotate[1][0] = sin(theta);
    matRotate[1][1] = cos(theta);
    matRotate[1][2] = pivotPt.gety() * (1 - cos(theta)) + pivotPt.getx() * sin(theta);
}

void transformVerts2D (wcPt2D * verts)
{
    GLfloat tempx, tempy;
    
    tempx = matRotate[0][0] * verts->getx() + matRotate[0][1] * verts->gety() + matRotate[0][2];
    tempy = matRotate[1][0] * verts->getx() + matRotate[1][1] * verts->gety() + matRotate[1][2];
    
    verts->setCoords(tempx, tempy);
}

void slopeWith4Vertexes (wcPt2D winMin, wcPt2D winMax, wcPt2D p1)
{
    m1 = (p1.gety() - winMin.gety()) / (p1.getx() - winMin.getx());
    m2 = (p1.gety() - winMax.gety()) / (p1.getx() - winMin.getx());
    m3 = (p1.gety() - winMax.gety()) / (p1.getx() - winMax.getx());
    m4 = (p1.gety() - winMin.gety()) / (p1.getx() - winMax.getx());
    
//    std::cout << "slope : m1 : " << m1 << " m2 : " << m2 << " m3 : " << m3 << " m4 : " << m4 << std::endl;
}

void lineClipNLN (wcPt2D winMin, wcPt2D winMax, wcPt2D p1, wcPt2D p2)
{
    GLubyte code1, code2;
    GLint plotLine = false, done = false;
    GLfloat m = 0.0;
    
    while (!done)
    {
        code1 = encode(p1, winMin, winMax);
        code2 = encode(p2, winMin, winMax);
        if(accept(code1, code2))
        {
            plotLine = true;
            done = true;
        }
        else
        {
            if(reject(code1, code2))
            {
                std::cout << "1 rejected line!" << std::endl;
                done = true;
            }
            else
            {
                // 有一个点在裁剪区域内
                if(inside(code1) || inside(code2))
                {
                    plotLine = true;
                    done = true;
                    if(!inside(code1))
                    {
                        swapPts(&p1, &p2);
                        swapCode(&code1, &code2);
                    }
                    wcPt2D topLeft, bottomRight;
                    topLeft.setCoords(winMin.getx(), winMax.gety());
                    bottomRight.setCoords(winMax.getx(), winMin.gety());
                    if(p1.equals(winMin) || p1.equals(winMax) || p1.equals(topLeft) || p1.equals(bottomRight))
                    {
                        p2.setCoords(p1.getx(), p1.gety());
                    }
                    else
                    {
                        slopeWith4Vertexes(winMin, winMax, p1);
                        
                        if(p1.getx() != p2.getx())
                        {
                            m = (p2.gety() - p1.gety()) / (p2.getx() - p1.getx());
                        
                            if(m <= m1 && m >= m2 && (code2 & winLeftBitCode))
                            {//L
                                p2.setCoords(winMin.getx(), p1.gety() + m * (winMin.getx() - p1.getx()));
                            }
                            else if(m <= m3 && m >= m4 && (code2 & winRightBitCode))
                            {//R
                                p2.setCoords(winMax.getx(), p1.gety() + m * (winMax.getx() - p1.getx()));
                            }
                            else if((m > m3 || m < m2) && (code2 & winTopBitCode))
                            {//T
                                p2.setCoords(p1.getx() + (winMax.gety() - p1.gety())/m, winMax.gety());
                            }
                            else if((m > m1 || m < m4) && (code2 & winBottomBitCode))
                            {//B
                                p2.setCoords(p1.getx() + (winMin.gety() - p1.gety())/m, winMin.gety());
                            }
                        }
                        else
                        {
                            if(p2.gety() > winMax.gety())
                            {
                                p2.setCoords(p2.getx(), winMax.gety());
                            }
                            else
                            {
                                p2.setCoords(p2.getx(), winMin.gety());
                            }
                        }
                    }
                }
                else
                {
                    if(code1 == 0x01 || code2 == 0x01)
                    // 有一个点的区域码是0001，即在裁剪区域正左侧，L的情况在上一个if中包含，这里只会有LT，LR，LB和rejected的情况
                    {
                        if(code1 != 0x01)
                        {
                            swapPts(&p1, &p2);
                            swapCode(&code1, &code2);
                        }
                        slopeWith4Vertexes(winMin, winMax, p1);
                        if(p1.getx() != p2.getx())
                        {
                            m = (p2.gety() - p1.gety()) / (p2.getx() - p1.getx());
                        }
                        if(m < m1 || m > m2)
                        {
                            std::cout << "2 rejected line!" << std::endl;
                            done = true;
                        }
                        else
                        {
                            p1.setCoords(winMin.getx(), p1.gety() + m * (winMin.getx() - p1.getx()));
                            if((m <= m2 && m >= m3) && (code2 & winTopBitCode))
                            {//LT
                                p2.setCoords(p1.getx() + (winMax.gety() - p1.gety())/m, winMax.gety());
                            }
                            else if((m < m3 && m >= m4) && (code2 & winRightBitCode))
                            {//LR
                                p2.setCoords(winMax.getx(), p1.gety() + m * (winMax.getx() - p1.getx()));
                            }
                            else if((m < m4 && m >= m1) && (code2 & winBottomBitCode))
                            {//LB
                                p2.setCoords(p1.getx() + (winMin.gety() - p1.gety())/m, winMin.gety());
                            }
                            plotLine = true;
                            done = true;
                        }
                    }
                    else if(code1 == (winLeftBitCode | winTopBitCode) || code2 == (winLeftBitCode | winTopBitCode))
                        // 有一个点在裁剪区域外左上角的情况，这里的L、T情况已经在第一个if里包含
                    {
                        if(code1 != (winLeftBitCode | winTopBitCode))
                        {
                            swapPts(&p1, &p2);
                            swapCode(&code1, &code2);
                        }
                        
                        slopeWith4Vertexes(winMin, winMax, p1);
                        if(p1.getx() != p2.getx())
                        {
                            m = (p2.gety() - p1.gety()) / (p2.getx() - p1.getx());
                        }
                        if(m > m3 || m < m1)
                        {
                            std::cout << "3 rejected line!" << std::endl;
                            done = true;
                        }
                        else
                        {
                            plotLine = true;
                            done = true;
                            if(m <= m3 && m >= m4)
                            {
                                p2.setCoords(winMax.getx(), p1.gety() + m * (winMax.getx() - p1.getx()));
                                if(m2 > m4 && m <= m2)
                                {//LR
                                    p1.setCoords(winMin.getx(), p1.gety() + m * (winMin.getx() - p1.getx()));
                                }
                                else
                                {//TR
                                    p1.setCoords(p1.getx() + (winMax.gety() - p1.gety())/m, winMax.gety());
                                }
                            }
                            else if(m < m4 && m >= m1)
                            {
                                p2.setCoords(p1.getx() + (winMin.gety() - p1.gety())/m, winMin.gety());
                                if(m2 < m4 && m >= m2)
                                {//TB
                                    p1.setCoords(p1.getx() + (winMax.gety() - p1.gety())/m, winMax.gety());
                                }
                                else
                                {//LB
                                    p1.setCoords(winMin.getx(), p1.gety() + m * (winMin.getx() - p1.getx()));
                                }
                            }
                        }
                    }
                    else
                    {
                        center.setCoords((winMin.getx() + winMax.getx())/2, (winMin.gety() + winMax.gety())/2);
                        
                        if(code1 == (winLeftBitCode | winBottomBitCode) || code2 == (winLeftBitCode | winBottomBitCode))
                        {//LB
                            delta = -pi/2;
                        }
                        else if(code1 == winBottomBitCode || code2 == winBottomBitCode)
                        {//B
                            delta = -pi/2;
                        }
                        else if(code1 == (winBottomBitCode | winRightBitCode) || code2 == (winBottomBitCode | winRightBitCode))
                        {//BR
                            delta = pi;
                        }
                        else if(code1 == winRightBitCode || code2 == winRightBitCode)
                        {//R
                            delta = pi;
                        }
                        else if(code1 == (winRightBitCode | winTopBitCode) || code2 == (winRightBitCode | winTopBitCode))
                        {//TR
                            delta = pi/2;
                        }
                        else if(code1 == winTopBitCode || code2 == winTopBitCode)
                        {//T
                            delta = pi/2;
                        }
                        rotate2D(center, delta);
                        transformVerts2D(&p1);
                        transformVerts2D(&p2);
                        transformVerts2D(&winMin);
                        transformVerts2D(&winMax);
                        renewWinVertexes(&winMin, &winMax);
                    }
                }
            }
        }
    }
    
    if(plotLine)
    {
        if(delta != 0)
        {
            rotate2D(center, -delta);
            transformVerts2D(&p1);
            transformVerts2D(&p2);
        }
        lineBres(round(p1.getx()), round(p1.gety()), round(p2.getx()), round(p2.gety()));
    }
    delta = 0;
}




