import std.typecons : scoped;
import gfm.math, gfm.opengl, gfm.assimp;
import engine;
import phong_program, model_matrix_setter;

class TeapotModel
{
  vec3f _pos;
  mat4f _modelMatrix;
  ModelMatrixSetter _modelMatrixSetter;
  Model!VertexPN _model;

  @property mat4f modelMatrix(){ return _modelMatrix; }
  @property vec3f position(){ return _pos; }

  this(OpenGL gl, ISceneProgram sceneProgram, Assimp assimp, ModelMatrixSetter modelMatrixSetter)
  {
    _pos = vec3f(0,0,0);
    _modelMatrix = mat4f.translation(_pos);
    _modelMatrixSetter = modelMatrixSetter;

    auto file = scoped!AssimpScene(assimp, "resources/venusl.obj", aiProcess_Triangulate);
    auto scene = file.scene();
    auto mesh = scene.mMeshes[0];

    VertexPN[] vertices;
    foreach(vidx; 0..mesh.mNumVertices)
    {
      auto vertex = mesh.mVertices[vidx];
      auto normal = mesh.mNormals[vidx];
      vertices ~= VertexPN(vec3f(vertex.x, vertex.z, vertex.y), vec3f(normal.x, normal.z, normal.y));
      //vertices ~= VertexPN(vec3f(vertex.x, vertex.y, vertex.z), vec3f(1,0,0));
    }

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
    _model = new Model!VertexPN(gl, sceneProgram.vertexSpec, myMesh);
    assimp.destroy;
  }

  ~this()
  {
    _model.destroy;
  }

  void draw()
  {
    // set uniform
    _modelMatrixSetter.set(_modelMatrix);
    _model.draw();
  }
}