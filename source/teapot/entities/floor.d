import std.typecons : scoped;
import gfm.math, gfm.opengl, gfm.assimp;
import engine;
import teapot;

class Floor: IGameObject
{
  private{
    vec3f _pos;
    mat4f _modelMatrix;
    ISceneProgram _sceneProgram;
    UniformSetter _modelMatrixSetter;
    Model!VertexPN _model;
    vec3f _color = vec3f(0.7, 0.55, 0.33);
  }

  @property mat4f modelMatrix(){ return _modelMatrix; }
  @property vec3f position(){ return _pos; }
  @property vec3f color(){ return _color; }

  this(OpenGL gl, ISceneProgram sceneProgram, Assimp assimp, UniformSetter modelMatrixSetter)
  {
    _sceneProgram = sceneProgram;
    _pos = vec3f(0,0,0);
    _modelMatrix = mat4f.translation(_pos);
    _modelMatrixSetter = modelMatrixSetter;

    VertexPN[] vertices = [
      VertexPN( vec3f(-100, -100, 0), vec3f(0, 0, 1) ),
      VertexPN( vec3f(-100, 100, 0), vec3f(0, 0, 1) ),
      VertexPN( vec3f(100, -100, 0), vec3f(0, 0, 1) ),
      VertexPN( vec3f(100, 100, 0), vec3f(0, 0, 1) )
    ];

    uint[] indices = [
      0,1,2,2,1,3
    ]; 

    auto myMesh = Mesh!VertexPN(vertices, indices);
    _model = new Model!VertexPN(gl, sceneProgram.vertexSpec, myMesh);
  }

  ~this()
  {
    _model.destroy;
  }

  void draw()
  {
    _modelMatrixSetter.set(this);
    _model.draw();
  }
}