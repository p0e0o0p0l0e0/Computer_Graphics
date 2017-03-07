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
    
//    glBegin(GL_POLYGON);          // 6个顶点依次连接为多边形
//    glBegin(GL_TRIANGLES);        // 3个顶点为一组连成一个三角形
    glBegin(GL_TRIANGLE_FAN);     // 第一个为顶点，连续三角形组成的扇形多边形
    glVertex2i(10, 30);
    glVertex2i(20, 10);
    glVertex2i(40, 10);
    glVertex2i(50, 30);
    glVertex2i(40, 50);
    glVertex2i(20, 50);
    glEnd();
    
//    glBegin(GL_TRIANGLE_STRIP);   // 每3个顶点合并为一个三角形
//    glVertex2i(10, 30);
//    glVertex2i(20, 10);
//    glVertex2i(20, 50);
//    glVertex2i(40, 10);
//    glVertex2i(40, 50);
//    glVertex2i(50, 30);
//    glEnd();
    
    glFlush();
}

void quadSegment (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(0, 0, 1);
//    glBegin(GL_QUADS);      // 每4个顶点为一组，构成四边形
//    glVertex2i(5, 40);
//    glVertex2i(10, 10);
//    glVertex2i(20, 10);
//    glVertex2i(20, 25);
//    glVertex2i(25, 20);
//    glVertex2i(23, 15);
//    glVertex2i(40, 10);
//    glVertex2i(40, 40);
//    glEnd();
    
    glBegin(GL_QUAD_STRIP);      // 先指定2个顶点，之后每个四边形再指定2个顶点
    glVertex2i(5, 40);
    glVertex2i(10, 10);
    glVertex2i(20, 28);
    glVertex2i(20, 10);
    glColor3f(0, 1, 1);
    glVertex2i(25, 27);
    glVertex2i(23, 12);
    glColor3f(0, 1, 0);
    glVertex2i(40, 40);
    glVertex2i(40, 10);
    glEnd();
    
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

typedef GLint vertex3 [3];
vertex3 pt [8] = {{0, 0, 0}, {0, 100, 0}, {100, 0, 0}, {100, 100, 0}, {0, 0, 100}, {0, 100, 100}, {100, 0, 100}, {100, 100, 100}};

void quad (GLint n1, GLint n2, GLint n3, GLint n4)
{
    glBegin(GL_QUADS);
    glVertex3iv(pt [n1]);
    glVertex3iv(pt [n2]);
    glVertex3iv(pt [n3]);
    glVertex3iv(pt [n4]);
    glEnd();
}

void cube (void)
{
    
    glColor3f(1, 0, 0); // R
    quad(6, 2, 3, 7);
    
    glColor3f(0, 1, 0); // G
    quad(5, 1, 0, 4);
    
    glColor3f(0, 0, 1); // B
    quad(7, 3, 1, 5);
    
    glColor3f(1, 0, 1); // P
    quad(4, 0, 2, 6);
    
    glColor3f(1, 1, 0); // Y
    quad(2, 0, 1, 3);
    
    glColor3f(0, 1, 1); // Q
    quad(7, 5, 4, 6);
}

void cubeSegment (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
//    cube();
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_INT, 0, pt);
    GLubyte vertIndex [] = {6, 2, 3, 7, 5, 1, 0, 4, 7, 3, 1, 5, 4, 0, 2, 6, 2, 0, 1, 3, 7, 5, 4, 6};
    glDrawElements(GL_QUADS, 24, GL_UNSIGNED_BYTE, vertIndex);
    glDisableClientState(GL_VERTEX_ARRAY);
    
    glFlush();
}

void bitmapSegment (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(0, 1, 1);
    
    GLubyte bitShape [20] = {0x1c, 0x00, 0x1c, 0x00, 0x1c, 0x00, 0x1c, 0x00, 0xff, 0x80, 0x7f, 0x00, 0x3e, 0x00, 0x1c, 0x00, 0x08, 0x00};
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1); // set pixel storage mode.
    glRasterPos2i(100, 75);
    glBitmap(9, 10, 0, 0, 20, 15, bitShape);
    
    glFlush();
}

void glCharacter()
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1, 1, 0);
    
    glRasterPos2i(30, 50);
    char text [36] = "abcdefghijklmnopqrstuvwxyz1234567890";
    for(int i = 0; i < 36; i++)
    {
        glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, text[i]); // bitmap font
//        glutStrokeCharacter(GLUT_STROKE_ROMAN, text[i]); // stroke font
    }
    
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
//    glutDisplayFunc(polygonSegment);
//    glutDisplayFunc(quadSegment);
//    glutDisplayFunc(cubeSegment);
//    glutDisplayFunc(bitmapSegment);
    glutDisplayFunc(glCharacter);
    errorCheck(); // must set before MainLoop.
    glutMainLoop();
    
    return 1;
}
