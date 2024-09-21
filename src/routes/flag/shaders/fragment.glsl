uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;
varying float vElevation;

void main()
{
    vec3 white = vec3(1.,1.,1.);
    vec3 blue = vec3(0.459, 0.667, 0.859);
    vec3 yellow = vec3(0.965, 0.706, 0.0549);
    vec3 color = blue;

    float sectorY = floor(vUv.y * 3.);
    float partY = mod(sectorY, 2.);

    float sunRadiusX = .07;
    float sunRadiusY = sunRadiusX / 2. * 3.;
    float sunRadiusFromX = .5 - sunRadiusX;
    float sunRadiusToX = .5 + sunRadiusX;
    float sunRadiusFromY = .5 - sunRadiusY;
    float sunRadiusToY = .5 + sunRadiusY;

    

    if (partY == 1.) {
      color = white;

      if (vUv.x > sunRadiusFromX && vUv.x < sunRadiusToX) {
        if (vUv.y > sunRadiusFromY && vUv.y < sunRadiusToY) {
          color = yellow;
        }
      }
    }
    
    gl_FragColor = vec4(color * (vElevation + .3), 1.0);

}