import gfm.math;

class DirectionalLight
{
  vec3f direction;
  mat4f pv;

  this()
  {
    direction = vec3f(-0.8, 0.3, -1.0);
    mat4f ortho = mat4f.orthographic( -100, 100, -100, 100, 1, 100 );
    mat4f proj = mat4f.lookAt(-direction*10, vec3f(0,0,0), vec3f(0,0,1));
    pv = ortho * proj;
  }
}