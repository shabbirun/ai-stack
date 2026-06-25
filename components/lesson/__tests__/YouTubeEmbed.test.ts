import { describe, it, expect } from 'vitest'

function getYouTubeId(url: string): string | null {
  const match = url.match(
    /(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
  )
  return match?.[1] ?? null
}

describe('getYouTubeId', () => {
  it('extracts ID from watch URL', () => {
    expect(getYouTubeId('https://www.youtube.com/watch?v=dQw4w9WgXcQ')).toBe('dQw4w9WgXcQ')
  })
  it('extracts ID from youtu.be shortlink', () => {
    expect(getYouTubeId('https://youtu.be/dQw4w9WgXcQ')).toBe('dQw4w9WgXcQ')
  })
  it('returns null for non-YouTube URL', () => {
    expect(getYouTubeId('https://vimeo.com/123')).toBeNull()
  })
  it('returns null for empty string', () => {
    expect(getYouTubeId('')).toBeNull()
  })
})
