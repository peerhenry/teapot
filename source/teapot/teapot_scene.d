import phong_program, teapot_model, floor;

class TeapotScene
{
  private{
    ISceneProgram _sceneProgram;
    Floor _floor;
    TeapotModel _teapot;
    string[] _models = [
      //"resources/objects/teapot.obj" // doesn't work yet...
      "resources/objects/ateneam.obj"
      , "resources/objects/elepham.obj"
      , "resources/objects/venusm.obj"
    ];
    int _index = 0;
  }

  this(ISceneProgram sceneProgram, TeapotModel teapot, Floor floor)
  {
    _sceneProgram = sceneProgram;
    _teapot = teapot;
    _floor = floor;
    _teapot.loadModel(_models[0]);
  }

  void tabModel()
  {
    _index = (_index+1) % _models.length;
    _teapot.loadModel(_models[_index]);
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