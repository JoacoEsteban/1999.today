<script lang="ts">
  import { T, useLoader, useTask } from '@threlte/core'
  import {
    BoxGeometry,
    Clock,
    Color,
    MeshStandardMaterial,
    RepeatWrapping,
    SphereGeometry,
    SRGBColorSpace,
    TextureLoader,
  } from 'three'
  import Bushes from './Bushes.svelte'
  import Graves from './Graves.svelte'
  import { BehaviorSubject, interval, map, pipe } from 'rxjs'
  import { trig } from '$lib/math'

  const size = 4
  const height = size * 0.625
  const roofWidth = size * 0.875
  const roofHeight = size * 0.375
  const doorSize = size * 0.55

  export let castShadow = false
  $: receiveShadow = castShadow

  const txLoader = useLoader(TextureLoader)

  const wallTexPath = (name: string, ext = 'jpg.webp') =>
    `/wall/castle_brick_broken_06_1k/castle_brick_broken_06_${name}_1k.${ext}`
  // [alpha, normal, diff, disp, rmao]
  const wallTexture = Promise.all([
    // txLoader.load('/wall/alpha.jpg.webp'),
    txLoader.load(wallTexPath('nor_gl')),
    txLoader.load(wallTexPath('diff')),
    txLoader.load(wallTexPath('disp')),
    txLoader.load(wallTexPath('arm')),
  ])
  wallTexture.then((txs) => {
    const [, colorTx] = txs
    colorTx.colorSpace = SRGBColorSpace
    txs.slice(1).forEach((tx) => {
      tx.wrapS = RepeatWrapping
      tx.wrapT = RepeatWrapping
      tx.repeat.set(1, 1)
    })
  })

  const roofTexPath = (name: string, ext = 'jpg.webp') =>
    `/roof/roof_slates_02_1k/roof_slates_02_${name}_1k.${ext}`
  const roofTexture = Promise.all([
    // txLoader.load('/roof/alpha.jpg.webp'),
    txLoader.load(roofTexPath('nor_gl')),
    txLoader.load(roofTexPath('diff')),
    txLoader.load(roofTexPath('disp')),
    txLoader.load(roofTexPath('arm')),
  ])

  roofTexture.then((txs) => {
    const [, colorTx] = txs
    colorTx.colorSpace = SRGBColorSpace
    txs.slice(1).forEach((tx) => {
      tx.wrapS = RepeatWrapping
      tx.wrapT = RepeatWrapping
      tx.repeat.set(3, 1)
    })
  })

  const doorTexPath = (name: string, ext = 'jpg.webp') => `/door/${name}.${ext}`
  const doorTexture = Promise.all([
    txLoader.load(doorTexPath('alpha')),
    txLoader.load(doorTexPath('normal')),
    txLoader.load(doorTexPath('color')),
    txLoader.load(doorTexPath('height')),
    txLoader.load(doorTexPath('metalness')),
    txLoader.load(doorTexPath('roughness')),
    txLoader.load(doorTexPath('ambientOcclusion')),
  ])

  doorTexture.then((txs) => {
    const [, , colorTx] = txs
    colorTx.colorSpace = SRGBColorSpace
    // txs.slice(1).forEach((tx) => {
    //   tx.wrapS = RepeatWrapping
    //   tx.wrapT = RepeatWrapping
    //   // tx.repeat.set(1, 1)
    // })
  })

  const doorLightIntensity = new BehaviorSubject(5)

  const clock = new Clock(true)
  useTask(() => {
    const elapsed = clock.getElapsedTime()
    const speed = 3
    const factor =
      trig.sin(elapsed * speed) *
      trig.sin(elapsed * speed * 0.36) *
      trig.sin(elapsed * speed * 10)
    const max = 2
    doorLightIntensity.next(0.1 + factor * max)
  })
</script>

<T.Group>
  {#await wallTexture then [normalMap, map, displacementMap, rmao]}
    <T.Mesh {castShadow} {receiveShadow} position.y={height / 2}>
      <T.BoxGeometry args={[size, height, size, 1, 1]} />
      <T.MeshStandardMaterial
        {map}
        aoMap={rmao}
        roughnessMap={rmao}
        metalnessMap={rmao}
        {normalMap}
      />
      <!-- displacementScale={0.1}
        displacementBias={-0.07}
        {displacementMap} -->
    </T.Mesh>
  {/await}

  {#await roofTexture then [normalMap, map, displacementMap, rmao]}
    <T.Mesh
      {castShadow}
      {receiveShadow}
      position.y={height + roofHeight / 2}
      rotation.y={Math.PI / 4}
    >
      <T.ConeGeometry args={[roofWidth, roofHeight, size]} />
      <!-- wireframe -->
      <T.MeshStandardMaterial
        {map}
        aoMap={rmao}
        roughnessMap={rmao}
        metalnessMap={rmao}
        {normalMap}
      />
      <!-- {displacementMap}
        displacementScale={0.2}
        displacementBias={-0.07} -->
    </T.Mesh>
  {/await}
  {#await doorTexture then [alphaMap, normalMap, map, displacementMap, metalnessMap, roughnessMap, aoMap]}
    <T.Mesh
      {castShadow}
      {receiveShadow}
      position.z={size / 2 + 0.001}
      position.y={1.1}
    >
      <T.PlaneGeometry args={[doorSize, doorSize, 100, 100]} />
      <T.MeshStandardMaterial
        {alphaMap}
        {map}
        {normalMap}
        {displacementMap}
        {metalnessMap}
        {roughnessMap}
        {aoMap}
        transparent
        displacementScale={0.15}
        displacementBias={-0.04}
      />
    </T.Mesh>
  {/await}
  <Bushes />
  <T.PointLight
    color="#ff7d46"
    intensity={$doorLightIntensity}
    position={[0, doorSize, size / 2 + 0.1]}
  />
</T.Group>
<Graves {castShadow} />
