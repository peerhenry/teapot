#version 400

#if VERTEX_SHADER
layout(location=0) in vec3 position;
layout(location=1) in vec3 normal;

out vec3 PosToView;
out vec3 Normal;
out vec4 ShadowCoord;

uniform mat4 PVM;
uniform mat4 Model;
uniform mat3 NormalMatrix;
uniform mat4 ShadowMatrix;
uniform vec3 ViewPosition;

void main()
{
  Normal = normalize(NormalMatrix * normal);
  PosToView = (Model * vec4(position, 1.0)).xyz - ViewPosition;
  ShadowCoord = ShadowMatrix * vec4(position, 1.0);
  gl_Position = PVM * vec4(position, 1.0);
}
#endif

#if FRAGMENT_SHADER
in vec3 PosToView;
in vec3 Normal;
in vec4 ShadowCoord;
out vec4 FragColor;

uniform sampler2DShadow ShadowMap;
uniform vec3 LightDirection;
uniform vec3 LightColor;
uniform vec3 AmbientColor;
uniform vec3 MaterialColor;
uniform float MaterialShininess;

vec3 phong(vec3 targetDir)
{
  vec3 ray = normalize(LightDirection);
  float sDotN = max(dot(-ray, Normal), 0.0);
  vec3 diffuse = sDotN * LightColor * MaterialColor;
  vec3 specular = vec3(0.0);
  if(sDotN > 0.0)
  {
    float specAmp = dot(-targetDir, reflect(ray, Normal));
    specular = LightColor * MaterialColor * pow( max(specAmp, 0.0) , MaterialShininess);
  }
  return diffuse + specular;
}

subroutine void RenderPassType();
subroutine uniform RenderPassType RenderPass;

subroutine(RenderPassType)
void shadeWithShadow()
{
  vec3 targetDir = normalize(PosToView);
  vec3 diffSpec = phong(targetDir);
  float shadow = textureProj(ShadowMap, ShadowCoord);
  vec3 ambient = AmbientColor * MaterialColor;
  FragColor = vec4(diffSpec * shadow + ambient, 1.0);
}

subroutine(RenderPassType)
void recordDepth()
{
  // do nothing, depth is written automatically
}

void main()
{
  RenderPass();
}
#endif