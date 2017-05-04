//
//  main.m
//  Chapter6Example1
//
//  Created by 张琳琪 on 2017/4/25.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>

GLsizei winWidth = 600, winHeight = 300; // Initial display window size.

void init (void)
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    
    glMatrixMode(GL_PROJECTION);
    gluOrtho2D(-200.0, 200, -100.0, 100); // 窗口坐标范围
}

typedef float Color [3];

void getPixel(GLint x, GLint y, Color c)
{
    glReadPixels(x, y, 1, 1, GL_RGB, GL_FLOAT, c);
    std::cout<< "color : " << c << std::endl;
}

void setPixel (int x, int y)
{
    glBegin(GL_POINTS);
    glVertex2i(x, y);
    glEnd();
}

void setPixel1 (int x, int y)
{
//    GLfloat iPixel[4];
//    glReadPixels(x, y, 1, 1, GL_RGB, GL_FLOAT, &iPixel);
//    glReadPixels(x, y, 1, 1, GL_RED, GL_FLOAT, &iPixel[0]);
//    glReadPixels(x, y, 1, 1, GL_GREEN, GL_UNSIGNED_BYTE, &iPixel[1]);
//    glReadPixels(x, y, 1, 1, GL_BLUE, GL_UNSIGNED_BYTE, &iPixel[2]);
//    if(float(iPixel[0]) != 0.0)
//    {
//        std::cout << "red color is not zero ! " << std::endl;
//        std::cout << "red color : "     << float(iPixel[0]) << std::endl;
//    }
//    if(float(iPixel[1]) != 0.0)
//    {
//        std::cout << "green color is not zero ! " << std::endl;
//        std::cout << "green color : "   << float(iPixel[1]) << std::endl;
//    }
//    if(float(iPixel[2]) != 0.0)
//    {
//        std::cout << "blue color is not zero ! " << std::endl;
//        std::cout << "blue color : "    << float(iPixel[2]) << std::endl;
//    }
    glBegin(GL_POINTS);
    glVertex2i(x, y);
    glEnd();
}


inline int round (const float a) { return int (a + 0.5);}

// line DDA
void lineDDA (int x0, int y0, int xEnd, int yEnd)
{
    int dx = xEnd - x0, dy = yEnd - y0, steps, k;
    float xIncrement, yIncrement, x = x0, y = y0;
    
    if(fabs(dx) >= fabs(dy))
    {
        steps = dx;
    }
    else
    {
        steps = dy;
    }
    
    if(steps <= 0)
    {
        steps = 1;
    }
    std::cout << "steps : " << steps << std::endl;
    
    xIncrement = float(dx) / float(steps);
    yIncrement = float(dy) / float(steps);
    
    setPixel(round(x), round(y));
    
    // amend DDA algorithm, delta X = xEnd - x0;
//    for(k = 0; k < steps; k++)
    for(k = 0; k < steps - 1; k++)
    {
        x += xIncrement;
        y += yIncrement;
        setPixel(round(x), round(y));
    }
}

//line Bresenham: 斜率slope <= 1

void lineBres1 (int x0, int y0, int xEnd, int yEnd, bool slopepositive = true)
{
    int dx = fabs(xEnd - x0), dy = fabs(yEnd - y0);
    int p = 2 * dy - dx;
    int twoDy = 2 * dy, twoDyMinusDx = 2 * (dy - dx);
    int x, y;
    
    if(x0 > xEnd)
    {
        x = xEnd;
        y = yEnd;
        xEnd = x0;
    }
    else
    {
        x = x0;
        y = y0;
    }
    
    setPixel(x, y);
    
    // amend Bresenham algorithm
//    while (x < xEnd)
    while (x < xEnd - 1) {
        x++;
        if (p < 0)
        {
            p += twoDy;
        }
        else
        {
            if (slopepositive)
                y++;
            else
                y--;
            p += twoDyMinusDx;
        }
        setPixel(x, y);
    }
    std::cout << x << "," << y << std::endl;
}

//line Bresenham: 斜率slope > 1

void lineBres2 (int x0, int y0, int xEnd, int yEnd, bool slopepositive = true)
{
    int dx = fabs(xEnd - x0), dy = fabs(yEnd - y0);
    int p = 2 * dx - dy;
    int twoDx = 2 * dx, twoDxMinusDy = 2 * (dx - dy);
    int x, y;
    
    if(y0 > yEnd)
    {
        x = xEnd;
        y = yEnd;
        yEnd = y0;
    }
    else
    {
        x = x0;
        y = y0;
    }
    
    setPixel(x, y);
    
    // amend Bresenham algorithm
//    while (y < yEnd) {    
    while (y < yEnd - 1) {
        y++;
        if (p < 0)
        {
            p += twoDx;
        }
        else
        {
            if (slopepositive)
                x++;
            else
                x--;
            p += twoDxMinusDy;
        }
        setPixel(x, y);
    }
    std::cout << x << "," << y << std::endl;
}

//line Bresenham
void lineBres (int x0, int y0, int xEnd, int yEnd)
{
    bool slopePositive = true;
    float slope = 0.0;
    if(x0 == xEnd)
    {
        lineBres2(x0, y0, xEnd, yEnd, slopePositive);
    }
    else if(y0 == yEnd)
    {
        lineBres1(x0, y0, xEnd, yEnd, slopePositive);
    }
    else
    {
        slope = float(y0-yEnd)/float(x0-xEnd);
        slopePositive = slope > 0;
    }
    if(fabs(slope) <= 1)
    {
        lineBres1(x0, y0, xEnd, yEnd, slopePositive);
    }
    else
    {
        lineBres2(x0, y0, xEnd, yEnd, slopePositive);
    }
}

// 中点圆算法

class screenPt
{
private:
    GLint x, y;
    
public:
    screenPt()
    {
        x = y = 0;
    }
    
    void setCoords (GLint xCoordValue, GLint yCoordValue)
    {
        x = xCoordValue;
        y = yCoordValue;
    }
    
    GLint getx() const {
        return x;
    }
    
    GLint gety() const {
        return y;
    }
    
    void incrementx() {
        x++;
    }
    
    void decrementx() {
        x--;
    }
    
    void incrementy() {
        y++;
    }
    
    void decrementy() {
        y--;
    }
};

void circleMidpoint (GLint xc, GLint yc, GLint radius)
{
    screenPt circPt;
    GLint p = 1 - radius;
    circPt.setCoords(0, radius);
    
    void circlePlotPoints (GLint, GLint, screenPt);
    circlePlotPoints(xc, yc, circPt);
    
    while (circPt.getx() < circPt.gety()) {
        circPt.incrementx();
        if(p < 0)
        {
            p += 2 * circPt.getx() + 1;
        }
        else
        {
            circPt.decrementy();
            p += 2 * (circPt.getx() - circPt.gety()) + 1;
        }
        circlePlotPoints(xc, yc, circPt);
    }
    
    
    // circle midpoint amend algorithm.
    glColor3f(1.0, 1.0, 0.0);
    p = 1 - radius;
    circPt.setCoords(0, -radius);
    void circlePlotPoints1 (GLint, GLint, screenPt);
    circlePlotPoints1(xc, yc, circPt);
    while (circPt.getx() > circPt.gety()) {
        circPt.decrementx();
        if(p > 0)
        {
            circPt.incrementy();
            p += 2 * (circPt.gety() - circPt.getx()) + 5;
        }
        else
        {
            p += 3 - 2 * circPt.getx();
        }
        circlePlotPoints1(xc, yc, circPt);
    }
}

void circlePlotPoints(GLint xc, GLint yc, screenPt circPt)
{
    setPixel(xc + circPt.getx(), yc + circPt.gety());
    setPixel(xc - circPt.getx(), yc + circPt.gety());
    setPixel(xc + circPt.getx(), yc - circPt.gety());
    setPixel(xc - circPt.getx(), yc - circPt.gety());
    setPixel(yc + circPt.gety(), xc + circPt.getx());
    setPixel(yc - circPt.gety(), xc + circPt.getx());
    setPixel(yc + circPt.gety(), xc - circPt.getx());
    setPixel(yc - circPt.gety(), xc - circPt.getx());
}


void circlePlotPoints1(GLint xc, GLint yc, screenPt circPt)
{
    setPixel1(xc + circPt.getx(), yc + circPt.gety());
    setPixel1(xc - circPt.getx() - 1, yc + circPt.gety());
    setPixel1(xc + circPt.getx(), yc - circPt.gety() - 1);
    setPixel1(xc - circPt.getx() - 1, yc - circPt.gety() - 1);
    setPixel1(yc + circPt.gety(), xc + circPt.getx());
    setPixel1(yc - circPt.gety() - 1, xc + circPt.getx());
    setPixel1(yc + circPt.gety(), xc - circPt.getx() - 1);
    setPixel1(yc - circPt.gety() - 1, xc - circPt.getx() - 1);
}

// 中心椭圆算法

void ellipseMidpoint (int xCenter, int yCenter, int Rx, int Ry)
{
    int Rx2 = Rx * Rx, Ry2 = Ry * Ry;
    int twoRx2 = 2 * Rx2, twoRy2 = 2 * Ry2;
    int p, x = 0, y = Ry, px = 0, py = twoRx2 * y;
    
    void ellipsePlotPoints (int, int, int, int);
    ellipsePlotPoints(xCenter, yCenter, x, y);
    
    //Region 1
    p = round(Ry2 - (Rx2 * Ry) + (0.25 * Rx2));
    while (px < py) {
        x++;
        px += twoRy2;
        if(p < 0){
            p += Ry2 + px;
        }
        else{
            y--;
            py -= twoRx2;
            p += Ry2 + px - py;
        }
        ellipsePlotPoints(xCenter, yCenter, x, y);
    }
    
    //Region 2
    p = round(Ry2 * (x + 0.5) * (x + 0.5) + Rx2 * (y - 1) * (y - 1) - Rx2 * Ry2);
    while (y > 0) {
        y--;
        py -= twoRx2;
        if(p > 0){
            p += Rx2 - py;
        }
        else{
            x++;
            px += twoRy2;
            p += Rx2 - py + px;
        }
        ellipsePlotPoints(xCenter, yCenter, x, y);
    }
}

void ellipsePlotPoints (int xCenter, int yCenter, int x, int y)
{
    setPixel(xCenter + x, yCenter + y);
    setPixel(xCenter - x, yCenter + y);
    setPixel(xCenter + x, yCenter - y);
    setPixel(xCenter - x, yCenter - y);
}

void displayFcn (void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPointSize(3.0);
    glColor3f(1.0, 1.0, 0.0);
    lineDDA(1, 1, 80, 30); // 0 < slope < 1
    lineDDA(1, 1, 1, 30); // slope 无穷大
    lineDDA(1, 80, 1, 80); // slope = 0
    
    Color c;
    getPixel(1, 1, c);
    
    glPointSize(5.0);
    glColor3f(0.0, 0.0, 1.0);
    lineBres(90, 15, 20, 40); // -1 < slope < 0
    lineBres(15, 20, 40, 90); // slope > 1
    lineBres(15, 50, 40, 50); // slope = 0
    lineBres(15, 30, 15, 80); // slope 无穷大
    
    glPointSize(2.0);
    glColor3f(0.0, 1.0, 0.0);
    circleMidpoint(30, 30, 15);
    
    glColor3f(1.0, 0.0, 0.0);
    ellipseMidpoint(-50, -50, 30, 20);
    
    glFlush();
}

int main(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100); // 窗口位置，屏幕左上角为(0,0)，窗口左上角距离屏幕左上角100,100。
    glutInitWindowSize(winWidth, winHeight); // 窗口大小
    glutCreateWindow("Draw Lines");
    
    init();
    glutDisplayFunc(displayFcn);
    
    glutMainLoop();
    
    return 0;
}
