<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { PCFShadowMap } from 'three'
</script>

<Canvas shadows={PCFShadowMap}>
  <slot />
</Canvas>
