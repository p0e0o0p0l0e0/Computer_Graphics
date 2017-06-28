//
//  main.mm
//  Chapter17Example1
//
//  Created by 张琳琪 on 2017/6/28.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

GLsizei winWidth = 500, winHeight = 500;

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    glMatrixMode(GL_PROJECTION);
    glFrustum(-1, 1, -1, 1, 2, 30);
    
    glMatrixMode(GL_MODELVIEW);
    gluLookAt(10, 10, 10, 0, 0, 0, 0, 1, 0);
    
}

void axis (void)
{
    glColor3f(1.0, 0.0, 0.0);
    glPointSize(3.0);
    glBegin(GL_POINTS);
    glVertex3f(0.0, 0.0, 0.0);
    glEnd();
    
    glLineWidth(2.0);
    glBegin(GL_LINES);
    glColor3f(1.0, 0.0, 0.0); // red z
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 10.0);
    glColor3f(0.0, 1.0, 0.0); // green x
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(10.0, 0.0, 0.0);
    glColor3f(0.0, 0.0, 1.0); // blue y
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 10.0, 0.0);
    glEnd();
    
    glLineWidth(1.0);
    glPointSize(1.0);
}

void lightTest (void)
{
    glEnable(GL_CULL_FACE);
    glEnable(GL_LIGHTING);
    
    // 点光源位置
    GLfloat light0PosType [] = {3.0, 5.0, 5.0, 1.0};
    glLightfv(GL_LIGHT0, GL_POSITION, light0PosType);
    
    // 点光源颜色：环境光、漫反射、镜面反射
    GLfloat color1 [] = {0.0, 0.0, 0.0, 1.0};
    GLfloat color2 [] = {1.0, 1.0, 1.0, 1.0};
    glLightfv(GL_LIGHT0, GL_AMBIENT, color1);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, color2);
    glLightfv(GL_LIGHT0, GL_SPECULAR, color2);
    
    // 点光源辐射衰减系数
    glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.15); // 之前设置的衰减系数太高，导致点光源没有效果
    glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0.075);
    glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.04);
    
    // 点光源角度衰减系数
    GLfloat dirVector [] = {0.0, 0.0, 0.0}; // 除了0向量以外的任何向量都会使点光源无效?
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, dirVector);
    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 30);
    glLightf(GL_LIGHT0, GL_SPOT_EXPONENT, 2.5); // 系数越大，衰减的越快，看起来光圆锥体的范围变小
    
    glEnable(GL_LIGHT0);
    
    // 设置全局环境光颜色，是否固定视点，是否区分镜面反射与非镜面反射，是否前后面都绘制
    GLfloat globalAmbient [] = {0.0, 0.0, 0.3, 1.0};
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, globalAmbient);
    glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
    glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR);
    glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
    
    // 设置自身散射颜色
    GLfloat surfEmissionColor [] = {0.5, 0.5, 0.5, 1.0}; // 灰色的球
    glMaterialfv(GL_FRONT, GL_EMISSION, surfEmissionColor);
    
    // 设置环境光、漫反射、镜面反射系数
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE_MINUS_SRC_ALPHA, GL_SRC_ALPHA); // diffuseCoeff 影响透明度，0为不透明，1为全透明
    GLfloat diffuseCoeff [] = {0.0, 0.4, 0.7, 0.05}; // 漫反射系数 ka和kd
    // 漫反射较多的蓝色光（包括点光源和环境光），x=0.0环境光为红色也不反射
    GLfloat specularCoeff [] = {1.0, 1.0, 1.0, 0.0}; // 镜面反射系数 影响高光的亮度ks
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, diffuseCoeff);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specularCoeff);
    glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 2.5); // 镜面反射指数参数 ns
    
    // 设置雾气效果?
    glEnable(GL_FOG);
    GLfloat atmoColor [4] = {0.5, 0.8, 1.0, 1.0};
    glFogfv(GL_FOG_COLOR, atmoColor);
    glFogi(GL_FOG_MODE, GL_LINEAR);
//    glFogi(GL_FOG_DENSITY, 100);
    
    glutSolidSphere(2.0, 100, 100);
//    glutSolidTeapot(2.0);
    
    glDisable(GL_BLEND);
    glDisable(GL_FOG);
    glDisable(GL_CULL_FACE);
    glDisable(GL_LIGHTING);
    glDisable(GL_LIGHT0);
    
    // 点光源示意
    glPushMatrix();
    glPointSize(5.0);
    glColor3f(0.0, 0.0, 0.0);
    glBegin(GL_POINTS);
    glVertex3i(3, 5, 5);
    glEnd();
    glPopMatrix();
}

void transparentTest (void)
{
    glEnable(GL_DEPTH_TEST);
    
    glPushMatrix();
    glTranslatef(0, 0, -1);
    glColor3f(1.0, 0.0, 0.0);
    glutSolidTeapot(4.0);
    glPopMatrix();
    
    glEnable(GL_BLEND);
    glDepthMask(GL_FALSE);
    
    glBlendFunc(GL_ONE_MINUS_SRC_ALPHA, GL_SRC_ALPHA);
    
    glColor4f(0.0, 1.0, 0.0, 0.8);
    glutSolidTeapot(2.0);
    
    glPushMatrix();
    glTranslatef(2.0, 0.0, 0.0);
    glColor4f(0.0, 0.0, 1.0, 0.8);
    glutSolidTeapot(2.0);
    glPopMatrix();
    
    glDepthMask(GL_TRUE);
    glDisable(GL_BLEND);
}

void surfaceTest (void)
{
//    glShadeModel(GL_FLAT);
//    glShadeModel(GL_SMOOTH);
    
    glEnable(GL_DITHER); // 版色调操作，对于全彩色图形能力的系统没有效果
    // 相当于用GL_FLAT，只需要一个表面法向量
    GLfloat normalVector [] = {-1.0, -1.0, 1.0};
    glNormal3fv(normalVector);
    glBegin(GL_TRIANGLES);
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glColor3f(0.0, 1.0, 0.0);
    glVertex3f(4.0, 1.0, -2.0);
    glColor3f(0.0, 0.0, 1.0);
    glVertex3f(3.0, 0.0, 0.0);
    glEnd();
    glDisable(GL_DITHER);
    
    // 相当于用GL_SMOOTH，每个顶点设置一个表面法向量
    glBegin(GL_TRIANGLES);
    glColor3f(1.0, 0.0, 0.0);
    glNormal3f(1.0, 0.0, 0.0);
    glVertex3f(5.0, 0.0, 0.0);
    glColor3f(0.0, 1.0, 0.0);
    glNormal3f(0.0, 1.0, 0.0);
    glVertex3f(9.0, 1.0, -2.0);
    glColor3f(0.0, 0.0, 1.0);
    glNormal3f(0.0, 0.0, 1.0);
    glVertex3f(8.0, 0.0, 0.0);
    glEnd();
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    axis();
    
//    surfaceTest();
//    transparentTest();
    lightTest();
    
    glFlush();
}

void reshapeFcn (GLint newWidth, GLint newHeight)
{
    glViewport(0, 0, newWidth, newHeight);
    
    glutPostRedisplay();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(winWidth, winHeight);
    glutCreateWindow("Lighting");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(reshapeFcn);
    glutMainLoop();
    
    return 0;
}
