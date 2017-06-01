//
//  lineNLN.h
//  Chapter8Example6
//
//  Created by 张琳琪 on 2017/6/1.
//  Copyright © 2017年 张琳琪. All rights reserved.
//

#ifndef lineNLN_h
#define lineNLN_h

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
    GLint equals (wcPt2D p)
    {
        if(x == p.getx() && y == p.gety())
        {
            return 1;
        }
        return 0;
    }
};

void lineClipNLN(wcPt2D, wcPt2D, wcPt2D, wcPt2D);

#endif /* lineNLN_h */
