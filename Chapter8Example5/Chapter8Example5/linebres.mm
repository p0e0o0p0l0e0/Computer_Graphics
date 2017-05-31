//
//  linebres.mm
//  Chapter8Example3
//
//  Created by 张琳琪 on 2017/5/27.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <stdlib.h>
#include <math.h>
#include "linebres.h"

void setPixel (int x, int y)
{
    glBegin(GL_POINTS);
    glVertex2i(x, y);
    glEnd();
}

//line Bresenham: 斜率slope <= 1

void lineBres1 (int x0, int y0, int xEnd, int yEnd, bool slopepositive = true)
{
    int dx = abs(xEnd - x0), dy = abs(yEnd - y0);
    int p = 2 * dy - dx;
    int twoDy = 2 * dy, twoDyMinusDx = 2 * (dy - dx);
    int x, y;
    
    if(x0 > xEnd)
    {
        x = xEnd;
        y = yEnd;
        xEnd = x0;
    }
    else
    {
        x = x0;
        y = y0;
    }
    
    setPixel(x, y);
    
    while (x < xEnd) {
        x++;
        if (p < 0)
        {
            p += twoDy;
        }
        else
        {
            if (slopepositive)
                y++;
            else
                y--;
            p += twoDyMinusDx;
        }
        setPixel(x, y);
    }
}

//line Bresenham: 斜率slope > 1

void lineBres2 (int x0, int y0, int xEnd, int yEnd, bool slopepositive = true)
{
    int dx = abs(xEnd - x0), dy = abs(yEnd - y0);
    int p = 2 * dx - dy;
    int twoDx = 2 * dx, twoDxMinusDy = 2 * (dx - dy);
    int x, y;
    
    if(y0 > yEnd)
    {
        x = xEnd;
        y = yEnd;
        yEnd = y0;
    }
    else
    {
        x = x0;
        y = y0;
    }
    
    setPixel(x, y);
    
    while (y < yEnd) {
        y++;
        if (p < 0)
        {
            p += twoDx;
        }
        else
        {
            if (slopepositive)
                x++;
            else
                x--;
            p += twoDxMinusDy;
        }
        setPixel(x, y);
    }
}

//line Bresenham
void lineBres (int x0, int y0, int xEnd, int yEnd)
{
    bool slopePositive = true;
    float slope = 0.0;
    if(x0 == xEnd)
    {
        lineBres2(x0, y0, xEnd, yEnd, slopePositive);
    }
    else if(y0 == yEnd)
    {
        lineBres1(x0, y0, xEnd, yEnd, slopePositive);
    }
    else
    {
        slope = float(y0-yEnd)/float(x0-xEnd);
        slopePositive = slope > 0;
    }
    if(fabs(slope) <= 1)
    {
        lineBres1(x0, y0, xEnd, yEnd, slopePositive);
    }
    else
    {
        lineBres2(x0, y0, xEnd, yEnd, slopePositive);
    }
}
