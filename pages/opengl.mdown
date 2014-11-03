Categories: c
Tags: opengl

References:
[1] OpenGL Programming Guide: The Official Guide to Learning OpenGL Versions 3.0 and 3.1, Seventh Edition. 
[2] OpenGL SuperBible: Comprehensive Tutorial and Reference, Fourth Edition.
[3] Beginning Opengl Game Programming, Second Edition

## Camera Management ##

- Typical rendering loop for a 3D environment:

        Save Identity Matrix.
        Apply camera transform.
        Draw stuff that doesn't move.
        Draw moving stuff (actors).
          Save camera transform.
          Apply actor transform.
          Draw actor geometry.
          Restore camera transform.
        Restore Identity matrix.


## Miscellaneous

### `glMatrixMode()` 

- Used to load a matrix.
- i.e.  

        glMatrixMode(GLenum mode);

        where mode can be:

          GL_MODELVIEW      Modelview matrix.
          GL_PROJECTION     Projection matrix.
          GL_COLOR          Color matrix.
          GL_TEXTURE        Texture matrix.

### `glLoadIdentity()`

- Resets the matrix to an identity matrix.

## `glViewport()`

- Adjusts the pixel rectangle for drawing to be the entire new window.
- The next three routines adjust the coordinate system for drawing so the lower left corner is (0, 0) and the upper right corner is (w, h)

        void reshape(int w, int h) {
           glViewport(0, 0, (GLsizei) w, (GLsizei) h) ;
           glMatrixMode(GL_PROJECTION) ;
           glLoadIdentity( ) ;
           gluOrtho2 D(0. 0, ( GLdouble) w, 0. 0, (GLdouble) h) ;
        }

- Note, `gluOrtho2()` puts origin (0, 0) in lowest leftmost square and makes each square represent 1 unit.

## Transformations ##

### Overview

- Reference: [3]

#### Modelling Transformation

- Moves objects around the  scene and moves objects from local coordinates into world coordinates.

#### Viewing Transformation

- Specifies location of camera and moves objects from world coordinates into eye/camera coordinates.

#### Projection Transformation

- Defines viewing volume and clipping planes and maps objects from eye coordinates to clip coordinates.

#### Viewport Transformation

- Maps clip coordinates into 2D viewport, or window on screen.

- Note, OpenGL combines modelling and viewing transformations into a single modelview transformation.





## Viewing Transformation ##

- Default orientation:
  - Down the negative z-axis.
  - Positioned at origin (0, 0, 0).
  - Up vector of (0, 1, 0).
- Operations:
  - Translation
    - Moving object along specified vector.
  - Rotation
    - Rotate object about a vector.
  - Scaling
    - Increase/decrease size of object.
    - i.e. by specifying different values for different axes.

### Before

- Before changing viewing transformation:
  - Load the modelview matrix:

          glMatrixMode(GL_MODELVIEW)

  - Clear the current matrix using.

          glLoadIdentity()


### `glTranslate{fd}()`

- Syntax:

      void glTranslate{fd}(TYPE x, TYPE y, TYPE z)

- `x`, `y` and `z` specify how much to translate along the corresponding axes.

- e.g.  Suppose you want to move a cube from the origin to the position (5, 5, 5). You first load the modelview matrix and reset it to the identity matrix, so you are starting at the origin (0, 0, 0). You then perform the translation transformation on the current matrix to position (5, 5, 5) before calling your renderCube() function. 
  - In code, this looks like 
  
          glMatrixMode(GL_MODELVIEW); // set current matrix to modelview
          glLoadIdentity(); // reset modelview to identity matrix
          glTranslatef(5.0f, 5.0f, 5.0f); // move to (5, 5, 5)
          renderCube(); // draw the cube

### `glRotate{fd}()`

- Syntax:

      void glRotate{fd}(TYPE angle, TYPE x, TYPE y, TYPE z);

- Rotating about the vector (x, y, z) using the specified `angle` (measured in degrees in the couterclockwise direction).

- e.g.

    glRotatef(135.0f, 0.0f, 1.0f, 0.0f);  // rotate around y axis 135 degrees
                                          // 1.of for y argument specifies a vector pointing in the direction of the positive y axis.

- For multiple rotations:
  - The second, third (and so on) rotation will not be in the context of the world coordinate system.
  - Instead, rotation will occur in the context of the object's local coordinate system.

### `glScale{fd}` 

- Syntax:

      void glScale{fd}(TYPE x, TYPE y, TYPE z)

- If all arguments 1.0, command has no effect.


### `glTranslate()`


### `glRotate()` 

### `gluLookAt()` 

- Used instead of `glTranslate()` and `glRotate()`
- Syntax:

        void gluLookAt(GLdouble eyex, GLdouble eyey, GLdouble eyez,
                       GLdouble centerx, GLdouble centery, GLdouble centerz,
                       GLdouble upx, GLdouble upy, GLdouble upz);

        eyex, eyey, eyez    Location of the camera.
        centerx, centery, centerz   Specify where the camera is pointing.
        upx, upy, upz   Vector, used to determine which direction is the up direction.



### `glPushMatrix()`/`glPopMatrix()`

- Manipulate the matrix stacks.

#### `glPushMatrix()`

- Copies the current matrix and pushes it onto the stack.
- Syntax:

        void glPushMatrix()

- e.g. modelview matrix stack allows you to save the current state of the transformation matrix, perform other transformations and then return to the saved transformation matrix without having to store or calculate the transformation matrix on your own.
- i.e. allows you to transform from one coordinate system to another while being able to revert to the original coordinate system.
- e.g.
  - Position at point (10, 5, 7)
  - Push the current modelview matrix onto the current stack
  - Current transformation matrix reset to the local coordinate system centred around point (10, 5, 7)
    - Any transformations based on the coordinate system at (10, 5, 7).

- Notes:
  - Modelview matrix stack guaranteed to have a stack depth of at least 32.
  - All other matrix stacks have a stack depth of at least 2.

## Projection Transformation ##

- Like choosing a lens for the camera.
- i.e. determines how objects projected onto screen.
- 2 types of projections:
  - Perspective Projection
    - like real world.
    - objects that are farther away appear smaller.
  - Orthographic Projection
    - Shows objects on screen in true size, regardless of distance from camera.
    - e.g. CAD, isometric games

- Before specifying projection transformation, make sure the projection matrix is the currently selected matrix stack, i.e.

      glMatrixMode(GL_PROJECTION)

- Most cases follow up with `glLoadIdentity()` to clear out projection matrix (so previous transformations are not accumulated).

### Orthographic

- No adjustment for distance from camera made.
- Syntax:

        glOrtho(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, 
                GLdouble near, GLdouble far)

        left/right  x coordinate clipping planes
        bottom/top  y coordinate clipping planes
        near/far    specify distance to z coordinate clipping planes

### Perspective

- Viewing volume for a perspective projection is a frustum (which looks like a pyramid with the top cut off) with the narrow end toward the viewer.
- OpenGL transforms the frustum so that it becomes a cube.
- The greater the ratio between the wide and narrow ends, the more an object is shrunk.

#### `glFrustum()`

- Syntax:

      void glFrustum(GLdouble left, GLdouble right, GLdouble bottom, 
                     GLdouble top, GLdouble near, GLdouble far)

      left,right,top,bottom   Together specify the x and y coordinates on the near clipping plane
      near,far                Specify the distance to the near and far clipping planes

- Top Left corner of the near clipping plane is at `(left, top, -near)`.
- Bottom right corner of the near clipping plane is at `(right, bottom, -near)`

- Corners of clipping plane determined by casting a ray from the viewer through the corners of the near clipping plane and intersecting them with teh far clipping plane.
  - The closer to the viewer is to the near clipping plane, the larger the far clipping plane is, and the more foreshortening is apparent.

#### `gluPerspective()`

- Syntax:

      void gluPerspective(GLdouble fov, GLdouble aspect, GLdouble near, GLdouble far)

      fov       Specifies, in degrees, the angle around the y axis that is visible to the user
      aspect    Is the aspect ratio of the screen (which is width/height)
      near/far  Specify the distance to the near and far clipping planes

- Notes:
  - `fov` and `aspect` determines the field of view around the x axis. 

- For realistic perspective, use around 45-90 degrees.

## Viewport Transformation

- Maps clip coordinates created by perspective transformation onto window.
- Dimensions and orientation of the 2D window into which you'll be rendering.
- Syntax:

      void glViewport(GLint x, GLint y, GLsizei width, GLsizei height);

      x,y   coordinates of the lower left corner of the viewport
      width, height specify the size of the window in pixels

- when rendering context first created, viewport automatically set to match the dimensions of the window.
- need to update your viewport when the window is resized.

- Positioning and aiming camera.
- glLoadIdentity() loads the current identity matrix.
- Viewing transformation specified with gluLookAt().
- The arguments specify:
    - Place the camera at (0, 0, 5)
    - Aim the camera lens toward (0, 0, 0)
    - Specify the up-vector as (0, 1, 0).

    - Note, the upvector defines a unique orientation for the camera.
    - Note 2, By default viewing transformation is specified with the camera is situated at the origin, points down the  negative z-axis, and has an up-vector of (0, 1, 0).

              void init( void)  {
                 glClearColor(0.0, 0.0, 0.0, 0.0) ;
                 glShadeModel(GL_FLAT) ;
              }
              
              void display(void) {
                 glClear(GL_COLOR_BUFFER_BIT) ;
                 glColor3f(1.0, 1.0, 1.0) ;
                 glLoadIdentity() ;             /* clear the matrix */
                         / * viewing transformation  */
                 gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0) ;
                 glScalef( 1. 0, 2. 0, 1. 0) ;      /* modeling transformation */ 
                 glutWireCube(1. 0) ;
                 glFlush() ;
              }
              
              void reshape(int w, int h) {
                 glViewport(0, 0, (GLsizei) w, (GLsizei) h) ; 
                 glMatrixMode(GL_PROJECTION) ;
                 glLoadIdentity() ;
                 glFrustum(-1. 0, 1. 0, -1. 0, 1. 0, 1. 5, 20. 0) ;
                 glMatrixMode(GL_MODELVIEW) ;
              }
              
              int main(int argc, char** argv) {
                 glutInit( &argc, argv) ;
                 glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB) ;
                 glutInitWindowSize( 500, 500) ; 
                 glutInitWindowPosition(100, 100) ;
                 glutCreateWindow( argv[ 0] ) ;
                 init() ;
                 glutDisplayFunc(display) ; 
                 glutReshapeFunc(reshape) ;
                 glutMainLoop() ;
                 return 0;
              }



