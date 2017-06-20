//
//  main.mm
//  Chapter14Example3
//
//  Created by 张琳琪 on 2017/6/20.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

GLsizei winWidht = 500, winHeight = 500;
GLfloat uMin = 1.0, uMax = 20.0;

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(5.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustum(-5.0, 5.0, -5.0, 5.0, 4.0, 10.0);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLfloat ctrlPts [4][4][3] = {
        {{-1.5, -1.5, 4.0}, {-0.5, -1.5, 2.0}, {-0.5, -1.5, -1.0}, {1.5, -1.5, 2.0}},
        {{-1.5, -0.5, 1.0}, {-0.5, -0.5, 3.0}, {0.5, -0.5, 0.0},   {1.5, -0.5, -1.0}},
        {{-1.5, 0.5, 4.0},  {-0.5, 0.5, 0.0},  {0.5, 0.5, 3.0},    {1.5, 0.5, 4.0}},
        {{-1.5, 1.5, -2.0}, {-0.5, 1.5, -2.0}, {0.5, 1.5, 0.0},    {1.5, 1.5, -1.0}} };
    
    glMap2f(GL_MAP2_VERTEX_3, 0.0, 1.0, 3, 4, 0.0, 1.0, 12, 4, &ctrlPts[0][0][0]);
    glEnable(GL_MAP2_VERTEX_3);
    
//    GLint k, j;
//    glColor3f(0.0, 0.0, 1.0);
//    for (k = 0; k <= 8; k++) {
//        glBegin(GL_LINE_STRIP);
//        for (j = 0; j <= 40; j++) {
//            glEvalCoord2f(GLfloat(j)/40.0, GLfloat(k)/8.0);
//        }
//        glEnd();
//        glBegin(GL_LINE_STRIP);
//        for (j = 0; j <= 40; j++) {
//            glEvalCoord2f(GLfloat(k)/8.0, GLfloat(j)/40.0);
//        }
//        glEnd();
//    }

    glColor3f(0.0, 0.0, 1.0);
//    glMapGrid2f(8, 0.0, 1.0, 8, 0.0, 1.0);
//    glEvalMesh2(GL_LINE, 0, 8, 0, 8);
    
    for(int k = 0; k < 8; k++)
    {
        glBegin(GL_QUAD_STRIP);
        for (int j = 0; j < 8; j++) {
            glEvalCoord2f(GLfloat(k) / 8, GLfloat(j) / 8);
            glEvalCoord2f(GLfloat(k+1) / 8, GLfloat(j) / 8);
        }
        glEnd();
    }
    
    glDisable(GL_MAP2_VERTEX_3);
    
    glFlush();
}

void winReshapeFcn (GLint newWidth, GLint newHeight)
{
    glViewport(0, 0, newWidth, newHeight);
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(winWidht, winHeight);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("OpenGL Bézier Curve Surface");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}
