//
//  main.mm
//  Chapter8Example4
//
//  Created by 张琳琪 on 2017/5/31.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

GLfloat count = 0.0;

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-20, 20, -20, 20);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_LINE_LOOP);
    glVertex2f(-20.0 + count, -20.0 + count);
    glVertex2f(-20.0 + count, -10.0 + count);
    glVertex2f(-10.0 + count, -10.0 + count);
    glVertex2f(-10.0 + count, -20.0 + count);
    glEnd();
    
    glFlush();
    glutSwapBuffers();
}

void idleFcn (void)
{
    count ++;
    if(count > 30.0)
        count = 0.0;
    displayFcn();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
    glutInitWindowPosition(-50, 50);
    glutInitWindowSize(600, 300);
    glutCreateWindow("Animation");
    
    init();
    
    glutDisplayFunc(displayFcn);
    glutIdleFunc(idleFcn);
    glutMainLoop();
    
    return 0;
}
