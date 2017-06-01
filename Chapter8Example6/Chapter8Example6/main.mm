//
//  main.mm
//  Chapter8Example6
//
//  Created by 张琳琪 on 2017/6/1.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include "linebres.h"
#include "lineNLN.h"

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-300, 300, -150, 150);
}

void clippingWindow (wcPt2D winMin, wcPt2D winMax)
{
    glColor3f(1.0, 1.0, 1.0);
    glLineWidth(2.0);
    
    glBegin(GL_LINE_LOOP);
    glVertex2i(winMin.getx(), winMin.gety());
    glVertex2i(winMin.getx(), winMax.gety());
    glVertex2i(winMax.getx(), winMax.gety());
    glVertex2i(winMax.getx(), winMin.gety());
    glEnd();
}

void lineBresAndNLN (wcPt2D winMin, wcPt2D winMax, wcPt2D p1, wcPt2D p2)
{
    glColor3f(1.0, 0.0, 0.0);
    lineBres(round(p1.getx()), round(p1.gety()), round(p2.getx()), round(p2.gety()));
    glColor3f(0.0, 1.0, 0.0);
    lineClipNLN(winMin, winMax, p1, p2);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    wcPt2D winMin, winMax;
    winMin.setCoords(-200, -100);
    winMax.setCoords(200, 100);
    clippingWindow(winMin, winMax);
    
    wcPt2D p1, p2, p3, p4, p5;
    
    p1.setCoords(-25, 25);
    p2.setCoords(-250, 50);
    p3.setCoords(-25, 125);
    p4.setCoords(225, 25);
    p5.setCoords(245, -125);
    
    lineBresAndNLN(winMin, winMax, p1, p2);
    lineBresAndNLN(winMin, winMax, p1, p3);
    lineBresAndNLN(winMin, winMax, p1, p4);
    lineBresAndNLN(winMin, winMax, p1, p5);
    
    glFlush();
}

int main(int argc, char * argv[]) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowSize(600, 300);
    glutInitWindowPosition(-50, 50);
    glutCreateWindow("Exercise 8.12");
    
    init();
    
    glutDisplayFunc(displayFcn);
    
    glutMainLoop();
    
    return 0;
}
