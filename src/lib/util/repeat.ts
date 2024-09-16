export function* repeat (times: number): Generator<number> {
  for (let i = 0; i < times; i++) {
    yield i
  }
}