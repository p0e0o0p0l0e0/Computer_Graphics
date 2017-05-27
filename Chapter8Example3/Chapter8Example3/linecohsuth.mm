//
//  linecohsuth.mm
//  Chapter8Example3
//
//  Created by 张琳琪 on 2017/5/27.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>
#include "linecohsuth.h"
#include "linebres.h"

const GLint winLeftBitCode = 0x1; // 直接为1也没问题
const GLint winRightBitCode = 0x2;
const GLint winBottomBitCode = 0x4;
const GLint winTopBitCode = 0x8;

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
    
//    printf("code : %0x  \n",code);
    return code;
}

void swapPts (wcPt2D * p1, wcPt2D * p2)
{
    wcPt2D tmp;
    tmp = * p1; * p1 = * p2; * p2 = tmp;
}

void swapCode (GLubyte * c1, GLubyte * c2)
{
    GLubyte tmp;
    tmp = * c1; * c1 = * c2; * c2 = tmp;
}

void lineClipCohSuth (wcPt2D winMin, wcPt2D winMax, wcPt2D p1, wcPt2D p2)
{
    GLubyte code1, code2;
    GLint done = false, plotLine = false;
    GLfloat m = 0.0;
    
//    std::cout << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
    while (!done)
    {
        code1 = encode(p1, winMin, winMax);
        code2 = encode(p2, winMin, winMax);
        if(accept(code1, code2))
        {
            done = true;
            plotLine = true;
        }
        else
        {
            if(reject(code1, code2))
            {
                done = true;
            }
            else
            {
                if(inside(code1))
                {
                    swapPts(&p1, &p2);
                    swapCode(&code1, &code2);
//                    std::cout << "swap : " << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
                }
                
                if(p2.getx() != p1.getx())
                    m = (p2.gety() - p1.gety())/(p2.getx() - p1.getx());
                
                if(code1 & winLeftBitCode)
                {
                    p1.setCoords(winMin.getx(), p1.gety() + (winMin.getx() - p1.getx()) * m);
//                    std::cout << "1 : " << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
                }
                else
                {
                    if(code1 & winRightBitCode)
                    {
                        p1.setCoords(winMax.getx(), p1.gety() + (winMax.getx() - p1.getx()) * m);
//                        std::cout << "2 : " << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
                    }
                    else
                    {
                        if(code1 & winBottomBitCode)
                        {
                            if(p2.getx() != p1.getx())
                            {
                                p1.setCoords(p1.getx() + (winMin.gety() - p1.gety()) / m,  winMin.gety());
                            }
                            p1.setCoords(p1.getx(), winMin.gety());
//                            std::cout << "3 : " << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
                        }
                        else
                        {
                            if(code1 & winTopBitCode)
                            {
                                if(p2.getx() != p1.getx())
                                {
                                    p1.setCoords(p1.getx() + (winMax.gety() - p1.gety()) / m, winMax.gety());
                                }
                                p1.setCoords(p1.getx(), winMax.gety());
//                                std::cout << "4 : " << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
                            }
                        }
                    }
                }
            }
        }
    }
    
    if(plotLine)
    {
        lineBres(round(p1.getx()), round(p1.gety()), round(p2.getx()), round(p2.gety()));
        std::cout << "cohsuth : " << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
    }
}

