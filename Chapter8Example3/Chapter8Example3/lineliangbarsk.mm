//
//  lineliangbarsk.mm
//  Chapter8Example3
//
//  Created by 张琳琪 on 2017/5/27.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>
#include "lineliangbarsk.h"
#include "linebres.h"

GLint clipTest (GLfloat p, GLfloat q, GLfloat * u1, GLfloat * u2)
{
    GLfloat r;
    GLint returnValue = true;
    
    if(p < 0.0)
    {
        r = q / p;
        if(r > *u2)
        {
            returnValue = false;
        }
        else
        {
            if(r > *u1)
            {
                *u1 = r;
            }
        }
    }
    else
    {
        if(p > 0.0)
        {
            r = q / p;
            if(r < *u1)
            {
                returnValue = false;
            }
            else
            {
                if(r < *u2)
                {
                    *u2 = r;
                }
            }
        }
        else
        {
            if(q < 0.0)
            {
                returnValue = false;
            }
        }
    }
    return returnValue;
}

void lineClipLiangBarsk(wcPt2D winMin, wcPt2D winMax, wcPt2D p1, wcPt2D p2)
{
    GLfloat u1 = 0.0, u2 = 1.0, dx = p2.getx() - p1.getx(), dy;
    
    if(clipTest(-dx, p1.getx() - winMin.getx(), &u1, &u2))
    {
        if(clipTest(dx, winMax.getx() - p1.getx(), &u1, &u2))
        {
            dy = p2.gety() - p1.gety();
            if(clipTest(-dy, p1.gety() - winMin.gety(), &u1, &u2))
            {
                if(clipTest(dy, winMax.gety() - p1.gety(), &u1, &u2))
                {
                    if(u2 < 1.0)
                    {
                        p2.setCoords(p1.getx() + u2 * dx, p1.gety() + u2 * dy);
                    }
                    if(u1 > 0.0)
                    {
                        p1.setCoords(p1.getx() + u1 * dx, p1.gety() + u1 * dy);
                    }
                    lineBres(round(p1.getx()), round(p1.gety()), round(p2.getx()), round(p2.gety()));
                    std::cout << "liangbarsk : " << u1 << "," << u2 << "," << p2.getx() << "," << p2.gety() << std::endl;
                    std::cout << "liangbarsk : " << p1.getx() << "," << p1.gety() << "," << p2.getx() << "," << p2.gety() << std::endl;
                }
            }
        }
    }
}










