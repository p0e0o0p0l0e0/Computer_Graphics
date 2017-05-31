//
//  main.mm
//  Chapter8Example5
//
//  Created by 张琳琪 on 2017/5/31.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <math.h>
#include <iostream>
#include "linebres.h"
#include "linecohsuth.h"

const GLdouble PI = 3.1416;
GLdouble theta = 0.0;
const GLdouble delta = - PI / 100;

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-100, 100, -100, 100);
    
    glMatrixMode(GL_MODELVIEW);
}

void clippingWindow (void)
{
    glColor3f(1.0, 1.0, 1.0);
    
    glBegin(GL_LINE_LOOP);
    glVertex2i(-50, -50);
    glVertex2i(-50, 50);
    glVertex2i(50, 50);
    glVertex2i(50, -50);
    glEnd();
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glLoadIdentity();
    clippingWindow();
    
    glColor3f(1.0, 1.0, 1.0);
    
    wcPt2D winMin, winMax;
    winMin.setCoords(-50, -50);
    winMax.setCoords(50, 50);
    
    wcPt2D p0, p1;
    p0.setCoords(-100, 0);
    p1.setCoords(100, 0);
    
    wcPt2D p00, p01;
    p00.setCoords(p0.getx() * cos(theta) - p0.gety() * sin(theta), p0.getx() * sin(theta) + p0.gety() * cos(theta));
    p01.setCoords(p1.getx() * cos(theta) - p1.gety() * sin(theta), p1.getx() * sin(theta) + p1.gety() * cos(theta));
    
//    std::cout << "p00 : " << p00.getx() << "," << p00.gety() << std::endl;
//    std::cout << "p01 : " << p01.getx() << "," << p01.gety() << std::endl;
    
    glColor3f(1.0, 1.0, 0.0);
    lineBres(round(p00.getx()), round(p00.gety()), round(p01.getx()), round(p01.gety()));
    glColor3f(0.0, 1.0, 1.0);
    lineClipCohSuth(winMin, winMax, p00, p01);
    
    glutSwapBuffers();
}

void idleFcn (void)
{
    theta += delta;
    displayFcn();
}

int main(int argc, char * argv[]) {

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
    glutInitWindowPosition(-50, 50);
    glutInitWindowSize(600, 600);
    glutCreateWindow("Exercise 8.6");
    
    init();
    glutDisplayFunc(displayFcn);
    glutIdleFunc(idleFcn);
    
    glutMainLoop();
    
    return 0;
}
