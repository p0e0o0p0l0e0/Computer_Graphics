//
//  main.mm
//  Chapter8Example7
//
//  Created by 张琳琪 on 2017/6/2.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include "polygonClipS.h"

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-200, 200, -100, 100);
}

void clippingWindow (GLint x0,  GLint y0, GLint x1, GLint y1)
{
    glColor3f(1.0, 1.0, 1.0);
    glLineWidth(2.0);
    
    glBegin(GL_LINE_LOOP);
    glVertex2i(x0, y0);
    glVertex2i(x0, y1);
    glVertex2i(x1, y1);
    glVertex2i(x1, y0);
    glEnd();
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    clippingWindow(-100, -50, 100, 50);
    
    wcPt2D winMin, winMax;
    wcPt2D * pOut = new wcPt2D();
    wcPt2D * pIn = new wcPt2D();
    GLint n = 3, newCnt;
    
    winMin.x = -100, winMin.y = -50, winMax.x = 100, winMax.y = 50;
    pIn[0].x = 0.0, pIn[0].y = -75.0;
    pIn[1].x = 150, pIn[1].y = -10;
    pIn[2].x = 75, pIn[2].y = 75;
    
    newCnt = polygonClpSuhHodg(winMin, winMax, n, pIn, pOut);
    
//    glColor3f(1.0, 0.0, 0.0);
//    glBegin(GL_POLYGON);
//    
//    for(int i = 0; i < n; i++)
//    {
//        glVertex2f(pIn[i].x, pIn[i].y);
//    }
//    glEnd();
    
    glColor3f(0.0, 1.0, 0.0);
    glBegin(GL_POLYGON);
    
    for(int i = 0; i < newCnt; i++)
    {
        glVertex2f(pOut[i].x, pOut[i].y);
    }
    glEnd();
    
    glFlush();
}

int main(int argc, char * argv[])
{
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowPosition(-50, 50);
    glutInitWindowSize(600, 300);
    glutCreateWindow("Sutherland-Hodgman polygon clipping algorithm");
    
    init();
    glutDisplayFunc(displayFcn);
    glutMainLoop();
    
    return 0;
}
