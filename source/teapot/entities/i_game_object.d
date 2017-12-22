import gfm.math;

interface IGameObject
{
  @property mat4f modelMatrix();
  @property vec3f position();
  @property vec3f color();
}