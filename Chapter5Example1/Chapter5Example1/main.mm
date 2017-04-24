//
//  main.m
//  Chapter5Example1
//
//  Created by 张琳琪 on 2017/4/24.
//  Copyright © 2017年 张琳琪. All rights reserved.
//
#include <GLUT/GLUT.h>

GLsizei winWidth = 600, winHeight = 500; // Initial display window size.

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-10, 10, -10, 10); // 屏幕的坐标范围
}

// color array

typedef GLint vertex3 [3], color3 [3];
vertex3 pt [8] = {
    {0, 0, 0}, {0, 5, 0}, {5, 0, 0}, {5, 5, 0}, {0, 0, 5}, {0, 5, 5},
    {5, 0, 5}, {5, 5, 5}
};
color3 hue [8] = {
    {1, 0, 0}, {1, 0, 0}, {0, 0, 1}, {0, 0, 1}, {1, 0, 0}, {1, 0, 0},
    {0, 0, 1}, {0, 0, 1},
};

GLfloat hueAndPt [] = {
  1, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 5, 0,
    0, 0, 1, 5, 0, 0
};

void colorArray (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 0.0, 0.0);

    // 问题：这一段注释掉color部分可以显示，但不注释则无法显示
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glEnableClientState(GL_COLOR_ARRAY);
//    glVertexPointer(3, GL_INT, 0, pt);
//    glColorPointer(3, GL_INT, 0, hue);
//    GLubyte vertIndex [] = {6, 2, 3, 7, 5, 1, 0, 4, 7, 3, 1, 5, 4, 0, 2, 6, 2, 0, 1, 3, 7, 5, 4, 6};
//    glDrawElements(GL_QUADS, 24, GL_UNSIGNED_BYTE, vertIndex);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glDisableClientState(GL_COLOR_ARRAY);
    
    glInterleavedArrays(GL_C3F_V3F, 0, hueAndPt);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
    
    glFlush();
}

void winReshapeFcn (GLint newWidth, GLint newHeight)
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
//    gluOrtho2D(0.0, (GLdouble) newWidth, 0.0, (GLdouble) newHeight);
    gluOrtho2D(0.0, (GLdouble) winWidth, 0.0, (GLdouble) winHeight);
    
    glClear(GL_COLOR_BUFFER_BIT);
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(winWidth, winHeight);
    glutCreateWindow("Draw Curves");
    
    init();
    glutDisplayFunc(colorArray);
//    glutReshapeFunc(winReshapeFcn);
    
    glutMainLoop();
    
    return 0;
}
