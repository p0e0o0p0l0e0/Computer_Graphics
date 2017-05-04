//
//  main.m
//  Chapter7Example1
//
//  Created by 张琳琪 on 2017/5/4.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>
#include <math.h>

#define TWO_Pi 3.14159

GLsizei winWidth = 600, winHeight = 300; // Initial display window size.

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-200.0, 200, -100.0, 100); // 窗口坐标范围
}

void setPixel (int x, int y)
{
    glBegin(GL_POINTS);
    glVertex2i(x, y);
    glEnd();
}

void drawCoords()
{
    glBegin(GL_LINES);
    glVertex2i(-200, 0);
    glVertex2i(200, 0);
    glEnd();
    
    glBegin(GL_LINES);
    glVertex2i(0, -100);
    glVertex2i(0, 100);
    glEnd();
}

class wcPt2D{
public:
    GLfloat x, y;
};

void drawPolygon(wcPt2D * verts, GLint nVerts)
{
    GLint k;
    
    glBegin(GL_POLYGON);
    for(k = 0; k < nVerts; k++)
    {
        glVertex2f(verts[k].x, verts[k].y);
    }
    glEnd();
}

void translatePolygon (wcPt2D * verts, GLint nVerts, GLfloat tx, GLfloat ty)
{
    wcPt2D * vertsTra = (wcPt2D *)malloc(nVerts * sizeof(wcPt2D));
    GLint k;
    
    for (k = 0; k < nVerts; k++)
    {
        vertsTra[k].x = verts[k].x + tx;
        vertsTra[k].y = verts[k].y + ty;
    }
    glBegin(GL_POLYGON);
    for(k = 0; k < nVerts; k++)
    {
        glVertex2f(vertsTra[k].x, vertsTra[k].y);
    }
    glEnd();
}

void rotatePolygon (wcPt2D * verts, GLint nVerts, wcPt2D pivPt, GLdouble theta)
{
    wcPt2D * vertsRot = (wcPt2D *) malloc(nVerts * sizeof(wcPt2D));
    GLint k;
    
    for(k = 0; k < nVerts; k++)
    {
        vertsRot[k].x = pivPt.x + (verts[k].x - pivPt.x) * cos (theta) - (verts[k].y - pivPt.y) * sin(theta);
        vertsRot[k].y = pivPt.y + (verts[k].x - pivPt.x) * sin (theta) + (verts[k].y - pivPt.y) * cos(theta);
    }
    glBegin(GL_POLYGON);
    for(k = 0; k < nVerts; k++)
    {
        glVertex2f(vertsRot[k].x, vertsRot[k].y);
    }
    glEnd();
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    drawCoords();
    
    glColor3f(0.0, 1.0, 0.0);
    GLint nVerts = 3;
    wcPt2D *verts;
    verts = (wcPt2D *)malloc(nVerts * sizeof(wcPt2D));
    verts[0].x = 10, verts[0].y = 10;
    verts[1].x = 100, verts[1].y = 20;
    verts[2].x = 80, verts[2].y = 50;
    drawPolygon(verts, nVerts);
    
    glColor3f(1.0, 0.0, 0.0);
    translatePolygon(verts, nVerts, -150, 50);
    
    wcPt2D pivotPoint;
    pivotPoint.x = 10, pivotPoint.y = 10;
    glColor3f(0.0, 0.0, 1.0);
    rotatePolygon(verts, nVerts, pivotPoint, -TWO_Pi/2);
    
    glFlush();}


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
