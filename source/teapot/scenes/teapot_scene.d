import gfm.opengl, gfm.assimp, gfm.math;
import teapot;

struct ModelLoadDetails
{
  string path;
  float scale;
  vec3f color;
}

class TeapotScene
{
  private{
    ISceneProgram _sceneProgram;
    ISceneProgram _shadowProgram;
    Floor _floor;
    GameObject[] _models;
    GameObject _activeModel;
    ModelLoadDetails[] _modelDetails = [
      ModelLoadDetails("resources/objects/teapot.obj", 8, vec3f(.9, .9, .7))
      //, ModelLoadDetails("resources/objects/ateneam.obj", 0.01, vec3f(.9, .9, .7))
      //, ModelLoadDetails("resources/objects/bunny.ply", 1) // not working...
      // , ModelLoadDetails("resources/objects/dragon.ply", 1) // crashes game...
      //, ModelLoadDetails("resources/objects/elepham.obj", 0.07, vec3f(.9, .9, .7))
      , ModelLoadDetails("resources/objects/venusm.obj", 0.01, vec3f(.9, .9, .7))
    ];
    int _index = 0;
  }

  this(ISceneProgram sceneProgram, Floor floor, OpenGL gl, Assimp assimp, UniformSetter uniformSetter)
  {
    _sceneProgram = sceneProgram;
    _floor = floor;

    foreach(details; _modelDetails)
    {
      auto nextModel = new GameObject(gl, sceneProgram, assimp, uniformSetter);
      nextModel.loadModel(details.path, details.scale, details.color);
      _models ~= nextModel;
    }
    _activeModel = _models[_index];
  }

  void tabModel()
  {
    _index = (_index+1) % _models.length;
    _activeModel = _models[_index];
  }

  ~this()
  {
    _floor.destroy;
    foreach(model; _models)
    {
      model.destroy;
    }
    _sceneProgram.destroy;
  }

  void draw()
  {
    _sceneProgram.render(delegate void(){
      _floor.draw();
      _activeModel.draw();
    });
  }
}