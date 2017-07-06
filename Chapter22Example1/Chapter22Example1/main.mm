//
//  main.m
//  Chapter22Example1
//
//  Created by 张琳琪 on 2017/7/6.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <stdio.h>
#include <stdlib.h>

GLchar * readTextFile (const char *name)
{
    FILE *fp;
    GLchar *content = NULL;
    long count = 0;
    
    if(name == NULL)
        return  NULL;
    
    fp = fopen(name, "rt");
    if(fp == NULL)
        return NULL;
    
    fseek(fp, 0, SEEK_END);
    count = ftell(fp);
    rewind(fp);
    
    if(count > 0)
    {
        content = (GLchar *)malloc(sizeof(GLchar) * (count + 1));
        if(content != NULL)
        {
            count = fread(content, sizeof(char), count, fp);
            content[count] = '\0';
        }
    }
    
    fclose(fp);
    
    return  content;
}

void init (void)
{
    glClearColor(1.0, 1.0, 1.0, 1.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-10, 10, -10, 10);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(1.0, 0.0, 0.0);
    glBegin(GL_TRIANGLES);
    glVertex2f(0.0, 0.0);
    glVertex2f(10.0, 10.0);
    glVertex2f(0.0, 10.0);
    glEnd();
    
    glFlush();
}

void winReshapeFcn (int newWidth, int newHeight)
{
    glViewport(0, 0, newWidth, newHeight);
    
    glutPostRedisplay();
}

GLuint vertShader, fragShader;

int main(int argc, char * argv[]) {
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(500, 500);
    glutCreateWindow("load shader file");
    
    vertShader = glCreateShader(GL_VERTEX_SHADER);
    fragShader = glCreateShader(GL_FRAGMENT_SHADER);
    
    GLchar *vertSource, *fragSource;
    
    vertSource = readTextFile("/Users/zhanglinqi/Documents/github/Computer_Graphics/Chapter22Example1/Chapter22Example1/simpleShader.vert");
    if(vertSource == NULL)
    {
        fputs("Failed to read vertex shader \n", stderr);
        exit(EXIT_FAILURE);
    }
    
    fragSource = readTextFile("simpleShader.frag");
    if(fragSource == NULL)
    {
        fputs("Failed to read fragment shader \n", stderr);
        exit(EXIT_FAILURE);
    }
    
    glShaderSource(vertShader, 1, &vertSource, NULL);
    glShaderSource(fragShader, 1, &fragSource, NULL);
    
    free(vertSource);
    free(fragSource);
    
    glCompileShader(vertShader);
    glCompileShader(fragShader);
    
    GLint status;
    
    glGetShaderiv(vertShader, GL_COMPILE_STATUS, &status);
    if(status != GL_TRUE)
    {
        fputs("Error in vertex shader compilation\n", stderr);
        exit(EXIT_FAILURE);
    }
    
    glGetShaderiv(fragShader, GL_COMPILE_STATUS, &status);
    if(status != GL_TRUE)
    {
        fputs("Error in fragment shader compilation\n", stderr);
        exit(EXIT_FAILURE);
    }
    
    
    
    init();
    glutDisplayFunc(displayFcn);
    glutReshapeFunc(winReshapeFcn);
    glutMainLoop();
    
    return 0;
}
