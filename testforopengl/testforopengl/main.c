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

void lineSegment (void)
{
    glClear (GL_COLOR_BUFFER_BIT);
    
    glColor3f(0.0, 0.4, 0.2);
    glBegin(GL_LINES);
    glVertex2i(180, 15);
    glVertex2i(10, 145);
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
    glutDisplayFunc(pointSegment);
    errorCheck(); // must set before MainLoop.
    glutMainLoop();
    
    return 1;
}
