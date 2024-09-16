<script lang="ts">
  import { repeat } from '$lib/util/repeat'
  import { T, useLoader, useTask } from '@threlte/core'
  import { BehaviorSubject } from 'rxjs'
  import {
    BoxGeometry,
    Clock,
    MeshStandardMaterial,
    PointLight,
    RepeatWrapping,
    SRGBColorSpace,
    TextureLoader,
  } from 'three'
  import Ghost from './Ghost.svelte'
  import { trig } from '$lib/math'

  export let castShadow = false
  const lights = [
    {
      color: '#8800ff',
      position: new BehaviorSubject<[number, number, number]>([0, 0, 0]),
    },
    {
      color: '#ff0088',
      position: new BehaviorSubject<[number, number, number]>([0, 0, 0]),
    },
    {
      color: '#ff0000',
      position: new BehaviorSubject<[number, number, number]>([0, 0, 0]),
    },
  ]

  function getPosition(i: number, elapsed: number): [number, number, number] {
    const speed = 0.2 + 0.3 * trig.sin(i)
    elapsed *= speed
    if (i % 2) elapsed *= -1
    // elapsed += i * 10
    const radius = 4 + i
    const x = Math.sin(elapsed) * radius
    const z = Math.cos(elapsed) * radius
    const y =
      trig.sin(elapsed) * trig.sin(elapsed * 2.34) * trig.sin(elapsed * 3.45)
    return [x, y, z]
  }

  const clock = new Clock(true)
  useTask(() => {
    lights.forEach((light, i) => {
      const elapsed = clock.getElapsedTime()
      light.position.next(getPosition(i, elapsed))
    })
  })
</script>

<!-- <T.Group> -->
{#each lights as { color, position }, i}
  <Ghost {color} {position} {castShadow} />
{/each}
<!-- </T.Group> -->
