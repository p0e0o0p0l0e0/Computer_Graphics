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
#include "lineliangbarsk.h"

void originalLineAndClippingLine (wcPt2D winMin, wcPt2D winMax, wcPt2D p1, wcPt2D p2)
{
    glColor3f(1.0, 0.0, 0.0);
    lineBres(round(p1.getx()), round(p1.gety()), round(p2.getx()), round(p2.gety()));
    glColor3f(0.0, 0.0, 1.0);
    lineClipCohSuth(winMin, winMax, p1, p2);
    glColor3f(0.0, 1.0, 0.0);
    lineClipLiangBarsk(winMin, winMax, p1, p2);
    
}

void clippingArea(wcPt2D winMin, wcPt2D winMax)
{
    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_LINE_LOOP);
    glVertex2f(winMin.getx(), winMin.gety());
    glVertex2f(winMin.getx(), winMax.gety());
    glVertex2f(winMax.getx(), winMax.gety());
    glVertex2f(winMax.getx(), winMin.gety());
    glEnd();
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    std::cout << "display Fcn " << std::endl;
    
    wcPt2D winMin, winMax, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12;
    winMin.setCoords(-50, -50);
    winMax.setCoords(50, 50);
    p1.setCoords(-80, 40);
    p2.setCoords(-90, -40);
    p3.setCoords(-10, 25);
    p4.setCoords(30, 10);
    p5.setCoords(-45, -75);
    p6.setCoords(25, -25);
    p7.setCoords(10, 60);
    p8.setCoords(80, -10);
    p9.setCoords(-25, 75);
    p10.setCoords(-25, -90);
    p11.setCoords(-60, -10);
    p12.setCoords(25, -10);
    
    
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
