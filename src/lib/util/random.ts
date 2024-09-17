export function bool (): boolean {
  return Math.random() > 0.5
}

export function polarity (): number {
  return bool() ? -1 : 1
}

export function ratio (): number {
  return Math.random()
}

export function bipolarRatio (): number {
  return ratio() * polarity()
}

export function centeredRatio (): number {
  return ratio() - 0.5
}