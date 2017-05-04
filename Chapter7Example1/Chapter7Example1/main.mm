//
//  main.m
//  Chapter7Example1
//
//  Created by 张琳琪 on 2017/5/4.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>

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
    GLint k;
    
    for (k = 0; k < nVerts; k++)
    {
        verts[k].x += tx;
        verts[k].y += ty;
    }
    glBegin(GL_POLYGON);
    for(k = 0; k < nVerts; k++)
    {
        glVertex2f(verts[k].x, verts[k].y);
    }
    glEnd();
}

void draw2DTranslate() // Chp 7.1.1
{
    glColor3f(1.0, 0.0, 0.0);
    GLint nVerts = 3;
    wcPt2D *verts;
    verts = (wcPt2D *)malloc(nVerts * sizeof(wcPt2D));
    verts[0].x = 10, verts[0].y = 10;
    verts[1].x = 100, verts[1].y = 20;
    verts[2].x = 80, verts[2].y = 50;
    drawPolygon(verts, nVerts);
    glColor3f(1, 0.5, 0.0);
    translatePolygon(verts, nVerts, -150, 50);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    drawCoords();
    
    draw2DTranslate();
    
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
