import gfm.opengl, gfm.math;
import engine;
import scene_program;


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
    string[] shader_source = readLines("source/teapot/glsl/phong.glsl");
    _program = new GLProgram(gl, shader_source);
    spec = new VertexSpecification!VertexPN(_program);
  }

  private void initUniforms()
  {
    _program.uniform("LightDirection").set( vec3f(-0.8, 0.3, -1.0).normalized() );
    _program.uniform("LightColor").set( vec3f(.95, .95, .75) );
    _program.uniform("AmbientColor").set( vec3f(0.3, 0.3, 0.3) );
    _program.uniform("MaterialColor").set( vec3f(0.8, 0.8, 0.8) );
    _program.uniform("PVM").set( mat4f.identity );
    //_program.uniform("VM").set( mat4f.identity );
    _program.uniform("Model").set( mat4f.identity );
    _program.uniform("ViewPosition").set( vec3f(0,0,0) );
    _program.uniform("NormalMatrix").set( mat3f.identity );
    float shiny = 64.0;
    _program.uniform("MaterialShininess").set( shiny );
  }

  ~this()
  {
    _program.destroy;
    spec.destroy;
  }

  void render(void delegate() renderScene)
  {
    _program.use();
    renderScene();
    _program.unuse();
  }
}