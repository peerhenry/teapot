import gfm.opengl, gfm.math;
import engine;
import teapot;

class ShadowProgram : BaseProgram
{
  GLFBO _fbo;
  uint _recDepth;
  uint _shade;
  GLTexture2D _tex;
  int shadowMapWith, shadowMapHeight;
  UniformSetter _setter;

  this(OpenGL gl, UniformSetter setter)
  {
    string[] shader_source = readLines("source/teapot/glsl/shadow.glsl");
    _program = new GLProgram(gl, shader_source);
    spec = new VertexSpecification!VertexPN(_program);
    initUniforms();
    createShadowMapTex(gl);
    createFBO(gl);
    shadowMapWith = 1024;
    shadowMapHeight = 1024;
    _setter = setter;
  }

  ~this()
  {
    _program.destroy;
    spec.destroy;
  }

  void render(void delegate() renderScene)
  {
    _program.use();
    renderShadowMap(renderScene);
    renderView(renderScene);
    _program.unuse();
  }

  private void renderShadowMap(void delegate() renderScene)
  {
    _setter.setShadowState();
    _fbo.use();
    glClear(GL_DEPTH_BUFFER_BIT);
    glCullFace(GL_FRONT);
    glUniformSubroutinesuiv(GL_FRAGMENT_SHADER, 1, &_recDepth);
    renderScene();
  }

  private void renderView(void delegate() renderScene)
  {
    _setter.setNormalState();
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glCullFace(GL_BACK);
    glUniformSubroutinesuiv(GL_FRAGMENT_SHADER, 1, &_shade);
    renderScene();
  }

  private void initUniforms()
  {
    vec3f lightDir = vec3f(-0.8, 0.3, -1.0);
    mat4f shadowMatrix = mat4f.identity(); // B*P*V*M
    _program.uniform("LightDirection").set( lightDir.normalized() );
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
    _program.uniform("ShadowMatrix").set( shadowMatrix );
    // get subroutine handles
    _recDepth = glGetSubroutineIndex(_program.handle, GL_FRAGMENT_SHADER, "recordDepth");
    _shade = glGetSubroutineIndex(_program.handle, GL_FRAGMENT_SHADER, "shadeWithShadow");
  }

  private void createShadowMapTex(OpenGL gl)
  {
    float[] border = [1.0,0.0,0.0,0.0];
    _tex = new GLTexture2D(gl);
    _tex.setImage(0, GL_DEPTH_COMPONENT, shadowMapWith,shadowMapHeight, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, null);
    _tex.setMinFilter(GL_NEAREST); // GL_LINEAR_MIPMAP_LINEAR
    _tex.setMagFilter(GL_NEAREST); // GL_LINEAR
    _tex.setWrapS(GL_CLAMP_TO_BORDER);
    _tex.setWrapT(GL_CLAMP_TO_BORDER);

    //_tex.setBorderColor(border);
    //glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, &border);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LESS);
    _tex.use(GL_TEXTURE0);
  }

  private void createFBO(OpenGL gl)
  {
    _fbo = new GLFBO(gl);
    _fbo.depth.attach(_tex);
  }
}