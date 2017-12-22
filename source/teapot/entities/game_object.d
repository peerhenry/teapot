import std.stdio;
import std.typecons : scoped;
import gfm.math, gfm.opengl, gfm.assimp;
import engine;
import teapot;

class GameObject: IGameObject
{
  private
  {
    vec3f _pos;
    mat4f _modelMatrix;
    UniformSetter _modelMatrixSetter;
    Model!VertexPN _model;
    float _scale;
    vec3f _color;

    OpenGL _gl;
    ISceneProgram _sceneProgram;
    Assimp _assimp;
  }

  @property mat4f modelMatrix(){ return _modelMatrix; }
  @property vec3f position(){ return _pos; }
  @property vec3f color(){ return _color; }

  this(OpenGL gl, ISceneProgram sceneProgram, Assimp assimp, UniformSetter modelMatrixSetter)
  {
    _gl = gl;
    _sceneProgram = sceneProgram;
    _modelMatrixSetter = modelMatrixSetter;
    _assimp = assimp;
    _scale = 1.0;
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
    _modelMatrix = mat4f.translation(_pos) * mat4f.scaling( vec3f(_scale, _scale, _scale) );
  }
  
  void loadModel(string path, float scale, vec3f color)
  {
    _color = color;
    writeln("loading model: ", path);
    _scale = scale;
    if(_model !is null) _model.destroy;
    //auto file = scoped!AssimpScene(_assimp, path, aiProcess_Triangulate);
    //auto file = scoped!AssimpScene(_assimp, path, aiProcess_JoinIdenticalVertices);
    auto file = scoped!AssimpScene(_assimp, path, aiProcess_GenSmoothNormals);
    writeln("file loaded.");
    //file.applyPostProcessing(aiProcess_GenSmoothNormals);
    file.applyPostProcessing(aiProcess_JoinIdenticalVertices);
    file.applyPostProcessing(aiProcess_ValidateDataStructure);
    auto scene = file.scene();
    auto mesh = scene.mMeshes[0];
    float lowestZ = 99999999.0;
    VertexPN[] vertices;
    writeln("it has ", mesh.mNumVertices, " vertices.");
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
    // set uniforms
    _sceneProgram.program.uniform("MaterialColor").set(_color);
    _modelMatrixSetter.set(this);
    _model.draw();
  }
}