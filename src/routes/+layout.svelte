<div>
  <slot />
</div>

<style>
  :global(body) {
    margin: 0;
  }

  div {
    width: 100vw;
    height: 100vh;
    background: black;
    /* background: linear-gradient(180deg, white 0%, black 100%); */
  }
</style>
