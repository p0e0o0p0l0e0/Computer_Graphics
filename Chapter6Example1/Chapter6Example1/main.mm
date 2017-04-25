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

//line Bresenham: 斜率slope < 1

void lineBres (int x0, int y0, int xEnd, int yEnd)
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
            y++;
            p += twoDyMinusDx;
        }
        setPixel(x, y);
    }
    std::cout << x << "," << y << std::endl;
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPointSize(3.0);
    glColor3f(1.0, 1.0, 0.0);
    lineDDA(1, 1, 80, 30);
    
    glPointSize(5.0);
    glColor3f(0.0, 0.0, 1.0);
    lineBres(15, 20, 90, 40);
    
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
