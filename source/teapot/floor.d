import std.typecons : scoped;
import gfm.math, gfm.opengl, gfm.assimp;
import engine;
import phong_program, model_matrix_setter;

class Floor
{
  private{
    vec3f _pos;
    mat4f _modelMatrix;
    ModelMatrixSetter _modelMatrixSetter;
    Model!VertexPN _model;
  }

  this(OpenGL gl, ISceneProgram sceneProgram, Assimp assimp, ModelMatrixSetter modelMatrixSetter)
  {
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
    _modelMatrixSetter.set(_modelMatrix);
    _model.draw();
  }
}