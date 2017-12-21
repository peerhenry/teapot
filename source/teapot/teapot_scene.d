import phong_program, teapot_model, floor;

class TeapotScene
{
  private{
    ISceneProgram _sceneProgram;
    Floor _floor;
    TeapotModel _teapot;
  }

  this(ISceneProgram sceneProgram, TeapotModel teapot, Floor floor)
  {
    _sceneProgram = sceneProgram;
    _teapot = teapot;
    _floor = floor;
    _teapot.loadModel("resources/venusm.obj");
  }

  ~this()
  {
    _floor.destroy;
    _teapot.destroy;
    _sceneProgram.destroy;
  }

  void draw()
  {
    _sceneProgram.program.use();
    _sceneProgram.setUniforms();
    _floor.draw();
    _teapot.draw();
    _sceneProgram.program.unuse();
  }
}