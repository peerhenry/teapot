import gfm.math, gfm.opengl;
import engine;
import teapot;

class UniformSetter
{
  private
  {
    Camera _cam;
    GLProgram _program;
    DirectionalLight _light;
    int _state;
  }

  this(ISceneProgram sceneProgram, Camera camera, DirectionalLight light)
  {
    _cam = camera;
    _program = sceneProgram.program;
    _light = light;
  }

  void setShadowState()
  {
    _state = 1;
  }

  void setNormalState()
  {
    _state = 0;
  }

  void set(IGameObject go)
  {
    if(_state == 0) setNormal(go);
    else setShadow(go);
  }

  private void setNormal(IGameObject go)
  {
    _program.uniform("MaterialColor").set(go.color);
    _program.uniform( "ViewPosition" ).set( _cam.position );
    mat4f m = go.modelMatrix;
    mat4f vm = _cam.view * m;
    mat3f nm = cast(mat3f)m;
    mat4f pvm = _cam.projection * vm;
    _program.uniform( "Model" ).set( m );
    _program.uniform( "NormalMatrix" ).set( nm );
    _program.uniform( "PVM" ).set( pvm );
  }

  private void setShadow(IGameObject go)
  {
    mat4f m = go.modelMatrix;
    mat4f pvm = _light.pv * m;
    _program.uniform( "Model" ).set( m );
    _program.uniform( "PVM" ).set( pvm );
  }
}