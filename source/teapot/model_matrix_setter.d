import gfm.math, gfm.opengl;
import engine;
import phong_program;

class ModelMatrixSetter
{
  private Camera _cam;
  private GLProgram _program;

  this(ISceneProgram sceneProgram, Camera camera)
  {
    _cam = camera;
    _program = sceneProgram.program;
  }

  void set(mat4f modelMatrix)
  {
    _program.uniform( "ViewPosition" ).set( _cam.position );
    mat4f m = modelMatrix;
    mat4f vm = _cam.view * m;
    mat3f nm = cast(mat3f)m;
    mat4f pvm = _cam.projection * vm;
    _program.uniform( "Model" ).set( m );
    _program.uniform( "NormalMatrix" ).set( nm );
    _program.uniform( "PVM" ).set( pvm );
  }
}