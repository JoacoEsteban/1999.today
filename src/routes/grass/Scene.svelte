<script lang="ts">
  import { T, useTask } from '@threlte/core'
  import { OrbitControls, Sky } from '@threlte/extras'
  import {
    Clock,
    BufferAttribute,
    PerspectiveCamera,
    ShaderMaterial,
    PlaneGeometry,
  } from 'three'
  import { InstancedUniformsMesh } from 'three-instanced-uniforms-mesh'

  import vertexShader from './shaders/vertex.glsl'
  import fragmentShader from './shaders/fragment.glsl'
  import { Pane, Slider } from 'svelte-tweakpane-ui'
  import { repeat } from '$lib/util/repeat'
  import { BehaviorSubject, fromEvent } from 'rxjs'

  let cam: PerspectiveCamera = null!

  const grassLayers = 32
  const uniforms = {
    uTime: { value: 0 },
    aIndex: { value: 0 },
    uTotalHeight: { value: grassLayers },
  }
  const clock = new Clock(true)
  const mouse = new BehaviorSubject([0, 0])
  fromEvent<MouseEvent>(document, 'mousemove').forEach((e) => {
    mouse.next(
      [e.x / window.innerWidth, e.y / window.innerHeight]
        .map((v) => v - 0.5)
        .map((v) => v / 3),
    )
  })

  useTask(() => {
    const elapsedTime = clock.getElapsedTime()
    uniforms.uTime.value = elapsedTime
    // const [x, y] = mouse.value
    // cam.position.x = x
    // cam.position.y = -y
    cam.lookAt(0, 0, 0)
  })

  const grassMaterial = new ShaderMaterial({
    vertexShader,
    fragmentShader,
    uniforms,
    transparent: true,
  })

  const grassGeometry = new PlaneGeometry(100, 100, 1, 1)

  const mesh = new InstancedUniformsMesh(
    grassGeometry,
    grassMaterial,
    grassLayers,
  )

  for (const i of repeat(grassLayers)) {
    // mesh.setMatrixAt(i, )
    mesh.setUniformAt('aIndex', i, i)
    // mesh.set
    // mesh.position.set(0, i, 0)
  }
</script>

<Sky />
<T.PerspectiveCamera
  makeDefault
  position={[0, 1, 1]}
  on:create={({ ref }) => (cam = ref)}
>
  <OrbitControls enableDamping />
</T.PerspectiveCamera>

<T is={mesh} rotation={[-Math.PI / 2, 0, 0]} />
<!-- {#each repeat(grassLayers) as i}
  <T.Mesh
    scale.y={1}
    rotation={[-Math.PI / 2, 0, 0]}
    position={[0, i / 200, 0]}
  >
    <T is={grassMaterial} elevation={i} />
    <T is={grassGeometry} />
  </T.Mesh>
{/each} -->

<Pane position="fixed">
  <!-- <Slider label="Zoom" bind:value={camZ} min={0} max={2} /> -->
</Pane>
