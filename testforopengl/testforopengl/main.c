//
//  main.c
//  testforopengl
//
//  Created by 张琳琪 on 2017/2/27.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <stdio.h>

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(0.0, 200.0, 0.0, 150.0);
}

void polygonSegment (void)
{
    glClear (GL_COLOR_BUFFER_BIT);
    
    glColor3f(0.0, 0.4, 0.2);
    
//    glBegin(GL_POLYGON);          // 六个点依次连接为多边形
//    glBegin(GL_TRIANGLES);        // 3个点为一组连成一个三角形
    glBegin(GL_TRIANGLE_FAN);     // 第一个为顶点，连续三角形组成的扇形多边形
    glVertex2i(10, 30);
    glVertex2i(20, 10);
    glVertex2i(40, 10);
    glVertex2i(50, 30);
    glVertex2i(40, 50);
    glVertex2i(20, 50);
    glEnd();
    
//    glBegin(GL_TRIANGLE_STRIP);   // 每3个点合并为一个三角形
//    glVertex2i(10, 30);
//    glVertex2i(20, 10);
//    glVertex2i(20, 50);
//    glVertex2i(40, 10);
//    glVertex2i(40, 50);
//    glVertex2i(50, 30);
//    glEnd();
    
    glFlush();
}

void rectSegment (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1, 1, 0);
    int vectex1 [] = {100, 10};
    int vectex2 [] = {10, 50};
    glRectiv(vectex1, vectex2);
    
    glFlush();
}

void lineSegment (void)
{
    glClear (GL_COLOR_BUFFER_BIT);
    
    glColor3f(0.0, 0.4, 0.2);
//    glBegin(GL_LINES);
//    glBegin(GL_LINE_STRIP);
    glBegin(GL_LINE_LOOP);
    glVertex2i(190, 100);
    glVertex2i(20, 10);
    glVertex2i(100, 145);
    glVertex2i(150, 10);
    glVertex2i(10, 100);
    glEnd();
    
    glFlush();
}

void pointSegment (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 0.4, 0.2);
    glBegin(GL_POINTS);
    glVertex2i(100, 100);
    glEnd();
    
    glFlush();
}

GLenum errorCheck()
{
    GLenum code;
    const GLubyte *string;
    code = glGetError();
    if(code != GL_NO_ERROR)
    {
        string = gluErrorString(code);
        fprintf(stderr, "OpenGL error : %s\n", string);
    }
    return code;
}

int main(int argc, char ** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(50, 100);
    glutInitWindowSize(400, 300);
    glutCreateWindow("An  Example OpenGL Program");
    
    init();
//    glutDisplayFunc(lineSegment);
//    glutDisplayFunc(pointSegment);
//    glutDisplayFunc(rectSegment);
    glutDisplayFunc(polygonSegment);
    errorCheck(); // must set before MainLoop.
    glutMainLoop();
    
    return 1;
}
