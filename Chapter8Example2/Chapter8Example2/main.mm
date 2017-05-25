//
//  main.mm
//  Chapter8Example2
//
//  Created by 张琳琪 on 2017/5/24.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>

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

void displayFcn1 (void)
{
    wcPt2D verts [3] = {{-50, -25}, {50, -25}, {0.0, 50}};
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    line(-100, 0, 100, 0);
    line(0, -100, 0, 100);
    
    glColor3f(0.0, 0.0, 1.0);
    triangle(verts);
    
    glFlush();
}

void displayFcn2 (void)
{
    wcPt2D verts [3] = {{-50, -25}, {50, -25}, {0.0, 50}};
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    line(-100, 0, 100, 0);
    line(0, -100, 0, 100);
    
    glColor3f(1.0, 0.0, 0.0);
    triangle(verts);
    
    glFlush();
}

void displayFcn3 (void)
{
    wcPt2D verts [3] = {{-50, -25}, {50, -25}, {0.0, 50}};
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 1.0, 1.0);
    line(-100, 0, 100, 0);
    line(0, -100, 0, 100);
    
    glColor3f(0.0, 1.0, 0.0);
    triangle(verts);
    
    glFlush();
}

int main(int argc, char ** argv)
{
    glutInit (&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    
    
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(600, 300);
    GLint windowID1 = glutCreateWindow("Split-Screen Example1");
    init();
    glutDisplayFunc(displayFcn1);
    std::cout << "windowID1 : " << windowID1 << std::endl;
    
    glutHideWindow(); // 在此有效
    glutShowWindow(); // 在此有效
//    glutIconifyWindow(); // 在此有效
    
    glutInitWindowPosition(400, 100);
    glutInitWindowSize(600, 300);
    GLint windowID2 = glutCreateWindow("Split-Screen Example2");
    init();
    glutDisplayFunc(displayFcn2);
    std::cout << "windowID2 : " << windowID2 << std::endl;
//    glutFullScreen(); // 不能用在子窗口上，对一级窗口有效
    
    glutInitWindowPosition(100, 300);
    glutInitWindowSize(600, 300);
    GLint subWindowID1 = glutCreateSubWindow(windowID2, 250, 100, 100, 100); // 子窗口的大小和坐标是相对于显示窗口的，600*300的显示窗口的子窗口如果想显示在窗口正中间，距离左下角的坐标应为(250, 100);
    init();
    glutDisplayFunc(displayFcn3);
    std::cout << "subWindowID1 : " << subWindowID1 << std::endl; // subwindow编号是在一级窗口后继续累加
    
    glutSetCursor(GLUT_CURSOR_HELP); // 对子窗口和一级窗口都ok
    GLint posX = glutGet(GLUT_WINDOW_X);
    std::cout << "current window x : " << posX << std::endl;
    
//    glutPushWindow(); // 对当前窗口有效
//    glutPopWindow(); // 对当前窗口有效
//    glutHideWindow(); // 对于子窗口有效
//    glutShowWindow(); // 对于子窗口有效
    
    
    // 大概总结一下，使用SetWindow设置的当前窗口，pop,push,hide,show,iconify等都没有效果
    glutSetWindow(windowID1);
    glutPopWindow(); // 没有效果
    glutSetWindowTitle("new name display on window1");
    
//    glutPostRedisplay(); // 什么时候用？
//    glutIconifyWindow(); // 有飞出的效果，没有图标效果
//    glutSetIconTitle("new new name display on window1"); // 没有效果
    
    glutMainLoop();
}

