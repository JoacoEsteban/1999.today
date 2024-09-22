<script lang="ts">
  import { T, useTask } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'
  import { Clock, BufferAttribute, PerspectiveCamera } from 'three'

  import vertexShader from './shaders/vertex.glsl'
  import fragmentShader from './shaders/fragment.glsl'
  import { Pane, Slider } from 'svelte-tweakpane-ui'
  import { repeat } from '$lib/util/repeat'
  import { BehaviorSubject, fromEvent } from 'rxjs'

  let cam: PerspectiveCamera = null!

  let camZ = 2
  const uniforms = {
    uTime: { value: 0 },
  }
  const clock = new Clock(true)
  // const mouse = new BehaviorSubject([0, 0])
  // fromEvent<MouseEvent>(document, 'mousemove').forEach((e) => {
  //   mouse.next(
  //     [e.x / window.innerWidth, e.y / window.innerHeight]
  //       .map((v) => v - 0.5)
  //       .map((v) => v / 3),
  //   )
  // })

  // mouse.forEach(console.log)

  useTask(() => {
    const elapsedTime = clock.getElapsedTime()
    uniforms.uTime.value = elapsedTime
    // const [x, y] = mouse.value
    // cam.position.x = x
    // cam.position.y = -y
    // cam.lookAt(0, 0, 0)
  })
</script>

<T.PerspectiveCamera
  makeDefault
  position={[0.25, -0.25, camZ]}
  on:create={({ ref }) => (cam = ref)}
>
  <OrbitControls enableDamping />
</T.PerspectiveCamera>

<T.Mesh scale.y={1}>
  <T.ShaderMaterial {vertexShader} {fragmentShader} {uniforms} transparent />
  <T.PlaneGeometry args={[1, 1, 25, 25]} />
</T.Mesh>

<Pane position="fixed">
  <!-- <Slider label="Zoom" bind:value={camZ} min={0} max={2} /> -->
</Pane>
