<script lang="ts">
  import { centeredRatio, polarity, ratio } from '$lib/util/random'
  import { repeat } from '$lib/util/repeat'
  import { T, useTask, useThrelte } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'
  import {
    BehaviorSubject,
    combineLatest,
    debounceTime,
    map,
    pairwise,
  } from 'rxjs'
  import { Pane, Slider, Color as ColorPicker } from 'svelte-tweakpane-ui'
  import {
    AdditiveBlending,
    BufferAttribute,
    BufferGeometry,
    Color,
    Points,
    PointsMaterial,
  } from 'three'
  import { lerp } from 'three/src/math/MathUtils.js'

  const { scene } = useThrelte()
  const particlesAmount$ = new BehaviorSubject(100000)
  const particlesSize$ = new BehaviorSubject(0.01)
  const radius$ = new BehaviorSubject(5)
  const branches$ = new BehaviorSubject(3)
  const spin$ = new BehaviorSubject(1)
  const randomness$ = new BehaviorSubject(0.2)
  const randomnessPower$ = new BehaviorSubject(3)
  const outsideColor$ = new BehaviorSubject('#1b3984')
  const insideColor$ = new BehaviorSubject('#ff6030')
  particlesAmount$.set = particlesAmount$.next.bind(particlesAmount$)
  particlesSize$.set = particlesSize$.next.bind(particlesSize$)
  radius$.set = radius$.next.bind(radius$)
  branches$.set = branches$.next.bind(branches$)
  spin$.set = spin$.next.bind(spin$)
  randomness$.set = randomness$.next.bind(randomness$)
  randomnessPower$.set = randomnessPower$.next.bind(randomnessPower$)
  outsideColor$.set = outsideColor$.next.bind(outsideColor$)
  insideColor$.set = insideColor$.next.bind(insideColor$)

  function getPoints(
    amount: number,
    size: number,
    radius: number,
    branches: number,
    spin: number,
    randomness: number,
    randomnessPower: number,
    outsideColor: string,
    insideColor: string,
  ) {
    const iterations = amount * 3
    const geometry = new BufferGeometry()
    const positions = new Float32Array(iterations)
    const colors = new Float32Array(iterations)
    for (const i of repeat(amount)) {
      const i3 = i * 3
      const length = radius * Math.random()
      const angle = ((i % branches) / branches) * Math.PI * 2 + length * spin

      const offset = () =>
        Math.pow(ratio(), randomnessPower) * randomness * polarity()

      positions[i3] = (Math.cos(angle) + offset()) * length
      positions[i3 + 1] = offset() * length
      positions[i3 + 2] = (Math.sin(angle) + offset()) * length

      const color = new Color(insideColor).lerp(
        new Color(outsideColor),
        length / radius,
      )

      colors[i3] = color.r
      colors[i3 + 1] = color.g
      colors[i3 + 2] = color.b
    }

    geometry.setAttribute('position', new BufferAttribute(positions, 3))
    geometry.setAttribute('color', new BufferAttribute(colors, 3))

    const material = new PointsMaterial({
      size,
      sizeAttenuation: true,
      depthWrite: false,
      blending: AdditiveBlending,
      vertexColors: true,
    })

    return new Points(geometry, material)
  }

  // const points$ = new BehaviorSubject(
  //   getPoints(particlesAmount$.value, particlesSize$.value, radius$.value),
  // )
  const points$ = combineLatest([
    particlesAmount$,
    particlesSize$,
    radius$,
    branches$,
    spin$,
    randomness$,
    randomnessPower$,
    outsideColor$,
    insideColor$,
  ]).pipe(
    debounceTime(100),
    map((args) => {
      return getPoints(...args)
    }),
  )
  // .forEach((points) => points$.next(points))

  points$
    .pipe(
      pairwise(),
      map(([last]) => {
        last.material.dispose()
        last.geometry.dispose()
        scene.remove(last)
      }),
    )
    .subscribe()
  lerp
</script>

<T.PerspectiveCamera makeDefault position={[10, 0, 0]}>
  <OrbitControls enableDamping />
</T.PerspectiveCamera>

{#if $points$}
  <T is={$points$} />
{/if}
<Pane title="Galaxy" position="fixed">
  <Slider
    label="Points"
    bind:value={$particlesAmount$}
    min={1}
    max={1_000_000}
    step={1}
  />
  <Slider
    label="Size"
    bind:value={$particlesSize$}
    min={0.0001}
    max={0.1}
    step={0.001}
  />
  <Slider label="Radius" bind:value={$radius$} min={1} max={10} step={1} />
  <Slider label="Branches" bind:value={$branches$} min={1} max={10} step={1} />
  <Slider label="Spin" bind:value={$spin$} min={0} max={10} step={1} />
  <Slider
    label="Randomness"
    bind:value={$randomness$}
    min={0}
    max={2}
    step={0.01}
  />
  <Slider
    label="Randomness Power"
    bind:value={$randomnessPower$}
    min={1}
    max={10}
    step={0.001}
  />
  <ColorPicker label="Inside Color" bind:value={$insideColor$} />
  <ColorPicker label="Outside Color" bind:value={$outsideColor$} />
</Pane>
