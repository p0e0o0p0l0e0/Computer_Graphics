//
//  polygonClipS.mm
//  Chapter8Example7
//
//  Created by 张琳琪 on 2017/6/2.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#include <GLUT/GLUT.h>
#include "polygonClipS.h"
#include <iostream>

typedef enum {
    Left = 0,
    Right,
    Bottom,
    Top,
} Boundary;

const GLint nClip = 4;

GLint inside (wcPt2D p, Boundary b, wcPt2D wMin, wcPt2D wMax)
{
    
    switch (b) {
        case Left:
            if(p.x < wMin.x)
                return false;
            break;
        case Right:
            if(p.x > wMax.x)
                return false;
            break;
        case Bottom:
            if(p.y < wMin.y)
                return false;
            break;
        case Top:
            if(p.y > wMax.y)
                return false;
            break;
        default:
            break;
    }
    return true;
}

GLint cross (wcPt2D p1, wcPt2D p2, Boundary winEdge, wcPt2D wMin, wcPt2D wMax)
{
    if(inside(p1, winEdge, wMin, wMax) == inside(p2, winEdge, wMin, wMax))
    {
        return false;
    }
    else
    {
        return true;
    }
}

// 求线段与裁剪边界的交点
wcPt2D intersect (wcPt2D p1, wcPt2D p2, Boundary winEdge, wcPt2D wMin, wcPt2D wMax)
{
    wcPt2D iPt;
    GLfloat m = 0.0;
    
    if(p1.x != p2.x)
    {
        m = (p1.y - p2.y)/(p1.x - p2.x);
    }
    
    switch (winEdge) {
        case Left:
            iPt.x = wMin.x;
            iPt.y = p2.y + (wMin.x - p2.x) * m;
            break;
        case Right:
            iPt.x = wMax.x;
            iPt.y = p2.y + (wMax.x - p2.x) * m;
            break;
        case Bottom:
            iPt.y = wMin.y;
            if(p1.x != p2.x)
            {
                iPt.x = p2.x + (wMin.y - p2.y) / m;
            }
            else
            {
                iPt.x = p2.x;
            }
            break;
        case Top:
            iPt.y = wMax.y;
            if(p1.x != p2.x)
            {
                iPt.x = p2.x + (wMax.y - p2.y) / m;
            }
            else
            {
                iPt.x = p2.x;
            }
            break;
        default:
            break;
    }
    return iPt;
}

void clipPoint (wcPt2D p, Boundary winEdge, wcPt2D wMin, wcPt2D wMax, wcPt2D * pOut, int * cnt, wcPt2D * first[], wcPt2D * s)
{
    std::cout << "--clipPoint-- : winEdge : " << winEdge << std::endl;
    wcPt2D iPt;
    GLint b = winEdge;
    
    if(!first[winEdge])
    {
        std::cout << "--clipPoint-- : first[" << winEdge << "] = " << p.x << "," << p.y << std::endl;
        first[winEdge] = &p;
    }
    else
    {
        if (cross(p, s[winEdge], winEdge, wMin, wMax)) {
            
            std::cout << "--clipPoint-- : cross : p: " << p.x << ", " << p.y << ", s[" << winEdge << "] = " << s[winEdge].x << "," << s[winEdge].y << std::endl;
            iPt = intersect(p, s[winEdge], winEdge, wMin, wMax);
            if(winEdge < Top)
            {
                clipPoint(iPt, (Boundary)(b + 1), wMin, wMax, pOut, cnt, first, s);
            }
            else
            {
                std::cout << "--------clipPoint-- : *cnt = " << *cnt<< std::endl;
                std::cout << "--------clipPoint-- : p = " << iPt.x << "," << iPt.y<< std::endl;
                pOut[*cnt] = iPt;
                (*cnt)++;
            }
        }
    }
    s[winEdge] = p;
    
    if(inside(p, winEdge, wMin, wMax))
    {
        std::cout << "--clipPoint-- : inside p: " << p.x << "," << p.y << std::endl;
        if(winEdge < Top)
        {
            clipPoint(p, (Boundary)(b + 1), wMin, wMax, pOut, cnt, first, s);
        }
        else
        {
            std::cout << "--------clipPoint-- : *cnt = " << *cnt<< std::endl;
            std::cout << "--------clipPoint-- : p = " << p.x << "," << p.y<< std::endl;
            pOut[*cnt] = p;
            (*cnt)++;
        }
    }
}

void closeClip (wcPt2D wMin, wcPt2D wMax, wcPt2D * pOut, GLint * cnt, wcPt2D * first[], wcPt2D * s)
{
    wcPt2D pt;
    Boundary winEdge;
    GLint b = Left;
    
    for (winEdge = Left; winEdge <= Top; ) {
        if (cross(s[winEdge], *first[winEdge], winEdge, wMin, wMax)) {
            pt = intersect(s[winEdge], *first[winEdge], winEdge, wMin, wMax);
            if(winEdge < Top)
            {
                clipPoint(pt, winEdge, wMin, wMax, pOut, cnt, first, s);
            }
            else
            {
                std::cout << "--------closeClip-- : *cnt = " << *cnt<< std::endl;
                std::cout << "--------closeClip-- : pt = " << pt.x << "," << pt.y<< std::endl;
                pOut[*cnt] = pt;
                (*cnt)++;
            }
        }
        winEdge = Boundary(++b);
    }
}

GLint polygonClpSuhHodg (wcPt2D wMin, wcPt2D wMax, GLint n, wcPt2D * pIn, wcPt2D * pOut)
{
    std::cout << "--polygonClpSuhHodg--" << std::endl;
    wcPt2D * first[nClip] = {0, 0, 0, 0}, s[nClip];
    GLint k, cnt = 0;
    
    for (k = 0; k < n; k++) {
        clipPoint(pIn[k], Left, wMin, wMax, pOut, &cnt, first, s);
        std::cout << "--polygonClpSuhHodg-- : k = " << k << ", pIn = " << pIn[k].x << "," << pIn[k].y << std::endl;
    }
    
    closeClip(wMin, wMax, pOut, &cnt, first, s);
    return cnt;
}


