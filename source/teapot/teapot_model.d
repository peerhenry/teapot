import std.typecons : scoped;
import gfm.math, gfm.opengl, gfm.assimp;
import engine;
import phong_program, model_matrix_setter;

class TeapotModel
{
  private
  {
    vec3f _pos;
    mat4f _modelMatrix;
    ModelMatrixSetter _modelMatrixSetter;
    Model!VertexPN _model;
    float _scale;

    OpenGL _gl;
    ISceneProgram _sceneProgram;
    Assimp _assimp;
  }

  @property mat4f modelMatrix(){ return _modelMatrix; }
  @property vec3f position(){ return _pos; }

  this(OpenGL gl, ISceneProgram sceneProgram, Assimp assimp, ModelMatrixSetter modelMatrixSetter)
  {
    _gl = gl;
    _sceneProgram = sceneProgram;
    _modelMatrixSetter = modelMatrixSetter;
    _assimp = assimp;
    _scale = 0.01;
    setPosition(0,0,0);
  }

  ~this()
  {
    if(_model !is null) _model.destroy;
    _assimp.destroy;
  }

  void setPosition(float x, float y, float z)
  {
    _pos = vec3f(x,y,z);
    _scale = 0.01;
    _modelMatrix = mat4f.translation(_pos) * mat4f.scaling( vec3f(_scale, _scale, _scale) );
  }

  void loadModel(string path)
  {
    if(_model !is null) _model.destroy;
    auto file = scoped!AssimpScene(_assimp, path, aiProcess_Triangulate);
    auto scene = file.scene();
    auto mesh = scene.mMeshes[0];
    float lowestZ = 99999999.0;
    VertexPN[] vertices;
    foreach(vidx; 0..mesh.mNumVertices)
    {
      auto vertex = mesh.mVertices[vidx];
      auto normal = mesh.mNormals[vidx];
      vertices ~= VertexPN(vec3f(vertex.x, vertex.z, vertex.y), vec3f(normal.x, normal.z, normal.y));
      if(vertex.y < lowestZ) lowestZ = vertex.y;
    }

    setPosition(0, 0, -_scale*lowestZ);

    uint[] indices;
    foreach (fidx; 0..mesh.mNumFaces)
    {
      auto face = mesh.mFaces[fidx];
      foreach (vidx; 0..face.mNumIndices)
      {
        auto idx = face.mIndices[vidx];
        indices ~= idx;
      }
    }

    auto myMesh = Mesh!VertexPN(vertices, indices);
    _model = new Model!VertexPN(_gl, _sceneProgram.vertexSpec, myMesh);
  }

  void draw()
  {
    // set uniform
    _modelMatrixSetter.set(_modelMatrix);
    _model.draw();
  }
}