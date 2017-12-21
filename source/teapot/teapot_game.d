import gfm.math, gfm.opengl;
import engine;
import skybox, inputhandler, teapot;

class TeapotGame: Game
{
  private{
    Skybox _skybox;
    TeapotScene _scene;
    InputHandler _input;
    Camera _cam;
  }

  this(Camera camera, InputHandler input, Skybox skybox, TeapotScene scene)
  {
    _skybox = skybox;
    _input = input;
    _scene = scene;
    camera.setPosition(vec3f(50,50,30));
    camera.setRotation(1.25*3.14, -0.2);
    camera.setRatio(16.0/9);
    _cam = camera;
    _cam.update(0);
  }

  ~this()
  {
    _skybox.destroy();
    _scene.destroy();
  }

  void initialize()
  {
    import std.stdio; writeln("initializing works!"); // DEBUG
    setGlSettings();
  }

  void setGlSettings()
  {
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    glEnable(GL_CULL_FACE);
    glFrontFace(GL_CW); // clockwise faces are front
    glClearColor(100.0/255, 149.0/255, 237.0/255, 1.0); // cornflower blue
    glPointSize(1.0);
    glEnable(GL_BLEND); 
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  }

  void update(double dt_ms)
  {
    _cam.preUpdate();
    _input.update();
    _cam.update(dt_ms);
  }

  void draw()
  {
    _skybox.draw();
    _scene.draw();
  }
}