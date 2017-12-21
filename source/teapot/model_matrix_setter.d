import gfm.math, gfm.opengl;
import engine;
import phong_program;

class ModelMatrixSetter
{
  private Camera _cam;
  private GLProgram _program;
  string pvmName = "PVM";

  this(ISceneProgram sceneProgram, Camera camera)
  {
    _cam = camera;
    _program = sceneProgram.program;
  }

  void set(mat4f modelMatrix)
  {
    mat4f scaleMatrix = mat4f.scaling( vec3f(0.01, 0.01, 0.01) );
    mat4f pvm = _cam.projection * _cam.view * modelMatrix * scaleMatrix;
    _program.uniform( pvmName ).set( pvm ); // PVM
  }
}