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
    glEnable(GL_DEPTH_TEST); // 开启深度测试，才会让每个球深度显示正确
    
    // init lighting
    
    // 点光源位置
    GLfloat light0PosType [] = {0.5, 0.5, 3.0, 1.0};
    glLightfv(GL_LIGHT0, GL_POSITION, light0PosType);
    
    // 点光源颜色：环境光、漫反射、镜面反射颜色
    GLfloat color1 [] = {0.0, 0.0, 0.0, 1.0};
    GLfloat color2 [] = {1.0, 0.0, 1.0, 1.0};
    glLightfv(GL_LIGHT0, GL_AMBIENT, color1);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, color2);
    glLightfv(GL_LIGHT0, GL_SPECULAR, color2);
    
    // 点光源辐射衰减系数
    glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 1); // 之前设置的衰减系数太高，导致点光源没有效果
    glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0.005);
    glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.001);
    
    // 点光源角度衰减系数
    GLfloat dirVector [] = {0.0, 0.0, 0.0};
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, dirVector);
    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 30);
    glLightf(GL_LIGHT0, GL_SPOT_EXPONENT, 2.7); // 系数越大，衰减的越快，看起来光圆锥体的范围变小
    
//    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    {
        // 设置全局环境光颜色，是否固定视点，是否区分镜面反射与非镜面反射，是否前后面都绘制
        GLfloat globalAmbient [] = {0.8, 0.8, 0.0, 1.0}; // 偏黄的环境光
        glLightModelfv(GL_LIGHT_MODEL_AMBIENT, globalAmbient);
        glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
        glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR);
//        glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
        
        GLfloat ambLight[3] = {0.17f, 0.11f, 0.11f};    // 环境光漫反射系数 ka
        glMaterialfv(GL_FRONT, GL_AMBIENT, ambLight);
        GLfloat difLight[3] = {0.61f, 0.24f, 0.24f};    // 光源0漫反射系数 kd
        glMaterialfv(GL_FRONT, GL_DIFFUSE, difLight);
        GLfloat speLight[3] = {0.73f, 0.63f, 0.63f};    // 镜面反射系数 影响高光的亮度ks
        glMaterialfv(GL_FRONT, GL_SPECULAR, speLight);
        glMaterialf(GL_FRONT, GL_SHININESS, 100.0f);    // 镜面反射指数参数 ns 光滑表面ns较大，粗糙表面ns可小到1
        
        // 设置自身发光颜色，看起来很丑。。
//        GLfloat surfEmissionColor [] = {0.0, 0.2, 0.0}; // 自身发浅绿光
//        glMaterialfv(GL_FRONT, GL_EMISSION, surfEmissionColor);
    }

    glEnable(GL_FOG);//启用雾功能
    GLfloat fogColor[4] = {0.5f, 0.5f, 0.5f, 1.0f};
    
    glFogi(GL_FOG_MODE, GL_LINEAR);
    glFogfv(GL_FOG_COLOR, fogColor);
    glFogf(GL_FOG_DENSITY, 0.35f);
    glHint(GL_FOG_HINT, GL_DONT_CARE);
    glFogf(GL_FOG_START, 1.0f);
    glFogf(GL_FOG_END, 10.0f);
    glClearColor(fogColor[0], fogColor[1], fogColor[2], fogColor[3]);//用雾气背景色
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

void drawTeapot (GLfloat x, GLfloat y, GLfloat z)
{
    glPushMatrix();
    glTranslatef(x, y, z);
    glutSolidTeapot(0.8);
    glPopMatrix();
}

void lightTest (void)
{
    drawTeapot(0, 0, 0);
    drawTeapot(0, 0, -2);
    drawTeapot(0, 0, -4);
    drawTeapot(0, 0, -6);
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
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_LIGHTING);
    lightTest();
//    transparentTest();
//    surfaceTest();
    
    glDisable(GL_LIGHTING);
    axis();
    
    glFlush();
}

void reshapeFcn (GLint w, GLint h)
{
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustum(-1, 1, -1, 1, 2, 30);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(2, 2, 3, 0, 0, 0, 0, 1, 0);
}

void onMenu (int value)
{
    GLint fogMode = 0;
    switch (value)
    {
        case 1:
            fogMode = GL_LINEAR;
            break;
        case 2:
            fogMode = GL_EXP;
            break;
        case 3:
            fogMode = GL_EXP2;
            break;
    }
    glFogi(GL_FOG_MODE, fogMode);
    if (value == 0)
    {
        glDisable(GL_FOG);
    }  
    else  
    {  
        glEnable(GL_FOG);  
    }  
    glutPostRedisplay();
}

void CreateMenu(void)
{
    glutAddMenuEntry("线性", 1);
    glutAddMenuEntry("指数", 2);
    glutAddMenuEntry("指数2", 3);
    glutAddMenuEntry("无雾", 0);
    glutAttachMenu(GLUT_RIGHT_BUTTON);
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(winWidth, winHeight);
    glutCreateWindow("Lighting");
    glutCreateMenu(onMenu);
    CreateMenu();
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(reshapeFcn);
    glutMainLoop();
    
    return 0;
}
