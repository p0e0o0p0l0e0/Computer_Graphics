
void main ()
{
//    gl_Position = gl_ProjectionMatrix * (gl_ModelViewMatrix * gl_Vertex);
    gl_Position = ftransform();
    gl_FrontColor = gl_Color;
}
