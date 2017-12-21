import gfm.opengl, gfm.math;
import engine;

interface ISceneProgram
{
  @property GLProgram program();
  @property VertexSpecification!VertexPN vertexSpec();
  void setUniforms();
}

class PhongProgram: ISceneProgram
{
  private
  {
    GLProgram _program;
    VertexSpecification!VertexPN spec;
  }

  @property GLProgram program(){ return _program; }
  @property VertexSpecification!VertexPN vertexSpec(){ return spec; }
  
  this(OpenGL gl)
  {
    createProgram(gl);
    initUniforms();
  }

  private void createProgram(OpenGL gl)
  {
    // dispense with loading and compiling of individual shaders
    string[] shader_source = readLines("source/teapot/glsl/phong.glsl");
    _program = new GLProgram(gl, shader_source);
    spec = new VertexSpecification!VertexPN(_program);
  }

  private void initUniforms()
  {
    _program.uniform("LightDirection").set( vec3f(-0.8, 0.3, -1.0).normalized() );
    _program.uniform("LightColor").set( vec3f(1.0, 1.0, 1.0) );
    _program.uniform("AmbientColor").set( vec3f(0.4, 0.4, 0.4) );
    _program.uniform("MaterialColor").set( vec3f(1, 1, 1) );
    _program.uniform("PVM").set( mat4f.identity );
    _program.uniform("NormalMatrix").set( mat3f.identity );
  }

  ~this()
  {
    _program.destroy;
    spec.destroy;
  }

  void setUniforms()
  {
    //texture.bind();
  }
}