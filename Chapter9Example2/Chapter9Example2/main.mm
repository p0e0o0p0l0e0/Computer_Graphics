//
//  main.mm
//  Chapter9Example2
//
//  Created by 张琳琪 on 2017/6/7.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <iostream>
#include <ctime>

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 0.0);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-225.0, 225.0, -225.0, 225.0);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    glMatrixMode(GL_MODELVIEW);
    
    time_t nowtime = time(NULL);
    for(int i = 0; i < 3999999; i++)
    {
        glColor3f(0.0, 1.0, 0.0);
        glRotatef(90.0, 0.0, 0.0, 1.0);
        glRecti(50, 100, 200, 150);
        glLoadIdentity();
    }
    time_t nowtime1 = time(NULL);
    std::cout << "original: " << nowtime1 - nowtime << std::endl; // 25sec

    
    time_t nowtime2 = time(NULL);
    for(int i = 0; i < 3999999; i++)
    {
        glPushMatrix();
        glColor3f(0.0, 1.0, 0.0);
        glRotatef(90.0, 0.0, 0.0, 1.0);
        glRecti(50, 100, 200, 150);
        glPopMatrix();
    }
    time_t nowtime3 = time(NULL);
    std::cout << "optimize: " << nowtime3 - nowtime2 << std::endl; //25sec
    
    glFlush();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(600.0, 600.0);
    glutCreateWindow("Geometric Transformation Compare with Stack");
    
    init();
    glutDisplayFunc(displayFcn);

    glutMainLoop();
    
    return 0;
}
