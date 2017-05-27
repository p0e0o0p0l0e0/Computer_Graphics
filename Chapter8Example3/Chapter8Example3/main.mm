//
//  main.mm
//  Chapter8Example3
//
//  Created by 张琳琪 on 2017/5/27.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>

#include "linebres.h"
#include "linecohsuth.h"

void originalLineAndClippingLine (wcPt2D winMin, wcPt2D winMax, wcPt2D p1, wcPt2D p2)
{
    glColor3f(1.0, 1.0, 0.0);
    lineBres(round(p1.x), round(p1.y), round(p2.x), round(p2.y));
    glColor3f(0.0, 1.0, 1.0);
    lineClipCohSuth(winMin, winMax, p1, p2);
}

void clippingArea(wcPt2D winMin, wcPt2D winMax)
{
    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_LINE_LOOP);
    glVertex2f(winMin.x, winMin.y);
    glVertex2f(winMin.x, winMax.y);
    glVertex2f(winMax.x, winMax.y);
    glVertex2f(winMax.x, winMin.y);
    glEnd();
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    std::cout << "display Fcn " << std::endl;
    
    wcPt2D winMin, winMax, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12;
    winMin.x = -50; winMin.y = -50;
    winMax.x = 50, winMax.y = 50;
    p1.x = -80, p1.y = 40;
    p2.x = -90, p2.y = -40;
    p3.x = -10, p3.y = 25;
    p4.x = 30, p4.y = 10;
    p5.x = -45, p5.y = -75;
    p6.x = 25, p6.y = -25;
    p7.x = 10, p7.y = 60;
    p8.x = 80, p8.y = -10;
    p9.x = -25, p9.y = 75;
    p10.x = -25, p10.y = -90;
    p11.x = -60, p11.y = -10;
    p12.x = 25, p12.y = -10;
    
    
    clippingArea(winMin, winMax);
    originalLineAndClippingLine(winMin, winMax, p1, p2);
    originalLineAndClippingLine(winMin, winMax, p3, p4);
    originalLineAndClippingLine(winMin, winMax, p5, p6);
    originalLineAndClippingLine(winMin, winMax, p7, p8);
    originalLineAndClippingLine(winMin, winMax, p9, p10);
    originalLineAndClippingLine(winMin, winMax, p11, p12);
    
    glFlush();
}

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-100.0, 100.0, -100.0, 100); // 窗口坐标范围
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100); // 窗口位置，屏幕左上角为(0,0)，窗口左上角距离屏幕左上角100,100。
    glutInitWindowSize(600, 300); // 窗口大小
    glutCreateWindow("Cohen-Sutherland Clipping");
    
    init();
    glutDisplayFunc(displayFcn);
    
    glutMainLoop();
    
    return 0;
}
