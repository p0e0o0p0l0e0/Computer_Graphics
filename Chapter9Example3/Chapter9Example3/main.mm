//
//  main.mm
//  Chapter9Example3
//
//  Created by 张琳琪 on 2017/6/7.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

class wcPt3D{
public:
    GLfloat x, y, z;
};


void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glMatrixMode(GL_PROJECTION);
    glOrtho(-20.0, 20.0, -20.0, 20.0, -10.0, 10.0);
}

void rotate3D (wcPt3D p1, wcPt3D p2, GLfloat thetaDegrees)
{
    float vx = p2.x - p1.x;
    float vy = p2.y - p1.y;
    float vz = p2.z - p1.z;
    glTranslatef(p1.x, p1.y, p1.z);         // step3
    glRotatef(thetaDegrees, vx, vy, vz);    // step2
    glTranslatef(-p1.x, -p1.y, -p1.z);      // step1
}

void scale3D (GLfloat sx, GLfloat sy, GLfloat sz, wcPt3D fixedPt)
{
    glTranslatef(fixedPt.x, fixedPt.y, fixedPt.z);      // step3
    glScalef(sx, sy, sz);                               // step2
    glTranslatef(-fixedPt.x, -fixedPt.y, fixedPt.z);    // step1
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
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    drawAxis();
    
    wcPt3D verts[3] = {{1.0, 1.0, 0.0}, {5.0, 1.0, 0.0}, {3.0, 6.0, 0.0}};
    triangle(verts);
    
    GLfloat sx = -1.5, sy = -1.5, sz = 1.0;
    GLfloat tx = 1.0, ty = 1.0, tz = 5.0; // why z > 1 cannot see the new triangle?
    GLfloat angle = 90; // 角度
    wcPt3D p1, p2;
    p1 = {0.0, 0.0, 0.0};
    p2 = {0.0, 0.0, 10.0};
    wcPt3D centerPt = {1, 1, 0};
    
    glTranslatef(tx, ty, tz);       // step3
    scale3D(sx, sy, sz, centerPt);  // step2
    rotate3D(p1, p2, angle);        // step1
    triangle(verts);
    
    glFlush();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowPosition(-50.0, 50.0);
    glutInitWindowSize(400.0, 400.0);
    glutCreateWindow("3D Transformation");
    
    init();
    glutDisplayFunc(displayFcn);
    glutMainLoop();
    
    return 0;
}
