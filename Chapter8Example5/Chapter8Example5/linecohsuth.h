//
//  linecohsuth.h
//  Chapter8Example3
//
//  Created by 张琳琪 on 2017/5/27.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#ifndef linecohsuth_h
#define linecohsuth_h

inline int round (const float a) { return int (a + 0.5); }

class wcPt2D
{
private:
    GLfloat x, y;
    
public:
    wcPt2D(){
        x = y = 0.0;
    }
    void setCoords(GLfloat xCoord, GLfloat yCoord)
    {
        x = xCoord;
        y = yCoord;
    }
    GLfloat getx () const
    {
        return x;
    }
    GLfloat gety () const
    {
        return y;
    }
};

void lineClipCohSuth(wcPt2D, wcPt2D, wcPt2D, wcPt2D);

#endif /* linecohsuth_h */
