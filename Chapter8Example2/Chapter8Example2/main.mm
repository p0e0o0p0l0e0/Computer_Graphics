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
    
//    glutHideWindow(); // 在此有效
//    glutShowWindow(); // 在此有效
//    glutIconifyWindow(); // 在此有效
//    glutFullScreen(); // 不能用在子窗口上，对一级窗口有效
    
    glutInitWindowPosition(400, 100);
    glutInitWindowSize(600, 300);
    GLint windowID2 = glutCreateWindow("Split-Screen Example2");
    init();
    glutDisplayFunc(displayFcn2);
    std::cout << "windowID2 : " << windowID2 << std::endl;
    
    glutInitWindowPosition(100, 300);
    glutInitWindowSize(600, 300);
    GLint subWindowID1 = glutCreateSubWindow(windowID2, 250, 100, 100, 100);
    // 子窗口的大小和坐标是相对于显示窗口的，600*300的显示窗口的子窗口如果想显示在窗口正中间，距离左下角的坐标应为(250, 100);
    
    init();
    glutDisplayFunc(displayFcn3);
    std::cout << "subWindowID1 : " << subWindowID1 << std::endl; // subwindow编号是在一级窗口后继续累加
    
    glutSetCursor(GLUT_CURSOR_HELP); // 对子窗口和一级窗口都ok
    GLint posX = glutGet(GLUT_WINDOW_X);
    std::cout << "current window x : " << posX << std::endl;
    GLint currentWindowID1 = glutGetWindow();
    std::cout << "current window id1 : " << currentWindowID1 << std::endl; // 当前窗口是子窗口，id为3
    
//    glutPushWindow(); // 对当前窗口有效，如果当前是子窗口，则子窗口对应的一级窗口push
//    glutPopWindow(); // 对当前窗口有效
//    glutHideWindow(); // 对于子窗口有效
//    glutShowWindow(); // 对于子窗口有效
    
    // ❤️大概总结一下，使用SetWindow设置的当前窗口，pop,push 等都没有效果，其他都ok
    glutSetWindow(windowID1);
    GLint currentWindowID2 = glutGetWindow();
    std::cout << "current window id2 : " << currentWindowID2 << std::endl; // 当前窗口时一级窗口，id为1
    glutSetWindowTitle("new name display on window1"); // 有效
    glutIconifyWindow(); // 有效，最小化在图标上
    glutSetIconTitle("new name display on icon"); // 有效，是最小化后的图标的名称
//    glutFullScreen(); // 有效
//    glutHideWindow(); // 有效
    
//    glutPopWindow(); // 无效，并且如果执行，会对icon和hidewindow之类的有影响
    
//    glutPostRedisplay(); // 什么时候用？
    
    glutMainLoop();
}

