<script lang="ts">
  import { T, useLoader, useTask, useThrelte } from '@threlte/core'
  import { Gizmo, OrbitControls } from '@threlte/extras'
  import { Checkbox, Folder, Pane, Slider, TabGroup } from 'svelte-tweakpane-ui'
  import House from './house/House.svelte'
  import {
    Fog,
    FogExp2,
    HemisphereLight,
    RepeatWrapping,
    SRGBColorSpace,
    TextureLoader,
  } from 'three'
  import Ghosts from './house/Ghosts.svelte'
  import { Sky } from 'three/addons/objects/Sky.js'
  import { label } from 'three/examples/jsm/nodes/Nodes.js'

  const { scene } = useThrelte()

  scene.fog = new FogExp2('#02343f', 0.1)

  let castShadow = true
  $: receiveShadow = castShadow
  const txLoader = useLoader(TextureLoader)
  const floorSize = 20
  const floorVerts = 100
  const floorTxScale = 8
  const texPath = (name: string, ext = 'jpg.webp') =>
    `/floor/coast_sand_rocks_02_1k/coast_sand_rocks_02_${name}_1k.${ext}`

  // [alpha, normal, diff, disp, rmao]
  const floorTexture = Promise.all([
    txLoader.load('/floor/alpha.jpg.webp'),
    txLoader.load(texPath('nor_gl')),
    txLoader.load(texPath('diff')),
    txLoader.load(texPath('disp')),
    txLoader.load(texPath('arm')),
  ])

  floorTexture.then((txs) => {
    const [, , colorTx] = txs
    colorTx.colorSpace = SRGBColorSpace
    txs.slice(1).forEach((tx) => {
      tx.wrapS = RepeatWrapping
      tx.wrapT = RepeatWrapping
      tx.repeat.set(floorTxScale, floorTxScale)
    })
  })

  const sky = new Sky()
  {
    const { uniforms } = sky.material
    uniforms.turbidity.value = 10
    uniforms.rayleigh.value = 3
    uniforms.mieCoefficient.value = 0.1
    uniforms.mieDirectionalG.value = 0.95
    uniforms.sunPosition.value.set(0.3, -0.038, -0.95)
    sky.scale.setScalar(100)
  }

  useTask((delta) => {})
</script>

<T.PerspectiveCamera makeDefault position={[0, 10, floorSize]}>
  <OrbitControls enableDamping />
</T.PerspectiveCamera>

<Gizmo />
<T.Mesh rotation.x={-Math.PI / 2} {receiveShadow}>
  <T.PlaneGeometry args={[floorSize, floorSize, floorVerts, floorVerts]} />
  {#await floorTexture then [alphaMap, normalMap, map, displacementMap, rmao]}
    <T.MeshStandardMaterial
      {alphaMap}
      {map}
      {normalMap}
      {displacementMap}
      aoMap={rmao}
      roughnessMap={rmao}
      metalnessMap={rmao}
      displacementScale={0.3}
      displacementBias={-0.2}
      transparent
    />
  {/await}
</T.Mesh>

<House {castShadow} />
<Ghosts {castShadow} />

<T.AmbientLight color="#86cdff" intensity={1.275} />

<T.DirectionalLight
  on:create={({ ref }) => {
    const size = 2 ** 8
    const { camera, mapSize } = ref.shadow

    mapSize.width = size
    mapSize.height = size

    camera.top = 8
    camera.right = 8
    camera.bottom = -8
    camera.left = -8
    camera.near = 1
    camera.far = 20
  }}
  color="#86cdff"
  position={[3, 2, -8]}
  intensity={1}
  {castShadow}
/>

<T is={sky} />

<Pane title="House Scene" position="fixed">
  <Folder title="Lighting">
    <Checkbox label="Shadows" bind:value={castShadow} />
  </Folder>
  <Folder title="Models"></Folder>
</Pane>
