#define PI 3.1415926535897932384626433832795
uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;

float line(float threshold, float coord, float offset) {
    return step(threshold, mod((coord * 10.) + offset, 1.));
}

float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid) {
    return vec2(
      cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
      cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}

float pat15() {
    float v_step = .8;
    float v_halfstep = v_step / 2.;
    float outC = (line(v_halfstep, (vUv.x), v_halfstep)) * line(v_step, (vUv.y - .5), -v_step);
    outC += line(v_step, vUv.x, -v_halfstep) * line(v_halfstep, vUv.y, .0);

    return outC;
}

float pat16 () {
    return abs(vUv.x - .5);
}

float pat17() {
    return min(abs(vUv.x - .5), abs(vUv.y - .5));
}

float pat18() {
    return max(abs(vUv.x - .5), abs(vUv.y - .5));
}

float pat19() {
    return step(.2, max(abs(vUv.x - .5), abs(vUv.y - .5)));
}

float pat20() {
    float outer = 1. - step(.25, max(abs(vUv.x - .5), abs(vUv.y - .5)));
    float inner = step(.2, max(abs(vUv.x - .5), abs(vUv.y - .5)));
    return min(outer, inner);
}

float pat21() {
    return floor(vUv.x * 10.)/10.;
}

float pat22() {
    float x = floor(vUv.x * 10.)/10.;
    float y = floor(vUv.y * 10.)/10.;
    return x * y;
}

float pat23() {
    return random(vUv);
}

float pat24() {
    float x = floor(vUv.x * 10.)/10.;
    float y = floor(vUv.y * 10.)/10.;
    return random(vec2(x, y));
}

float pat25() {
    float x = floor(vUv.x * 10.)/10.;
    float y = floor((vUv.y + vUv.x * .5) * 10.)/10.;
    return random(vec2(x, y));
}

float pat26() {
    return length(vUv);
}

float pat27() {
    return distance(vUv, vec2(.5));
}

float pat28() {
    return 1. - distance(vUv, vec2(.5));
}

float pat29() {
    return .015 / distance(vUv, vec2(.5));
}

float pat30() {
    return .015 / distance(vec2(vUv.x * .1 + .45, vUv.y * .5 + .25), vec2(.5));
}

float pat31() {
    float x = .015 / distance(vec2(vUv.x * .1 + .45, vUv.y * .5 + .25), vec2(.5));
    float y = .015 / distance(vec2(vUv.y * .1 + .45, vUv.x * .5 + .25), vec2(.5));

    return x * y;
}

float pat32() {
    vec2 rot = rotate(vUv, PI * .25, vec2(.5, .5));
    float x = .015 / distance(vec2(rot.x * .1 + .45, rot.y * .5 + .25), vec2(.5));
    float y = .015 / distance(vec2(rot.y * .1 + .45, rot.x * .5 + .25), vec2(.5));

    return x * y;
}

float pat33() {
    return step(.25, distance(vUv, vec2(.5)));
}

float pat34() {
    return distance(vUv, vec2(.5));
}

void main()
{
    float outC = pat34();
    gl_FragColor = vec4(outC, outC, outC, 1.);
}