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
#include "lineliangbarsk.h"

const GLdouble PI = 3.1416;
const GLdouble delta = - PI / 100;
GLint initialized = 0;
GLdouble cosDelta, sinDelta;
wcPt2D p0, p1, winMin, winMax;

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-100, 100, -100, 100);
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
    
    clippingWindow();
    
    glColor3f(1.0, 1.0, 1.0);
    
    if(!initialized)
    {
        initialized = 1;
        cosDelta = cos(delta);
        sinDelta = sin(delta);
        winMin.setCoords(-50, -50);
        winMax.setCoords(50, 50);
        p0.setCoords(-100, 0);
        p1.setCoords(100, 0);
    }
    
    p0.setCoords(p0.getx() * cosDelta - p0.gety() * sinDelta, p0.getx() * sinDelta + p0.gety() * cosDelta);
    p1.setCoords(p1.getx() * cosDelta - p1.gety() * sinDelta, p1.getx() * sinDelta + p1.gety() * cosDelta);
    
    glColor3f(1.0, 0.0, 0.0);
    lineBres(round(p0.getx()), round(p0.gety()), round(p1.getx()), round(p1.gety()));
    glColor3f(0.0, 1.0, 1.0);
//    lineClipCohSuth(winMin, winMax, p0, p1);
    lineClipLiangBarsk(winMin, winMax, p0, p1);
    
    glutSwapBuffers();
}

int main(int argc, char * argv[]) {

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
    glutInitWindowPosition(-50, 50);
    glutInitWindowSize(600, 600);
    glutCreateWindow("Exercise 8.6");
    
    init();
    glutDisplayFunc(displayFcn);
    glutIdleFunc(displayFcn);
    
    glutMainLoop();
    
    return 0;
}
