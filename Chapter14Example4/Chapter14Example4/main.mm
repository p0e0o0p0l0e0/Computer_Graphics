//
//  main.mm
//  Chapter14Example4
//
//  Created by 张琳琪 on 2017/6/20.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

GLsizei winWidht = 500, winHeight = 500;

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);

    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-10.0, 10.0, -10.0, 10.0);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(0.0, 0.0, 1.0);
    
    GLfloat knotVector [8] = {0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0};
    GLfloat ctrlPts [4][3] = {{-4.0, 0.0, 0.0}, {-2.0, 8.0, 0.0}, {2.0, -8.0, 0.0}, {4.0, 0.0, 0.0}};
    GLUnurbsObj *cubicBezCurve;
    cubicBezCurve = gluNewNurbsRenderer();
    gluBeginCurve(cubicBezCurve);
    gluNurbsCurve(cubicBezCurve, 8, &knotVector[0], 3, &ctrlPts[0][0], 4, GL_MAP1_VERTEX_3);
    gluEndCurve(cubicBezCurve);
    
    glColor3f(0.0, 1.0, 0.0);
    glPointSize(5.0);
    for (int k = 0; k < 4; k++) {
        glBegin(GL_POINTS);
        glVertex3fv(ctrlPts[k]);
        glEnd();
    }
    
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
    glutCreateWindow("GLU B-Spline: Bézier Curve");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}
