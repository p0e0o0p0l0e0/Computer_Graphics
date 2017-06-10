//
//  main.mm
//  Chapter10Example1
//
//  Created by 张琳琪 on 2017/6/9.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <math.h>

GLint winWidth = 600, winHeight = 600;
GLfloat x0 = 50.0, y00 = 50.0, z0 = 50.0; // 这是观察参考点，与观察系原点重合
GLfloat xref = 0.0, yref = 50.0, zref = 0.0; // camera要瞄准的点，不是观察参考点
GLfloat Vx = 0.0, Vy = 1.0, Vz = 0.0;
GLfloat xwMin = -40.0, ywMin = -40.0, xwMax = 40.0, ywMax = 40.0;
GLfloat dnear = 25, dfar = 75;
GLdouble radianAngle = 1.0/360.0 * 3.14159;
GLfloat cos1 = cos(radianAngle);
GLfloat sin1 = sin(radianAngle);

typedef GLint vertex3 [3];
vertex3 pt [8] = {{0, 0, 0}, {0, 100, 0}, {100, 0, 0}, {100, 100, 0},
                {0, 0, 100}, {0, 100, 100}, {100, 0, 100}, {100, 100, 100}};

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    glMatrixMode(GL_MODELVIEW);
    gluLookAt(x0, y00, z0, xref, yref, zref, Vx, Vy, Vz);
    
    glMatrixMode(GL_PROJECTION);
    glFrustum(xwMin, xwMax, ywMin, ywMax, dnear, dfar);
}

void quad (GLint n1, GLint n2, GLint n3, GLint n4)
{
    glBegin(GL_QUADS);
    glVertex3iv(pt[n1]);
    glVertex3iv(pt[n2]);
    glVertex3iv(pt[n3]);
    glVertex3iv(pt[n4]);
    glEnd();
}

void cube ()
{
    glColor3f(0.0, 1.0, 0.0); // back
    quad(0, 2, 3, 1);
    glColor3f(1.0, 0.0, 0.0); // left
    quad(0, 1, 5, 4);
    glColor3f(0.0, 0.0, 1.0); // top
    quad(1, 3, 7, 5);
    glColor3f(1.0, 1.0, 0.0); // front
    quad(4, 5, 7, 6);
    glColor3f(0.0, 1.0, 1.0); // right
    quad(2, 6, 7, 3);
    glColor3f(1.0, 0.0, 1.0); // bottom
    quad(0, 4, 6, 2);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(0.0, 1.0, 0.0);
    glPolygonMode(GL_FRONT, GL_FILL);
    glPolygonMode(GL_BACK, GL_LINE);
//    glFrontFace(GL_CW); // show the back
    
    cube();
    
    glutSwapBuffers();
}

void reshapeFcn (GLint newWidth, GLint newHeight)
{
    glViewport(0, 0, newWidth, newHeight);
    
    winWidth = newWidth;
    winHeight = newHeight;
}

void idleFcn (void)
{
    GLfloat xref1, zref1;
    xref = xref - x0;
    zref = zref - z0;
    zref1 = zref * cos1 - xref * sin1 + z0;
    xref1 = zref * sin1 + xref * cos1 + x0;
    xref = xref1;
    zref = zref1;
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(x0, y00, z0, xref, yref, zref, Vx, Vy, Vz);
    
    displayFcn();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
    glutInitWindowSize(winWidth, winHeight);
    glutInitWindowPosition(50, 50);
    glutCreateWindow("Perspective View of A Square");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(reshapeFcn);
    glutIdleFunc(idleFcn);
    glutMainLoop();
    
    return 0;
}
