precision mediump float;

uniform vec2 uFrequency;
uniform float uTime;

varying vec2 vUv;
varying float vElevation;

attribute float aRandom;

void main () {
  vec4 modelPosition = modelMatrix * vec4(position, 1.0);
  float offset = aRandom * .2;

  float val = (offset * ((sin(uTime + uv.x * 3.) + 1.)/2. + .5));

  // modelPosition.z += val;

  vec4 viewPosition = viewMatrix * modelPosition;
  vec4 projectedPosition = projectionMatrix * viewPosition;

  gl_Position = projectedPosition;

  vUv = uv;
  vElevation = aRandom;
}