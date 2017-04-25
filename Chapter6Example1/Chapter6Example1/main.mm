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

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPointSize(3.0);
    glColor3f(1.0, 1.0, 0.0);
    lineDDA(1, 1, 80, 30);
    
    glFlush();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100); // 窗口位置，屏幕左上角为(0,0)，窗口左上角距离屏幕左上角100,100。
    glutInitWindowSize(winWidth, winHeight); // 窗口大小
    glutCreateWindow("Draw Curves");
    
    init();
    glutDisplayFunc(displayFcn);
    
    glutMainLoop();
    
    return 0;
}
