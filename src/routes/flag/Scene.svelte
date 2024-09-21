<script lang="ts">
  import { T, useTask } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'
  import { PlaneGeometry, Mesh, Vector2, Color, Clock } from 'three'

  import vertexShader from './shaders/vertex.glsl'
  import fragmentShader from './shaders/fragment.glsl'
  import { Pane, Slider } from 'svelte-tweakpane-ui'

  const uniforms = {
    uFrequency: { value: new Vector2(15, 5) },
    uTime: { value: 0 },
    // uTexture: { value: flagTexture }
  }
  const clock = new Clock(true)
  useTask(() => {
    const elapsedTime = clock.getElapsedTime()
    uniforms.uTime.value = elapsedTime
  })
</script>

<T.PerspectiveCamera makeDefault position={[0.25, -0.25, 1.5]}>
  <OrbitControls enableDamping />
</T.PerspectiveCamera>

<T.Mesh scale.y={2 / 3}>
  <T.ShaderMaterial {vertexShader} {fragmentShader} {uniforms} transparent />
  <T.PlaneGeometry args={[1, 1, 1000, 1000]} />
</T.Mesh>

<Pane position="fixed">
  <Slider
    bind:value={uniforms.uFrequency.value.x}
    label="FrequencyX"
    min={0}
    max={100}
    step={0.01}
  />
  <Slider
    bind:value={uniforms.uFrequency.value.y}
    label="FrequencyY"
    min={0}
    max={100}
    step={0.01}
  />
</Pane>
