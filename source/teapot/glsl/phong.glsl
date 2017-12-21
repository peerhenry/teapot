#version 400

#if VERTEX_SHADER
layout(location=0) in vec3 position;
layout(location=1) in vec3 normal;

out vec3 PosToView;
out vec3 Normal;

uniform mat4 PVM;
uniform mat4 Model;
uniform mat3 NormalMatrix;
uniform vec3 ViewPosition;

void main()
{
  Normal = normalize(NormalMatrix * normal);
  PosToView = (Model * vec4(position, 1.0)).xyz - ViewPosition;
  gl_Position = PVM * vec4(position, 1.0);
}
#endif

#if FRAGMENT_SHADER
in vec3 PosToView;
in vec3 Normal;
out vec4 FragColor;

uniform vec3 LightDirection;
uniform vec3 LightColor;
uniform vec3 AmbientColor;
uniform vec3 MaterialColor;
uniform float MaterialShininess;

vec3 phong(vec3 targetDir)
{
  vec3 ray = normalize(LightDirection);
  vec3 ambient = AmbientColor * MaterialColor;
  float sDotN = max(dot(-ray, Normal), 0.0);
  vec3 diffuse = sDotN * LightColor * MaterialColor;
  vec3 specular = vec3(0.0);
  if(sDotN > 0.0)
  {
    float specAmp = dot(-targetDir, reflect(ray, Normal));
    specular = LightColor * MaterialColor * pow( max(specAmp, 0.0) , MaterialShininess);
  }
  return ambient + diffuse + specular;
}

void main()
{
  vec3 targetDir = normalize(PosToView);
  FragColor = vec4(phong(targetDir), 1.0);
}
#endif