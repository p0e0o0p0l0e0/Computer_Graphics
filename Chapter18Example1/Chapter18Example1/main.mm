//
//  main.mm
//  Chapter18Example1
//
//  Created by 张琳琪 on 2017/6/30.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

GLsizei winWidht = 500, winHeight = 500;

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-5, 5, -5, 5);
}

void xyCoords (void)
{
    glBegin(GL_LINES);
    glColor3f(0.0, 0.0, 0.0);
    glVertex2i(-10, 0);
    glVertex2i(10, 0);
    glVertex2i(0, -10);
    glVertex2i(0, 10);
    glEnd();
}

void lineTextureMapping (void)
{
    GLint k;
    GLubyte texLine [16];
    
    for (k = 0; k <= 2; k +=2) {
        texLine [4*k] = 0;
        texLine [4*k+1] = 255;
        texLine [4*k+2] = 0;
        texLine [4*k+3] = 255;
    }
    
    for (k = 1; k <= 3; k +=2) {
        texLine [4*k] = 255;
        texLine [4*k+1] = 0;
        texLine [4*k+2] = 0;
        texLine [4*k+3] = 255;
    }
    
    glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage1D(GL_TEXTURE_1D, 0, GL_RGBA, 4, 0, GL_RGBA, GL_UNSIGNED_BYTE, texLine);
    glEnable(GL_TEXTURE_1D);
    
    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_LINES);
    glTexCoord1f(0.25);
    glVertex2f(-4.5, 4.0);
    glTexCoord1f(1.0);
    glVertex2f(-4.5, -4.0);
    glEnd();
    
    glDisable(GL_TEXTURE_1D);
}

void surfaceTextureMapping (void)
{
    GLint k, j;
    GLubyte texArray [32][32][4];
    
    for (k = 0; k < 32; k++) {
        for (j = 0; j < 32; j++) {
            texArray [k][j][0] = 255 - k*j/4;
            texArray [k][j][1] = 128 + k*j/8;
            texArray [k][j][2] = 0;
            texArray [k][j][3] = 255;
        }
    }
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 32, 32, 0, GL_RGBA, GL_UNSIGNED_BYTE, texArray);
    glEnable(GL_TEXTURE_2D);
    
    glColor3f(0.5, 0.5, 0.5); // 与纹理值相乘，因此会发暗
    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0);
    glVertex2f(0.0, 0.0);
    glTexCoord2f(3.0, 0.0);
    glVertex2f(3.0, 0.0);
    glTexCoord2f(3.0, 3.0);
    glVertex2f(3.0, 3.0);
    glTexCoord2f(0.0, 3.0);
    glVertex2f(0.0, 3.0);
    glEnd();
    
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
    glColor3f(0.5, 0.5, 0.5); // 替换为纹理颜色，则不会像前一个图案那样发暗
    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0);
    glVertex2f(-4.0, -4.0);
    glTexCoord2f(1.0, 0.0);
    glVertex2f(-1.0, -4.0);
    glTexCoord2f(1.0, 1.0);
    glVertex2f(-1.0, -1.0);
    glTexCoord2f(0.0, 1.0);
    glVertex2f(-4.0, -1.0);
    glEnd();
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
    
    // 不允许纹理坐标超过1，因此小于0的设为0，大于1的设为1
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0);
    glVertex2f(-4.0, 0.0);
    glTexCoord2f(2, 0.0);
    glVertex2f(-1.0, 0.0);
    glTexCoord2f(2, 2);
    glVertex2f(-1.0, 3.0);
    glTexCoord2f(0.0, 2);
    glVertex2f(-4.0, 3.0);
    glEnd();
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glDisable(GL_TEXTURE_2D);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
//    lineTextureMapping();
    surfaceTextureMapping();
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
    glutCreateWindow("texture mapping");
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}

