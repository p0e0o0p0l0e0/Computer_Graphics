//
//  main.mm
//  Chapter14Example2
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
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-250, 250, -250, 250);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLfloat ctrlPts [4][3] = {{-40.0, -40.0, 0.0}, {-10.0, 200.0, 0.0}, {10.0, -200.0, 0.0}, {40.0, 40.0, 0.0}};
    glMap1f(GL_MAP1_VERTEX_3, uMin, uMax, 3, 4, *ctrlPts);
    glEnable(GL_MAP1_VERTEX_3);
    
    glColor3f(0.0, 0.0, 1.0);
    GLint k;
//    GLfloat step, uValue;
//    step = (uMax - uMin) / 50;
//    glBegin(GL_LINE_STRIP);
//    for (uValue = uMin; uValue <= uMax; uValue += step) {
//        glEvalCoord1f(uValue);
//    }
//    glEnd();
    glMapGrid1f(50, uMin, uMax); // 把u区间分成50份
    glEvalMesh1(GL_LINE, 0, 40); // 可以只画一部分曲线u=0到u=40
    glColor3f(0.0, 1.0, 0.0);
    glEvalMesh1(GL_LINE, 40, 50);
    
    glColor3f(1.0, 0.0, 0.0);
    glPointSize(5.0);
    glBegin(GL_POINTS);
    for (k = 0; k < 4; k++) {
        glVertex3fv(&ctrlPts[k][0]);
    }
    glEnd();
    glDisable(GL_MAP1_VERTEX_3);
    
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
    glutCreateWindow("OpenGL Bézier Curve");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}
