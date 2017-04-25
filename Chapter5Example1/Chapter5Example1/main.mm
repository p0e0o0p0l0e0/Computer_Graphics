//
//  main.m
//  Chapter5Example1
//
//  Created by 张琳琪 on 2017/4/24.
//  Copyright © 2017年 张琳琪. All rights reserved.
//
#include <GLUT/GLUT.h>
#include <iostream>

GLsizei winWidth = 600, winHeight = 500; // Initial display window size.

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-10, 10, -10, 10); // 屏幕的坐标范围
}

// character function

void glCharacter (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1, 1, 0);
    
    glRasterPos2i(-100, -100); // ? 为什么对stroke字符不起作用？
    char text [13] = "abcdefghijkl"; //长度要比字符个数多1，若为.c文件，则不需要多1.
    
    glLineWidth(5.0);
    glEnable(GL_LINE_STIPPLE);
    glLineStipple(1, 0x0101); // 点状线
    
    for(int i = 0; i < 13; i++)
    {
//        glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, text[i]); // bitmap font
        glutStrokeCharacter(GLUT_STROKE_ROMAN, text[i]); // stroke font
    }
    glDisable(GL_LINE_STIPPLE);
    
    glFlush();
}

// polygon fill pattern

void fillPolygon (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLubyte fillPattern [] = {
        0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00
    };
    
    glPolygonStipple(fillPattern);
    glEnable(GL_POLYGON_STIPPLE);
    
    glBegin(GL_TRIANGLES);
    
    glColor3f(1.0, 0.0, 0.0);
    glVertex2i(0, 0);
    glColor3f(0.0, 1.0, 0.0);
    glVertex2i(5, 0);
    glColor3f(0.0, 0.0, 1.0);
    glVertex2i(0, 5);
    
    glEnd();
    
    glDisable(GL_POLYGON_STIPPLE);
    
    glFlush();
}

// polygon 线框图

void drawPolygon (void)
{
//    glClear(GL_COLOR_BUFFER_BIT); // 注意：如果此处执行glClear，那么第一次画出的红色三角填充将被清除
    
    glBegin(GL_TRIANGLES);
    
    glVertex2i(0, 0);
//    glEdgeFlag(GL_FALSE); // 对于凹多边形来说，消除多余的边。指明对于点(5,0)，它不是一条边的前端点。
    glVertex2i(5, 0);
//    glEdgeFlag(GL_TRUE);
    glVertex2i(0, 5);
    
    // 也可以用边标志数组显示边的状态
//    glEnableClientState(GL_EDGE_FLAG_ARRAY);
//    glEdgeFlagPointer(offset, edgeFlagArray);
//    glDisableClientState(GL_EDGE_FLAG_ARRAY);
    
    glEnd();
    
//    glFlush();
}

void polygonLine (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 0.0, 0.0);
    glEnable(GL_POLYGON_OFFSET_FILL);
    glEnable(GL_POLYGON_SMOOTH); // 并没有效果，用GL_LINE_SMOOTH也没有效果
    glPolygonOffset(1.0, 1.0); // 深度位移方法，防止stitching。两因子典型值为0.75和1.0
    drawPolygon();
    glDisable(GL_POLYGON_SMOOTH);
    glDisable(GL_POLYGON_OFFSET_FILL);
    
    glColor3f(0.0, 1.0, 0.0);
    glPolygonMode(GL_FRONT, GL_LINE);
    drawPolygon();
    
    glFlush();
}

// 多边形前向面函数

void drawPolygon1 (void)
{
    glPolygonMode(GL_FRONT, GL_FILL); //前向面为填充
    glPolygonMode(GL_BACK, GL_LINE); //后向面为线框
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK); // 剔除后向面图形
    
    glFrontFace(GL_CW); // 定义顺时针为前向面
    
    glColor3f(1.0, 0.0, 0.0);
    
    glBegin(GL_POLYGON);
    
    glVertex2i(0, 0); // 此顺序为逆时针，因此为线框
    glVertex2i(5, 0);
    glVertex2i(0, 5);
    
    glEnd();
    
    glColor3f(0.0, 1.0, 0.0);
    
    glBegin(GL_POLYGON);
    
    glVertex2i(-6, -6); // 此顺序为顺时针，因此为填充
    glVertex2i(-1, 0);
    glVertex2i(-1, -6);
    glEnd();
    
    glDisable(GL_CULL_FACE);// disable一定在画完多边形之后再执行。
    
    glFlush();
}

// color smooth or flat

void smoothLine (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glShadeModel(GL_SMOOTH); // 默认为GL_SMOOTH模式。还有GL_FLAT模式，线段用单一颜色最后设置的颜色显示
    
    glBegin(GL_LINES);
    
    glColor3f(0.0, 0.0, 1.0);
    glVertex2i(0, 0);
    glColor3f(1.0, 0.0, 0.0);
    glVertex2i(5, 5);
    
    glEnd();
    
    glFlush();
}

// line plot

typedef struct {
    float x, y;
}wcPt2D;

wcPt2D dataPts [5];

void linePlot (wcPt2D dataPts [5])
{
    glBegin(GL_LINE_STRIP);
    
    for(int k = 0; k < 5; k++)
    {
        glVertex2f(dataPts[k].x, dataPts[k].y);
    }
    
    glEnd();
}

void linePlotFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    dataPts[0].x = -10;
    dataPts[0].y = -10;
    dataPts[1].x = -6;
    dataPts[1].y = -6;
    dataPts[2].x = -3;
    dataPts[2].y = -8;
    dataPts[3].x = 0;
    dataPts[3].y = 5;
    dataPts[4].x = 4;
    dataPts[4].y = 7;
    
    glEnable(GL_LINE_STIPPLE);
    
    glColor3f(1.0, 0.0, 0.0);
    glLineStipple(1, 0x1C47); // 点线
    linePlot(dataPts);
    
    dataPts[1].x = -8;
    dataPts[1].y = 1;
    dataPts[2].x = -5;
    dataPts[2].y = -3;
    dataPts[3].x = -1;
    dataPts[3].y = 4;
    dataPts[4].x = 8;
    dataPts[4].y = 2;
    
    glColor3f(0.0, 1.0, 0.0);
    glLineStipple(1, 0x0101); // 点状
    glLineWidth(5.0); // 线宽10
    linePlot(dataPts);
    
    dataPts[1].x = -5;
    dataPts[1].y = 5;
    dataPts[2].x = -3;
    dataPts[2].y = -3;
    dataPts[3].x = 1;
    dataPts[3].y = -4;
    dataPts[4].x = 6;
    dataPts[4].y = -8;
    
    glColor3f(0.0, 0.0, 1.0);
    glLineStipple(1, 0x00FF); // 线状
    linePlot(dataPts);
    
    glDisable(GL_LINE_STIPPLE);
    
    glFlush();
}

// point size

void pointSize (void)
{
    GLint size = 0;
    glGetIntegerv(GL_POINT_SIZE_MAX, & size);
    std::cout << "size : ";
    std::cout << size;
    // 问题：size大于256左右时，点的大小不再变化？GL_POINT_SIZE_MAX为256，why?
    
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPointSize(30); // 必须放在glBegin和glEnd外面.
    
    glBegin(GL_POINTS);
    
    glColor3f(1.0, 0.0, 0.0);
    glVertex2i(5, 8);
    glColor3f(0.0, 1.0, 0.0);
    glVertex2i(-2, 3);
    glColor3f(0.0, 0.0, 1.0);
    glVertex2i(5, -4);
    
    glEnd();
    
    glFlush();
}

// color array

typedef GLint vertex3 [3], color3 [3];
vertex3 pt [8] = {
    {0, 0, 0}, {0, 5, 0}, {5, 0, 0}, {5, 5, 0}, {0, 0, 5}, {0, 5, 5},
    {5, 0, 5}, {5, 5, 5}
};
color3 hue [8] = {
    {1, 0, 0}, {1, 0, 0}, {0, 0, 1}, {0, 0, 1}, {1, 0, 0}, {1, 0, 0},
    {0, 0, 1}, {0, 0, 1},
};

GLfloat hueAndPt [] = {
  1, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 5, 0,
    0, 0, 1, 5, 0, 0
};

void colorArray (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 0.0, 0.0);

    // 问题：这一段注释掉color部分可以显示，但不注释则无法显示
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glEnableClientState(GL_COLOR_ARRAY);
//    glVertexPointer(3, GL_INT, 0, pt);
//    glColorPointer(3, GL_INT, 0, hue);
//    GLubyte vertIndex [] = {6, 2, 3, 7, 5, 1, 0, 4, 7, 3, 1, 5, 4, 0, 2, 6, 2, 0, 1, 3, 7, 5, 4, 6};
//    glDrawElements(GL_QUADS, 24, GL_UNSIGNED_BYTE, vertIndex);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glDisableClientState(GL_COLOR_ARRAY);
    
    glInterleavedArrays(GL_C3F_V3F, 0, hueAndPt);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
    
    glFlush();
}

void winReshapeFcn (GLint newWidth, GLint newHeight)
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
//    gluOrtho2D(0.0, (GLdouble) newWidth, 0.0, (GLdouble) newHeight);
    gluOrtho2D(0.0, (GLdouble) winWidth, 0.0, (GLdouble) winHeight);
    
    glClear(GL_COLOR_BUFFER_BIT);
}

void quaryFcn (void)
{
    GLint lineWidth = 0;
    glGetIntegerv(GL_LINE_WIDTH, &lineWidth);
    std::cout << "lineWidth : " << lineWidth << "\n";
    
    glColor3f(1.0, 0.0, 0.0);
    GLfloat colorvalue [4]; // 如果数组长度为3则会报错: Thread1:signal SIGABRT, 报错信息为: symbol stub for : __stack_chk_fail.
    glGetFloatv(GL_CURRENT_COLOR, &colorvalue[0]);
    std::cout << "color value : " << colorvalue[0] << "," << colorvalue[1] << "," << colorvalue[2] << "\n";
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(winWidth, winHeight);
    glutCreateWindow("Draw Curves");
    
    init();
//    glutDisplayFunc(colorArray);
//    glutDisplayFunc(pointSize);
//    glutDisplayFunc(linePlotFcn);
//    glutDisplayFunc(smoothLine);
//    glutDisplayFunc(fillPolygon);
    glutDisplayFunc(polygonLine);
//    glutDisplayFunc(drawPolygon1);
//    glutDisplayFunc(glCharacter);
//    glutReshapeFunc(winReshapeFcn);
    
    quaryFcn();
    glutMainLoop();
    
    return 0;
}
