<script lang="ts">
  import { repeat } from '$lib/util/repeat'
  import { T, useLoader } from '@threlte/core'
  import {
    BoxGeometry,
    MeshStandardMaterial,
    RepeatWrapping,
    SRGBColorSpace,
    TextureLoader,
  } from 'three'

  export let castShadow = false
  const height = 0.8
  const graveGeo = new BoxGeometry(0.5, height, 0.2)
  const graveMat = new MeshStandardMaterial()

  const txLoader = useLoader(TextureLoader)

  const graveTexPath = (name: string, ext = 'jpg.webp') =>
    `/grave/plastered_stone_wall_1k/plastered_stone_wall_${name}_1k.${ext}`
  // [alpha, normal, diff, disp, rmao]
  const graveTexture = Promise.all([
    // txLoader.load('/grave/alpha.jpg.webp'),
    txLoader.load(graveTexPath('nor_gl')),
    txLoader.load(graveTexPath('diff')),
    txLoader.load(graveTexPath('disp')),
    txLoader.load(graveTexPath('arm')),
  ])
  graveTexture.then((txs) => {
    const [, colorTx] = txs
    colorTx.colorSpace = SRGBColorSpace
    txs.slice(1).forEach((tx) => {
      tx.wrapS = RepeatWrapping
      tx.wrapT = RepeatWrapping
      tx.repeat.set(1, 1)
    })

    const [normalMap, map, displacementMap, rmao] = txs

    graveMat.normalMap = normalMap
    graveMat.map = map
    graveMat.roughnessMap = rmao
    graveMat.metalnessMap = rmao
    graveMat.aoMap = rmao
    // graveMat.displacementMap = displacementMap
    graveMat.displacementScale = 0.4
  })

  function getPosition(i: number): [number, number, number] {
    const angle = Math.random() * Math.PI * 2
    const radius = 3 + Math.random() * 7
    const offset = 4

    const x = Math.cos(angle) * radius
    const z = Math.sin(angle) * radius
    const y = (Math.random() * height) / 2

    return [z, y, x]
  }

  function getRotation(i: number): [number, number, number] {
    const x = Math.PI * 2 * ((Math.random() - 0.5) * 0.1)
    const z = Math.PI * 2 * ((Math.random() - 0.5) * 0.1)
    const y = Math.PI * 2 * ((Math.random() - 0.5) * 0.1)

    return [z, y, x]
  }
</script>

{#await graveTexture then _}
  <T.Group>
    {#each repeat(30) as i}
      <T.Mesh position={getPosition(i)} rotation={getRotation(i)} {castShadow}>
        <T is={graveGeo} />
        <T is={graveMat} />
      </T.Mesh>
    {/each}
  </T.Group>
{/await}
