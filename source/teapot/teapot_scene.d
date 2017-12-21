import phong_program, teapot_model;

class TeapotScene
{
  private{
    ISceneProgram _sceneProgram;
    TeapotModel _teapot;
  }

  this(ISceneProgram sceneProgram, TeapotModel teapot)
  {
    _sceneProgram = sceneProgram;
    _teapot = teapot;
  }

  ~this()
  {
    _teapot.destroy;
    _sceneProgram.destroy;
  }

  void draw()
  {
    _sceneProgram.program.use();
    _sceneProgram.setUniforms();
    _teapot.draw();
    _sceneProgram.program.unuse();
  }
}