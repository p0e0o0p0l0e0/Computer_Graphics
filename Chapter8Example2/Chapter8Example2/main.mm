//
//  main.mm
//  Chapter8Example2
//
//  Created by 张琳琪 on 2017/5/24.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

class wcPt2D{
public:
    GLfloat x, y;
};


void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    glMatrixMode(GL_PROJECTION);
//    gluOrtho2D(-100, 100, -100, 100);
    
    glMatrixMode(GL_MODELVIEW);
}

void triangle (wcPt2D * verts)
{
    GLint k;
    
    glBegin(GL_TRIANGLES);
    for(k = 0; k < 3; k++)
    {
        glVertex2f(verts[k].x, verts[k].y);
    }
    glEnd();
}

void line (GLint x1, GLint y1, GLint x2, GLint y2)
{
    glBegin(GL_LINES);
    glVertex2f(x1, y1);
    glVertex2f(x2, y2);
    glEnd();
}

void displayFcn (void)
{
    wcPt2D verts [3] = {{-0.5, -0.25}, {0.5, -0.25}, {0.0, 0.5}};
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    line(-1, 0, 1, 0);
    line(0, -1, 0, 1);
    
    glColor3f(0.0, 0.0, 1.0);
    triangle(verts);
    
    glFlush();
}

int main(int argc, char ** argv)
{
    glutInit (&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(600, 300);
    glutCreateWindow("Split-Screen Example");
    
    init();
    glutDisplayFunc(displayFcn);
    
    glutMainLoop();
}

