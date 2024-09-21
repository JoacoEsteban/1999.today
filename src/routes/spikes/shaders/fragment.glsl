uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;
varying float vElevation;

void main()
{
    vec3 color = vec3(vUv, 0.859);
    
    gl_FragColor = vec4(color * (vElevation), vElevation);
}