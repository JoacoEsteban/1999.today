<script lang="ts">
  import { T, useTask } from '@threlte/core'
  import { Align, OrbitControls, Text3DGeometry } from '@threlte/extras'
  import { BufferGeometry, PerspectiveCamera } from 'three'
  import { Checkbox, Pane, Slider, TabGroup } from 'svelte-tweakpane-ui'

  let cam: PerspectiveCamera = null!
  let textGeo: BufferGeometry = null!

  const text = '1999 Today'
  const textRotation = [0, 0, 0]

  useTask((delta) => {
    cam.lookAt(0, 0, 0)
    textRotation[1] += 0.01
    textGeo?.center()
  })

  let bevelEnabled = true
  let wireframe = false
  let bevelOffset = 0
  let bevelSegments = 20
  let bevelSize = 0.2
  let bevelThickness = 0.1
  let curveSegments = 12
  let height = 1
  let size = 5
  let smooth = 0.1

  let metalness = 0.3
  let roughness = 0.3
  let toneMapped = false
</script>

<T.PerspectiveCamera
  makeDefault
  position={[0, 1, 50]}
  on:create={({ ref }) => {
    cam = ref
  }}
>
  <OrbitControls enableDamping />
</T.PerspectiveCamera>

<Align let:align>
  <T.Mesh rotation={textRotation}>
    <!-- font={$font} -->
    <Text3DGeometry
      font={'fonts/MADE TOMMY_Medium.json'}
      {text}
      {size}
      {height}
      {smooth}
      {curveSegments}
      {bevelEnabled}
      {bevelThickness}
      {bevelSize}
      {bevelOffset}
      {bevelSegments}
      on:create={({ ref }) => {
        textGeo = ref
        align()
      }}
    />
    <T.MeshStandardMaterial {wireframe} {toneMapped} {metalness} {roughness} />
    <!-- color="#ff0000" -->
  </T.Mesh>
</Align>

<!-- <Environment
  path={'environment-maps/'}
  files={'full-earth.hdr'}
  isBackground={true}
/> -->

<!-- <T.DirectionalLight position={[0, 10, 10]} /> -->

<!-- <T.AmbientLight color="white" intensity="1" /> -->
<T.RectAreaLight color={'#FF00FF'} position={[0, 10, 10]} intensity={10} />
<T.PointLight intensity="1140" color="#00ff00" position={[0, 1, 50]} />
<Pane title="Material" position="fixed">
  <TabGroup>
    <Slider
      bind:value={metalness}
      label="Metalness"
      min={0}
      max={1}
      step={0.1}
    />
    <Slider
      bind:value={roughness}
      label="Roughness"
      min={0}
      max={1}
      step={0.1}
    />
    <Checkbox bind:value={toneMapped} label="Tone Mapped" />
  </TabGroup>

  <TabGroup>
    <Slider bind:value={size} label="Size" min={1} max={10} step={0.1} />
    <Slider bind:value={height} label="Height" min={1} max={10} step={0.1} />
    <Slider
      bind:value={curveSegments}
      label="Curve segments"
      min={1}
      max={300}
      step={1}
    />
    <Checkbox bind:value={bevelEnabled} label="Bevel enabled" />
    <Checkbox bind:value={wireframe} label="Wireframe" />
    <Slider
      bind:value={bevelThickness}
      label="Bevel thickness"
      min={0}
      max={10}
      step={0.1}
    />
    <Slider
      bind:value={bevelSize}
      label="Bevel size"
      min={0}
      max={0.5}
      step={0.001}
    />
    <Slider
      bind:value={bevelOffset}
      label="Bevel offset"
      min={0}
      max={10}
      step={0.1}
    />
    <Slider
      bind:value={bevelSegments}
      label="Bevel segments"
      min={1}
      max={10}
      step={1}
    />
    <Slider bind:value={smooth} label="Smooth" min={1} max={100} step={1} />
  </TabGroup>
</Pane>
