<script lang="ts">
  import { T, useTask } from '@threlte/core'
  import { Environment, interactivity } from '@threlte/extras'
  import { spring } from 'svelte/motion'
  import { Clock, PerspectiveCamera, PlaneGeometry, PointLight } from 'three'
  import { fromEvent, map } from 'rxjs'

  interactivity()
  const clock = new Clock(true)

  const scale = spring(1)
  let cam: PerspectiveCamera = null!

  const sensitivity = 4
  const mouse = { x: 0, y: 0 }
  let rotation = 0

  const mouse$ = fromEvent<MouseEvent>(window, 'mousemove')
    .pipe(
      map((e) => ({
        x: e.clientX / window.innerWidth - 0.5,
        y: -(e.clientY / window.innerHeight - 0.5),
      })),
    )
    .pipe(map(({ x, y }) => ({ x: x * sensitivity, y: y * sensitivity })))

  mouse$.subscribe(({ x, y }) => {
    mouse.x = x
    mouse.y = y
  })

  useTask((delta) => {
    rotation += delta * 0.2

    const x = mouse.x * sensitivity
    const y = mouse.y * sensitivity

    const lap = Math.PI * 2
    cam.position.x = lap * Math.sin(x)
    cam.position.z = lap * Math.cos(x)
    cam.position.y = y

    cam.lookAt(0, 0, 0)
  })
</script>

<Environment
  path={'environment-maps/'}
  files={'full-earth.hdr'}
  isBackground={true}
/>

<T.PerspectiveCamera
  makeDefault
  position={[10, 4, 10]}
  on:create={({ ref }) => {
    cam = ref
  }}
></T.PerspectiveCamera>

<T.AmbientLight args={['#ff0']} />
<T.PointLight args={['#00f', 30]} position={[0, 10, 10]} />

<T.Mesh scale={$scale} rotation.z={rotation} rotation.x={rotation}>
  <T.TorusKnotGeometry args={[, , 200, 30]} />
  <T.MeshStandardMaterial
    args={[
      {
        color: '#f0f',
        emissive: '#050',
        metalness: 1,
        roughness: 0,
      },
    ]}
  />
</T.Mesh>
