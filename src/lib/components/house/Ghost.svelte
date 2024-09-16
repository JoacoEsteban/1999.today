<script lang="ts">
  import { T } from '@threlte/core'
  import { Observable } from 'rxjs'

  export let color: string = ''
  export let position: Observable<[number, number, number]>
  export let castShadow = false
</script>

<T.PointLight
  {color}
  position={$position}
  intensity={6}
  {castShadow}
  on:create={({ ref }) => {
    const size = 2 ** 8
    const { camera, mapSize } = ref.shadow

    mapSize.width = size
    mapSize.height = size

    // camera.near = 1
    camera.far = 20
  }}
/>
