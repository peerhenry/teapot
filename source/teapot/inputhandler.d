import gfm.math, gfm.sdl2;
import engine;
import teapot_scene;

class InputHandler
{
  private
  {
    SDL2 sdl;
    int prev_x;
    int prev_y;
    Camera _cam;
    TeapotScene _scene;
  }

  this(Context context, Camera cam, TeapotScene scene)
  {
    this.sdl = context.sdl;
    _cam = cam;
    this.sdl.mouse.startCapture();
    SDL_SetRelativeMouseMode(true);
    _scene = scene;
  }

  void update()
  {
    updateMouse();
    updateKeys();
  }

  private void updateMouse()
  {
    updateMouseMovement();
    updateMouseClicks();
  }

  private void updateMouseMovement()
  {
    int new_x = sdl.mouse.x;
    int new_y = sdl.mouse.y;
    int dx = 0;
    int dy = 0;
    bool rotate = false;
    if(new_x != prev_x)
    {
      dx = sdl.mouse.lastDeltaX;
      rotate = true;
    }
    if(new_y != prev_y)
    {
      dy = sdl.mouse.lastDeltaY;
      rotate = true;
    }
    if(rotate)
    {
      float dtheta = -cast(float)(dx)*0.005;
      float dphi = -cast(float)(dy)*0.005;
      _cam.rotate(dtheta, dphi);
    }
    this.prev_x = new_x;
    this.prev_y = new_y;
  }

  private void updateMouseClicks()
  {
    // Check if the left mouse button is pressed
    if(sdl.mouse.isButtonPressed(SDL_BUTTON_LMASK))
    {
    }
  }

  bool tab_was_down = false;

  private void updateKeys()
  {
    if(sdl.keyboard.isPressed(SDLK_TAB))
    {
      if(!tab_was_down)
      {
        _scene.tabModel();
      }
      tab_was_down = true;
    }
    else if(tab_was_down)
    {
      tab_was_down = false;
    }

    // MOVEMENT
    bool f = sdl.keyboard.isPressed(SDLK_a);
    bool b = sdl.keyboard.isPressed(SDLK_z);
    bool l = sdl.keyboard.isPressed(SDLK_s);
    bool r = sdl.keyboard.isPressed(SDLK_d);
    bool u = sdl.keyboard.isPressed(SDLK_SPACE);
    bool d = sdl.keyboard.isPressed(SDLK_LCTRL);
    //byte moveByte = f + (b<<1) + (l<<2) + (r<<3) + (u<<4) + (d<<5);

    bool isMoving = false;
    vec3f movedir = vec3f(0,0,0);
    if(f)
    {
      movedir += vec3f(_cam.direction.x, _cam.direction.y, 0);
      if(!b) isMoving = true;
    }
    else if(b)
    {
      movedir -= vec3f(_cam.direction.x, _cam.direction.y, 0);
      isMoving = true;
    }

    if(l)
    {
      movedir -= _cam.directionRight;
      if(!r) isMoving = true;
    }
    else if(r)
    {
      movedir += _cam.directionRight;
      isMoving = true;
    }

    if(u)
    {
      movedir += vec3f(0,0,1);
      if(!d) isMoving = true;
    }
    else if(d)
    {
      movedir += vec3f(0,0,-1);
      isMoving = true;
    }

    if(isMoving)
    {
      movedir.fastNormalize();
      vec3f ds = 0.5*movedir;
      _cam.translate(ds);
    }
  }
  bool wasPressed = false;
}