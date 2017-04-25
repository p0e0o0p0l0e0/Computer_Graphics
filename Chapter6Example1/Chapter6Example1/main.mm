//
//  main.m
//  Chapter6Example1
//
//  Created by 张琳琪 on 2017/4/25.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>

GLsizei winWidth = 600, winHeight = 500; // Initial display window size.

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(0.0, 100, 0.0, 100); // 窗口坐标范围
}

void setPixel (int x, int y)
{
    glBegin(GL_POINTS);
    glVertex2i(x, y);
    glEnd();
}

inline int round (const float a) { return int (a + 0.5);}

// line DDA
void lineDDA (int x0, int y0, int xEnd, int yEnd)
{
    int dx = xEnd - x0, dy = yEnd - y0, steps, k;
    float xIncrement, yIncrement, x = x0, y = y0;
    
    if(fabs(dx) >= fabs(dy))
    {
        steps = dx;
    }
    else
    {
        steps = dy;
    }
    
    if(steps <= 0)
    {
        steps = 1;
    }
    std::cout << "steps : " << steps << std::endl;
    
    xIncrement = float(dx) / float(steps);
    yIncrement = float(dy) / float(steps);
    
    setPixel(round(x), round(y));
    
    for(k = 0; k < steps; k++)
    {
        x += xIncrement;
        y += yIncrement;
        setPixel(round(x), round(y));
    }
}

//line Bresenham: 斜率slope <= 1

void lineBres1 (int x0, int y0, int xEnd, int yEnd, bool slopepositive = true)
{
    int dx = fabs(xEnd - x0), dy = fabs(yEnd - y0);
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
    std::cout << x << "," << y << std::endl;
}

//line Bresenham: 斜率slope > 1

void lineBres2 (int x0, int y0, int xEnd, int yEnd, bool slopepositive = true)
{
    int dx = fabs(xEnd - x0), dy = fabs(yEnd - y0);
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
    std::cout << x << "," << y << std::endl;
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

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPointSize(3.0);
    glColor3f(1.0, 1.0, 0.0);
    lineDDA(1, 1, 80, 30); // 0 < slope < 1
    lineDDA(1, 1, 1, 30); // slope 无穷大
    lineDDA(1, 80, 1, 80); // slope = 0

    
    glPointSize(5.0);
    glColor3f(0.0, 0.0, 1.0);
    lineBres(90, 15, 20, 40); // -1 < slope < 0
    lineBres(15, 20, 40, 90); // slope > 1
    lineBres(15, 50, 40, 50); // slope = 0
    lineBres(15, 30, 15, 80); // slope 无穷大
    
    glFlush();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100); // 窗口位置，屏幕左上角为(0,0)，窗口左上角距离屏幕左上角100,100。
    glutInitWindowSize(winWidth, winHeight); // 窗口大小
    glutCreateWindow("Draw Lines");
    
    init();
    glutDisplayFunc(displayFcn);
    
    glutMainLoop();
    
    return 0;
}
