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
    gluOrtho2D(-300, 300, -300, 300);
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
    
    
//    // 在裁剪区域内
//    wcPt2D p01, p02, p03, p04, p05, p06, p07, p08;
//    p01.setCoords(-25, 25);
//    p02.setCoords(-250, 50);    // L
//    p03.setCoords(-25, 125);    // T
//    p04.setCoords(225, 25);     // R
//    p05.setCoords(245, -135);   // B
//    p06.setCoords(-25, -50);    // inside
//    p07.setCoords(-200, 100);   // vertex of clipping area
//    p08.setCoords(-250, 50);
//    
//    lineBresAndNLN(winMin, winMax, p01, p02);
//    lineBresAndNLN(winMin, winMax, p01, p03);
//    lineBresAndNLN(winMin, winMax, p01, p04);
//    lineBresAndNLN(winMin, winMax, p01, p05);
//    lineBresAndNLN(winMin, winMax, p01, p06);
//    lineBresAndNLN(winMin, winMax, p07, p08);
//
//    // 在正左侧
//    wcPt2D p11, p12, p13, p14, p15, p16;
//    p11.setCoords(-225, 0);
//    p12.setCoords(-190, 150);   //2 rejected line
//    p13.setCoords(-180, 110);   //LT
//    p14.setCoords(225, 0);      //LR
//    p15.setCoords(-180, -120);  //LB
//    p16.setCoords(-225, 100);   //1 rejected line
//    
//    lineBresAndNLN(winMin, winMax, p11, p12);
//    lineBresAndNLN(winMin, winMax, p11, p13);
//    lineBresAndNLN(winMin, winMax, p11, p14);
//    lineBresAndNLN(winMin, winMax, p11, p15);
//    lineBresAndNLN(winMin, winMax, p11, p16);
    
    
//    // 在左上角
//    wcPt2D p21, p22, p23, p24;
//    p21.setCoords(-210, 130);
//    p22.setCoords(230, 25);     //TR
//    p23.setCoords(100, -130);   //TB
//    p24.setCoords(-190, -130);  //LB
//
//    lineBresAndNLN(winMin, winMax, p21, p22);
//    lineBresAndNLN(winMin, winMax, p21, p23);
//    lineBresAndNLN(winMin, winMax, p21, p24);
//
//    wcPt2D p31, p32, p33, p34;
//    p31.setCoords(-250, 110);
//    p32.setCoords(230, 25);     //TR
//    p33.setCoords(220, -90);    //LR
//    p34.setCoords(-190, -130);  //LB
//    
//    lineBresAndNLN(winMin, winMax, p31, p32);
//    lineBresAndNLN(winMin, winMax, p31, p33);
//    lineBresAndNLN(winMin, winMax, p31, p34);
//    
//    // 在左下角
//    wcPt2D p21, p22, p23, p24;
//    p21.setCoords(-210, -130);
//    p22.setCoords(230, -25);   //RB
//    p23.setCoords(100, 130);   //TB
//    p24.setCoords(-190, 130);  //LT
//    
//    lineBresAndNLN(winMin, winMax, p21, p22);
//    lineBresAndNLN(winMin, winMax, p21, p23);
//    lineBresAndNLN(winMin, winMax, p21, p24);
//
//    // 在正下方
//    wcPt2D p11, p12, p13, p14, p15;
//    p11.setCoords(-50, -125);
//    p12.setCoords(-210, 120);   //LB
//    p13.setCoords(-50, 150);    //TB
//    p14.setCoords(100, 150);    //TB
//    p15.setCoords(250, 50);     //RB
//
//    lineBresAndNLN(winMin, winMax, p11, p12);
//    lineBresAndNLN(winMin, winMax, p11, p13);
//    lineBresAndNLN(winMin, winMax, p11, p14);
//    lineBresAndNLN(winMin, winMax, p11, p15);
    
    // 在正右侧
    wcPt2D p11, p12, p13, p14, p15, p16;
    p11.setCoords(225, 0);
    p12.setCoords(190, 150);   //2 rejected line
    p13.setCoords(180, 110);   //LT
    p14.setCoords(-225, 0);      //LR
    p15.setCoords(180, -120);  //LB
    p16.setCoords(225, 100);   //1 rejected line

    lineBresAndNLN(winMin, winMax, p11, p12);
    lineBresAndNLN(winMin, winMax, p11, p13);
    lineBresAndNLN(winMin, winMax, p11, p14);
    lineBresAndNLN(winMin, winMax, p11, p15);
    lineBresAndNLN(winMin, winMax, p11, p16);
    
    glFlush();
}

int main(int argc, char * argv[]) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowSize(600, 600);
    glutInitWindowPosition(-50, 50);
    glutCreateWindow("Exercise 8.12");
    
    init();
    
    glutDisplayFunc(displayFcn);
    
    glutMainLoop();
    
    return 0;
}
