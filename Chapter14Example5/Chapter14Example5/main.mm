//
//  main.mm
//  Chapter14Example5
//
//  Created by 张琳琪 on 2017/6/20.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>

GLsizei winWidht = 500, winHeight = 500;

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-5, 5, -5, 5);
    
//    glMatrixMode(GL_MODELVIEW);
//    glLoadIdentity();
//    gluLookAt(5.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
//    
//    glMatrixMode(GL_PROJECTION);
//    glLoadIdentity();
//    glFrustum(-5.0, 5.0, -5.0, 5.0, 4.0, 20.0);
}

void xyCoords (void)
{
    glBegin(GL_LINES);
    glColor3f(1.0, 0.0, 0.0); // red x axis
    glVertex2i(-10, 0);
    glVertex2i(10, 0);
    glColor3f(0.0, 1.0, 0.0); // green y aixs
    glVertex2i(0, -10);
    glVertex2i(0, 10);
    glEnd();
}

void errorCallback (void)
{
    std::cout << "errorCallback" << std::endl;
}

void displayFcn1 (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(0.0, 0.0, 1.0);
    
    GLfloat ctrlPts [4][4][3] = {
        {{-3, -3, 0.0}, {-1, -3, 0.0},  {1, -3, 0.0},   {3, -3, 0.0}},
        {{-3, -1, 0.0}, {-1, -1, 0.0},  {1, -1, 0.0},   {3, -1, 0.0}},
        {{-3, 1, 0.0},  {-1, 1, 0.0},   {1, 1, 0.0},    {3, 1, 0.0}},
        {{-3, 3, 0.0},  {-1, 3, 0.0},   {1, 3, 0.0},    {3, 3, 0.0}}
    };
    
    GLUnurbsObj *bezSurface;
    GLfloat outerTrimPts [5][2] = {{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 1.0}, {0.0, 0.0}};
    GLfloat innerTrimPts1 [3][2] = {{0.5, 0.25}, {0.01, 0.02}, {0.2, 0.75}};
    GLfloat innerTrimPts2 [4][2] = {{0.2, 0.75}, {0.5, 0.99}, {0.75, 0.5}, {0.5, 0.25}};
    GLfloat surfKnots [8] = {0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0};
    GLfloat trimCurveKnots [8] = {0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0};
    bezSurface = gluNewNurbsRenderer();
    gluNurbsCallback(bezSurface, GLU_NURBS_ERROR, errorCallback);
    
    gluBeginSurface(bezSurface);
//    gluNurbsProperty(bezSurface, GLU_DISPLAY_MODE, GLU_OUTLINE_POLYGON); // 线框图划分三角形
//    gluNurbsProperty(bezSurface, GLU_NURBS_MODE, GLU_NURBS_TESSELLATOR); // ???? 细分 不好用
    
    // ???? 注意 sStride和tStride的顺序，如果颠倒了，对于后面的裁剪坐标，也是颠倒的
    gluNurbsSurface(bezSurface, 8, surfKnots, 8, surfKnots, 3, 12, &ctrlPts[0][0][0], 4, 4, GL_MAP2_VERTEX_3);
    
    // ???? 必须先提供一个单位正方形的逆时针区域，是确保所有的图案都能正常显示
    // http://csweb.cs.wfu.edu/~torgerse/Kokua/Irix_6.5.21_doc_cd/usr/share/Insight/library/SGI_bookshelves/SGI_Developer/books/OpenGL_PG/sgi_html/ch13.html
    // counterclockwise around the entire unit square of parametric space. This ensures that everything is drawn, provided it isn't removed by a clockwise trimming curve inside of it.
    gluBeginTrim(bezSurface);
    gluPwlCurve(bezSurface, 5, &outerTrimPts[0][0], 2, GLU_MAP1_TRIM_2);
    gluEndTrim(bezSurface);
    
    // 注意 1 裁剪曲线的坐标设置，必须按照顺时针，最后必须封闭
    // ???? 注意 2 根据逆时针的坐标范围，整个裁剪区域被看做(0,0)到(1,1)的一个区域，裁剪曲线的坐标必须在0-1之间，并且不能等于0和1，否则会将所有区域都裁减掉
    gluBeginTrim(bezSurface);
    gluNurbsCurve(bezSurface, 8, trimCurveKnots, 2, &innerTrimPts2[0][0], 4, GLU_MAP1_TRIM_2);
    gluPwlCurve(bezSurface, 3, &innerTrimPts1[0][0], 2, GLU_MAP1_TRIM_2);
    gluEndTrim(bezSurface);
    
    gluEndSurface(bezSurface);
               
    xyCoords();
    
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
    glutCreateWindow("OpenGL Bézier Curve Surface");
    
    init();
    glutDisplayFunc(displayFcn1);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}

