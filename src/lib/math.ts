function normalize (fx: (x: number) => number) {
  return (x: number) => fx(x) / 2 + 0.5
}

export const trig = {
  sin: normalize(Math.sin),
  cos: normalize(Math.cos),
}