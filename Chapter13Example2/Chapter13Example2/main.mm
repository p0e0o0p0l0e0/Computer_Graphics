//
//  main.mm
//  Chapter13Example2
//
//  Created by 张琳琪 on 2017/6/15.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>

GLsizei winWidth = 500, winHeight = 500;

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    glMatrixMode(GL_PROJECTION);
    glFrustum(-1, 1, -1, 1, 2, 20);
    
    glMatrixMode(GL_MODELVIEW);
    gluLookAt(5, 5, 5, 0, 0, 0, 0, 1, 0);
    
}

void axis (void)
{
    glColor3f(1.0, 0.0, 0.0);
    glPointSize(3.0);
    glBegin(GL_POINTS);
    glVertex3f(0.0, 0.0, 0.0);
    glEnd();
    
    glLineWidth(2.0);
    glBegin(GL_LINES);
    glColor3f(1.0, 0.0, 0.0); // red z
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 10.0);
    glColor3f(0.0, 1.0, 0.0); // green x
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(10.0, 0.0, 0.0);
    glColor3f(0.0, 0.0, 1.0); // blue y
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 10.0, 0.0);
    glEnd();
    
    glLineWidth(1.0);
    glPointSize(1.0);
}

void errorCallback()
{
    std::cout << "new quadric error" << std::endl;
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    axis();
    
    glColor3f(0.0, 0.0, 1.0);
    
//    glutWireTeapot(2.0);  // 茶壶面
//    glutWireSphere(2.0, 20, 20); // 球面
//    glutWireCone(3.0, 2.0, 10, 5); // 圆锥面
//    glutWireTorus(1, 2, 10, 20); // 圆环面
    
    GLUquadricObj * sphere1;
    sphere1 = gluNewQuadric();
    gluQuadricDrawStyle(sphere1, GLU_FILL);
    gluQuadricOrientation(sphere1, GLU_INSIDE);
    gluSphere(sphere1, 2.0, 10, 20); // 球面
//    gluCylinder(sphere1, 3.0, 1.0, 4.0, 10.0, 20.0); // 圆锥面、圆柱面
//    gluDisk(sphere1, 1.0, 3.0, 10.0, 5.0); // 平的圆环面或圆盘
//    gluPartialDisk(sphere1, 1.0, 3.0, 10.0, 5.0, 30, 90); // 平的圆环面的一部分
    gluDeleteQuadric(sphere1); // doesn't work
    gluQuadricNormals(sphere1, GLU_SMOOTH); // how to use
//    gluQuadricCallback(sphere1, GLU_ERROR, errorCallback);
    
    glFlush();
}

void reshapeFcn (GLint newWidth, GLint newHeight)
{
    glViewport(0, 0, newWidth, newHeight);
    winWidth = newWidth, winHeight = newHeight;
    
    glutPostRedisplay();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(winWidth, winHeight);
    glutCreateWindow("Quadric");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(reshapeFcn);
    glutMainLoop();

    return 0;
}
