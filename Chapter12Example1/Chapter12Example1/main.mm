//
//  main.mm
//  Chapter12Example1
//
//  Created by 张琳琪 on 2017/6/13.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <math.h>
#include <stdlib.h>

const double TWO_PI = 6.2831853;
GLsizei winWidth = 500, winHeight = 500;
GLuint regHex;
static GLfloat rotTheta = 0.0;

class scrPt {
public:
    GLint x, y;
};

static void init (void)
{
    scrPt hexVertex;
    GLdouble hexTheta = 0.0;
    GLint k;
    
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    regHex = glGenLists(1);
    glNewList(regHex, GL_COMPILE);
    glColor3f(1.0, 0.0, 0.0);
    glBegin(GL_POLYGON);
    for (k = 0; k < 6; k++) {
        hexTheta = TWO_PI * k / 6;
        hexVertex.x = 150 + 100 * cos(hexTheta);
        hexVertex.y = 150 + 100 * sin(hexTheta);
        glVertex2i(hexVertex.x, hexVertex.y);
    }
    glEnd();
    glEndList();
}

void displayHex (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPushMatrix();
    glRotatef(rotTheta, 0.0, 0.0, 1.0);
    glCallList(regHex);
    glPopMatrix();
    
    glutSwapBuffers();
    
//    glFlush();        // 可以不加
}

void rotateHex (void)
{
    rotTheta += 3.0;
    if(rotTheta > 360.0)
        rotTheta -= 360.0;
    
    glutPostRedisplay();
//    displayHex();  // 和调用glutPostRedisplay()效果一样
}

void winReshapeFcn (GLint newWidth, GLint newHeight)
{
    glViewport(0, 0, (GLsizei)newWidth, (GLsizei)newHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-320.0, 320.0, -320.0, 320.0);;
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glClear(GL_COLOR_BUFFER_BIT);
}

void mouseFcn (GLint button, GLint action, GLint x, GLint y)
{
    switch (button)
    {
        case GLUT_LEFT_BUTTON:
            if(action == GLUT_DOWN)
                glutIdleFunc(rotateHex);
            break;
        case GLUT_RIGHT_BUTTON:
            if(action == GLUT_DOWN)
                glutIdleFunc(NULL);
        default:
            break;
    }
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowSize(winWidth, winHeight);
    glutInitWindowPosition(150, 150);
    glutCreateWindow("Animation Example");
    
    init();
    glutDisplayFunc(displayHex);
    glutReshapeFunc(winReshapeFcn);
    glutMouseFunc(mouseFcn);
    
    glutMainLoop();
    
    return 0;
}
