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
    
    if(pt.x < winMin.x)
        code = code | winLeftBitCode;
    if(pt.x > winMax.x)
        code = code | winRightBitCode;
    if(pt.y < winMin.y)
        code = code | winBottomBitCode;
    if(pt.y > winMax.y)
        code = code | winTopBitCode;
    
    printf("code : %0x  \n",code);
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
    
    
    std::cout << p1.x << "," << p1.y << "," << p2.x << "," << p2.y << std::endl;
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
                    std::cout << "swap : " << p1.x << "," << p1.y << "," << p2.x << "," << p2.y << std::endl;
                }
                
                if(p2.x != p1.x)
                    m = (p2.y - p1.y)/(p2.x - p1.x);
                
                if(code1 & winLeftBitCode)
                {
                    p1.y += (winMin.x - p1.x) * m;
                    p1.x = winMin.x;
                    std::cout << "1 : " << p1.x << "," << p1.y << "," << p2.x << "," << p2.y << std::endl;
                }
                else
                {
                    if(code1 & winRightBitCode)
                    {
                        p1.y += (winMax.x - p1.x) * m;
                        p1.x = winMax.x;
                        std::cout << "2 : " << p1.x << "," << p1.y << "," << p2.x << "," << p2.y << std::endl;
                    }
                    else
                    {
                        if(code1 & winBottomBitCode)
                        {
                            if(p2.x != p1.x)
                            {
                                p1.x += (winMin.y - p1.y) / m;
                            }
                            p1.y = winMin.y;
                            std::cout << "3 : " << p1.x << "," << p1.y << "," << p2.x << "," << p2.y << std::endl;
                        }
                        else
                        {
                            if(code1 & winTopBitCode)
                            {
                                if(p2.x != p1.x)
                                {
                                    p1.x += (winMax.y - p1.y) / m;
                                }
                                p1.y = winMax.y;
                                std::cout << "4 : " << p1.x << "," << p1.y << "," << p2.x << "," << p2.y << std::endl;
                            }
                        }
                    }
                }
            }
        }
    }
    
    if(plotLine)
        lineBres(round(p1.x), round(p1.y), round(p2.x), round(p2.y));
}

