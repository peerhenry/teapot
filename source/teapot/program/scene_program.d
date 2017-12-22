import gfm.opengl, gfm.math;
import engine;
import uniform_setter;

interface ISceneProgram
{
  @property GLProgram program();
  @property VertexSpecification!VertexPN vertexSpec();
  void render(void delegate() renderScene);
  void setUniformSetter(UniformSetter setter);
}

abstract class BaseProgram : ISceneProgram
{
  protected
  {
    GLProgram _program;
    VertexSpecification!VertexPN spec;
  }

  @property GLProgram program(){ return _program; }
  @property VertexSpecification!VertexPN vertexSpec(){ return spec; }
}