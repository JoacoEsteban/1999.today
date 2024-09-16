<script lang="ts">
  import { T, useLoader } from '@threlte/core'
  import {
    BoxGeometry,
    Color,
    MeshStandardMaterial,
    RepeatWrapping,
    SphereGeometry,
    SRGBColorSpace,
    TextureLoader,
  } from 'three'

  const bushGeo = new SphereGeometry(1, 16, 16)
  const bushMat = new MeshStandardMaterial({
    color: '#ccffcc',
  })

  const bushes = [
    {
      scale: 0.5,
      position: [0.8, 0.2, 2.2],
      rotation: [-0.75, 0, 0],
    },
    {
      scale: 0.25,
      position: [1.4, 0.1, 2.1],
      rotation: [-0.75, 0, 0],
    },
    {
      scale: 0.4,
      position: [-0.8, 0.1, 2.2],
      rotation: [-0.75, 0, 0],
    },
    {
      scale: 0.2,
      position: [-1, 0.05, 2.6],
      rotation: [-0.75, 0, 0],
    },
  ]

  const txLoader = useLoader(TextureLoader)

  const bushTexPath = (name: string, ext = 'jpg.webp') =>
    `/bush/leaves_forest_ground_1k/leaves_forest_ground_${name}_1k.${ext}`
  // [alpha, normal, diff, disp, rmao]
  const bushTexture = Promise.all([
    // txLoader.load('/bush/alpha.jpg.webp'),
    txLoader.load(bushTexPath('nor_gl')),
    txLoader.load(bushTexPath('diff')),
    txLoader.load(bushTexPath('disp')),
    txLoader.load(bushTexPath('arm')),
  ])
  bushTexture.then((txs) => {
    const [, colorTx] = txs
    colorTx.colorSpace = SRGBColorSpace
    txs.slice(1).forEach((tx) => {
      tx.wrapS = RepeatWrapping
      tx.wrapT = RepeatWrapping
      tx.repeat.set(1, 1)
    })

    const [normalMap, map, displacementMap, rmao] = txs

    bushMat.normalMap = normalMap
    bushMat.map = map
    bushMat.roughnessMap = rmao
    bushMat.metalnessMap = rmao
    bushMat.aoMap = rmao
    bushMat.displacementMap = displacementMap
    bushMat.displacementScale = 0.4
  })
</script>

{#await bushTexture then _}
  {#each bushes as bush}
    <T.Mesh
      scale={[bush.scale, bush.scale, bush.scale]}
      position={bush.position}
      rotation={bush.rotation}
    >
      <T is={bushGeo} />
      <T is={bushMat} />
    </T.Mesh>
  {/each}
{/await}
