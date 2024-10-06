uniform vec3 uColor;
uniform float uTime;
uniform float uTotalHeight;
uniform float aIndex;

varying vec2 vUv;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u * u * (3.0 - 2.0 * u);

    float res = mix(
            mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
            mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x), u.y);
    return res * res;
}
void main()
{
    float time = uTime * 1.0;
    float density = 10000.0;
    float phaseX = (sin(time + vUv.x * 25.) / 2. + .5);
    float phaseY = (sin(time + vUv.y * 25.) / 2. + .5);
    float phase = phaseX * phaseY;

    vec2 nUv = vUv * density;
    nUv.x = floor(nUv.x);
    nUv.y = floor(nUv.y);

    float ratio = noise(nUv) * phase;
    float offset = step(.02 * aIndex, ratio);
    float height = aIndex / uTotalHeight;

    gl_FragColor = vec4(phaseY, height * .8, phaseX, offset);
}
