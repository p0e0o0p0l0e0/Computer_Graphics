//
//  main.mm
//  Chapter9Example1
//
//  Created by 张琳琪 on 2017/6/7.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <math.h>

class wcPt3D {
public:
    GLfloat x, y, z;
};

typedef GLfloat Matrix4x4 [4][4];
Matrix4x4 matComposite;

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-20, 20, -20, 20);
}

void matrix4x4SetIdentity (Matrix4x4 matIdentity)
{
    GLint row, col;
    for(row = 0; row < 4; row++)
    {
        for (col = 0; col < 4; col++) {
            matIdentity[row][col] = (row == col);
        }
    }
}

void matrix4x4PreMultiply (Matrix4x4 m1, Matrix4x4 m2)
{
    GLint row, col;
    Matrix4x4 matTemp;
    
    for(row = 0; row < 4; row++)
    {
        for (col = 0; col < 4; col++) {
            matTemp[row][col] = m1[row][0] * m2[0][col] + m1[row][1] * m2[1][col] + m1[row][2] * m2[2][col] + m1[row][3] * m2[3][col];
        }
    }
    
    for (row = 0; row < 4; row++) {
        for (col = 0; col < 4; col++) {
            m2[row][col] = matTemp[row][col];
        }
    }
}

void translate3D (GLfloat tx, GLfloat ty, GLfloat tz)
{
    Matrix4x4 matTransl3D;
    matrix4x4SetIdentity(matTransl3D);
    
    matTransl3D[0][3] = tx;
    matTransl3D[1][3] = ty;
    matTransl3D[2][3] = tz;
    
    matrix4x4PreMultiply(matTransl3D, matComposite);
}

void rotate3D (wcPt3D p1, wcPt3D p2, GLfloat radianAngle)
{
    Matrix4x4 matQuatRot;
    matrix4x4SetIdentity(matQuatRot);
    
    float axisVectLength = sqrtf((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y) + (p2.z - p1.z) * (p2.z - p1.z));
    float cosA = cosf(radianAngle);
    float sinA = sinf(radianAngle);
    float oneC = 1 - cosA;
    float ux = (p2.x - p1.x) / axisVectLength;
    float uy = (p2.y - p1.y) / axisVectLength;
    float uz = (p2.z - p1.z) / axisVectLength;
    
    translate3D(-p1.x, -p1.y, -p1.z);
    matQuatRot[0][0] = ux * ux * oneC + cosA;
    matQuatRot[0][1] = ux * uy * oneC - uz * sinA;
    matQuatRot[0][2] = ux * uz * oneC + uy * sinA;
    matQuatRot[1][0] = uy * ux * oneC + uz * sinA;
    matQuatRot[1][1] = uy * uy * oneC + cosA;
    matQuatRot[1][2] = uy * uz * oneC - ux * sinA;
    matQuatRot[2][0] = uz * ux * oneC - uy * sinA;
    matQuatRot[2][1] = uz * uy * oneC + ux * sinA;
    matQuatRot[2][2] = uz * uz * oneC + cosA;
    
    matrix4x4PreMultiply(matQuatRot, matComposite);
    translate3D(p1.x, p1.y, p1.z);
}

void scale3D (GLfloat sx, GLfloat sy, GLfloat sz, wcPt3D fixedPt)
{
    Matrix4x4 matScale3D;
    matrix4x4SetIdentity(matScale3D);
    
    matScale3D[0][0] = sx;
    matScale3D[1][1] = sy;
    matScale3D[2][2] = sz;
    matScale3D[0][3] = (1 - sx) * fixedPt.x;
    matScale3D[1][3] = (1 - sy) * fixedPt.y;
    matScale3D[2][3] = (1 - sz) * fixedPt.z;
    
    matrix4x4PreMultiply(matScale3D, matComposite);
}

void transformVerts3D (GLint nVerts, wcPt3D * verts)
{
    GLint k;
    GLfloat tempX, tempY;
    
    for (k = 0; k < nVerts; k++) {
        tempX = matComposite[0][0] * verts[k].x + matComposite[0][1] * verts[k].y + matComposite[0][2] * verts[k].z + matComposite[0][3];
        tempY = matComposite[1][0] * verts[k].x + matComposite[1][1] * verts[k].y + matComposite[1][2] * verts[k].z + matComposite[1][3];
        verts[k].z = matComposite[2][0] * verts[k].x + matComposite[2][1] * verts[k].y + matComposite[2][2] * verts[k].z + matComposite[2][3];
        verts[k].x = tempX;
        verts[k].y = tempY;
    }
}

void drawAxis (void)
{
    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_LINES);
    glVertex2f(-20.0, 0.0);
    glVertex2f(20.0, 0.0);
    glEnd();
    
    glBegin(GL_LINES);
    glVertex2f(0.0, 20.0);
    glVertex2f(0.0, -20.0);
    glEnd();
}

void triangle (wcPt3D * verts)
{
    glEnable(GL_SMOOTH);
    GLint k;
    glBegin(GL_TRIANGLES);
    for (k = 0; k < 3; k++) {
        if(k == 0)
        {
            glColor3f(1.0, 0.0, 0.0);
        }
        else if(k == 1)
        {
            glColor3f(0.0, 1.0, 0.0);
        }
        else
        {
            glColor3f(0.0, 0.0, 1.0);
        }
        glVertex2f(verts[k].x, verts[k].y);
    }
    glEnd();
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    drawAxis();
    
    matrix4x4SetIdentity(matComposite);
    
    wcPt3D verts[3] = {{1.0, 1.0, 0.0}, {5.0, 1.0, 0.0}, {3.0, 6.0, 0.0}};
    triangle(verts);
    
    GLfloat sx = -1.5, sy = -1.5, sz = -1.5;
    GLfloat tx = 1.0, ty = 1.0, tz = 5.0;
    GLfloat angle = 2.09; // 120°
    wcPt3D p1, p2;
    p1 = {0.0, 1.0, 0.0};
    p2 = {10.0, 1.0, 0.0};
    wcPt3D centerPt = {1, 1, 0};
    
    rotate3D(p1, p2, angle);
    scale3D(sx, sy, sz, centerPt);
    translate3D(tx, ty, tz);
    transformVerts3D(3, verts);
    triangle(verts);
    
    glFlush();
}

int main(int argc, char * argv[]) {
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowPosition(-50, 50);
    glutInitWindowSize(400, 400);
    glutCreateWindow("3D Composite Translate");
    
    init();
    
    glutDisplayFunc(displayFcn);
    glutMainLoop();
    
    return 0;
}
