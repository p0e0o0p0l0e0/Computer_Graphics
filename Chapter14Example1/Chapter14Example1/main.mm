//
//  main.mm
//  Chapter14Example1
//
//  Created by 张琳琪 on 2017/6/16.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <math.h>

GLsizei winWidth = 500, winHeight = 500;

GLfloat xwcMin = -50.0, xwcMax = 50.0;
GLfloat ywcMin = -50.0, ywcMax = 50.0;

class wcPt3D {
public:
    GLfloat x, y, z;
};

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(xwcMin, xwcMax, ywcMin, ywcMax);
}

void plotPoint (wcPt3D bezCurvePt)
{
    glBegin(GL_POINTS);
    glVertex2f(bezCurvePt.x, bezCurvePt.y);
    glEnd();
}

void binomialCoeffs (GLint n, GLint * C)
{
    GLint k, j;
    
    for (k = 0; k <= n; k++)
    {
        C[k] = 1;
        for (j = n; j >= k + 1; j--)
        {
            C[k] *= j;
        }
        for (j = n - k; j >= 2; j--)
        {
            C[k] /= j;
        }
    }
}

void computeBezPt (GLfloat u, wcPt3D * bezPt, GLint nCtrlPts, wcPt3D * ctrlPts, GLint * C)
{
    GLint k, n = nCtrlPts - 1;
    GLfloat bezBlendFcn;
    bezPt->x = bezPt->y = bezPt->z = 0.0;
    
    for (k = 0; k < nCtrlPts; k++)
    {
        bezBlendFcn = C[k] * pow(u, k) * pow(1 - u, n - k);
        bezPt->x += ctrlPts[k].x * bezBlendFcn;
        bezPt->y += ctrlPts[k].y * bezBlendFcn;
        bezPt->z += ctrlPts[k].z * bezBlendFcn;
    }
}

void bezier (wcPt3D * ctrlPts, GLint nCtrlPts, GLint nBezCurvePts)
{
    wcPt3D bezCurvePt;
    GLfloat u;
    GLint *C, k;
    
    C = new GLint [nCtrlPts];
    
    binomialCoeffs(nCtrlPts - 1, C);
    for (k = 0; k <= nBezCurvePts; k++)
    {
        u = GLfloat(k) / nBezCurvePts;
        computeBezPt(u, &bezCurvePt, nCtrlPts, ctrlPts, C);
        plotPoint(bezCurvePt);
    }
    delete [] C;
}

void displayFcn (void)
{
    GLint nCtrlPts = 4, nBezCurvePts = 1000;
    wcPt3D ctrlPts [4] = {{-40.0, -40.0, 0.0}, {-10.0, 200.0, 0.0},
        {10.0, -200.0, 0.0}, {40.0, 40.0, 0.0}};
    glClear(GL_COLOR_BUFFER_BIT);
    glPointSize(4.0);
    glColor3f(1.0, 0.0, 0.0);
    
    bezier(ctrlPts, nCtrlPts, nBezCurvePts);
    glFlush();
}

void winReshapeFcn (GLint newWidth, GLint newHeight)
{
    glViewport(0, 0, newWidth, newHeight);
    
    glutPostRedisplay();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(winWidth, winHeight);
    glutCreateWindow("Bezier Curve");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}
