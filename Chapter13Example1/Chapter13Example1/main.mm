//
//  main.mm
//  Chapter13Example1
//
//  Created by 张琳琪 on 2017/6/13.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
GLsizei winWidth = 500, winHeight = 500;

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
}

void displayWirePolyhedra (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(0.0, 0.0, 1.0);
    
    gluLookAt(5.0, 5.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    glScalef(1.5, 2.0, 1.0);
    glutWireCube(1.0);
    
    glScalef(0.8, 0.5, 0.8);
    glTranslatef(-6.0, -5.0, 0.0);
    glutWireDodecahedron();
    
    glTranslatef(8.6, 8.6, 2.0);
    glutWireTetrahedron();
    
    glTranslatef(-3.0, -1.0, 0.0);
    glutWireOctahedron();
    
    glScalef(0.8, 0.8, 1.0);
    glTranslatef(4.3, -2.0, 0.5);
    glutWireIcosahedron();
    
    glFlush();
}

void winReshapeFcn (GLint newWidth, GLint newHeight)
{
    glViewport(0, 0, newWidth, newHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity(); // 其实这上下3行可以放在init中，不必每次在窗口刷新时调用。
    glFrustum(-1.0, 1.0, -1.0, 1.0, 2.0, 20.0);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glClear(GL_COLOR_BUFFER_BIT);
}


int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(winWidth, winHeight);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("Wire-Frame Polyhedra");
    
    init();
    glutDisplayFunc(displayWirePolyhedra);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}
