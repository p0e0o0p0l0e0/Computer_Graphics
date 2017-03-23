//
//  main.c
//  Chapter4Example1
//
//  Created by 张琳琪 on 2017/3/10.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>

GLsizei winWidth = 600, winHeight = 500;
GLint xRaster = 25, yRaster = 150;

GLubyte label [36] = {'J', 'a', 'n',  'F', 'e', 'b',  'M', 'a', 'r',
    'A', 'p', 'r',  'M', 'a', 'y',  'J', 'u', 'n',
    'J', 'u', 'l',  'A', 'u', 'g',  'S', 'e', 'p',
    'O', 'c', 't',  'N', 'o', 'v',  'D', 'e', 'c'};
GLint dataValue [12] = {420, 342, 324, 310, 262, 185,
    190, 196, 217, 240, 312, 438};

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(0, winWidth, 0, winHeight);
}


void lineGraph (void)
{
    GLint month, k;
    xRaster = 25; // reset the xRaster to adapt the screen reshaping.
    
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(0.0, 0.0, 1.0); // blue lines
    
    glBegin(GL_LINE_STRIP);
    for(k = 0; k < 12; k++)
    {
        glVertex2i(xRaster + k * 50, dataValue[k]);
    }
    glEnd();
    
    glColor3f(1.0, 0.0, 0.0); // red markers
    for(k = 0; k < 12; k++)
    {
        glRasterPos2i(xRaster - 4 + k * 50, dataValue[k] - 4);
        glutBitmapCharacter(GLUT_BITMAP_9_BY_15, '*');
    }
    
    glColor3f(0.0, 0.0, 0.0); // black characters
    xRaster = 20;
    for(month = 0; month < 12; month ++)
    {
        glRasterPos2i(xRaster, yRaster);
        for(k = 3 * month; k < 3 * month + 3; k++)
        {
            glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12, label[k]);
        }
        xRaster += 50;
    }
    
    glFlush();
}

void barChart (void)
{
    GLint month, k;
    GLint x = 20, y = 165;
    
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(1.0, 0.0, 0.0);
    for(k = 0; k < 12; k++)
    {
        // using x and y instead of xRaster and yRaster, because here we use x and y as a rect's vecters position but not a raster position.
        glRecti(x + k * 50, y + 15, x + k * 50 + 20, dataValue[k]);
    }
    
    glColor3f(0.0, 0.0, 0.0); // black characters
    xRaster = 20;
    for(month = 0; month < 12; month ++)
    {
        glRasterPos2i(xRaster, yRaster);
        for(k = 3 * month; k < 3 * month + 3; k++)
        {
            glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12, label[k]);
        }
        xRaster += 50;
    }
    
    glFlush();
}

void winReshapeFunc (GLint newWidth, GLint newHeight)
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0, (GLdouble)winWidth, 0, (GLdouble)winHeight);
    
    glClear(GL_COLOR_BUFFER_BIT);
}

int main(int argc, char ** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(winWidth, winHeight);
    glutCreateWindow("Line Chart Data Plot");
    
    init();
//    glutDisplayFunc(lineGraph);
    glutDisplayFunc(barChart);
    glutReshapeFunc(winReshapeFunc);
    
    glutMainLoop();
    
    return 0;
}
