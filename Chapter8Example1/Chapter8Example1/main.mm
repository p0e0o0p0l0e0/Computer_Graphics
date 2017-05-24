//
//  main.mm
//  Chapter8Example1
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
    gluOrtho2D(-100, 100, -100, 100);
    
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


// 显示窗口为600*300，屏幕被glViewPort分割成4个视口，每块是300*150
// 每个视口里的坐标是由glOrtho2D决定的，-100到100的200*200
// 其中原点(0,0)在视口的中心，视口之后的画点和画线都是以视口中的坐标系为准
void displayFcn (void)
{
    wcPt2D verts [3] = {{-50.0, -25.0}, {50.0, -25.0}, {0.0, 50.0}};
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    line(-100, 0, 100, 0);
    line(0, -150, 0, 150);
    
    glColor3f(0.0, 0.0, 1.0);
    glViewport(0, 0, 300, 150);
    triangle(verts);
    line(-50, 0, 200, 0); // 坐标突破视口则不会显示
    line(0, -100, 0, 100); // 视口的坐标是按glOrtho2D设置的
    
    glColor3f(1.0, 0.0, 0.0);
    glViewport(0, 150, 300, 150);
    glRotatef(90.0, 0.0, 0.0, 1.0);
    triangle(verts);
    
    glColor3f(1.0, 1.0, 0.0);
    glViewport(300, 0, 300, 150);
    glRotatef(-90.0, 0.0, 0.0, 1.0);
    triangle(verts);
    
    glColor3f(0.0, 1.0, 1.0);
    glViewport(300, 150, 300, 150);
    glRotatef(90.0, 0.0, 0.0, 1.0);
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

