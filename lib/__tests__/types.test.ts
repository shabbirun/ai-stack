import { describe, it, expect } from 'vitest'
import type { Profile, Module, Lesson, Comment, LessonRequest, ModuleWithLessons } from '../types'

describe('types', () => {
  it('Profile has required fields', () => {
    const p: Profile = {
      id: '1', is_admin: false, has_paid: false,
      stripe_customer_id: null, created_at: '2026-01-01',
    }
    expect(p.has_paid).toBe(false)
  })

  it('Lesson youtube_url is nullable', () => {
    const l: Lesson = {
      id: '1', module_id: '2', title: 'Test', youtube_url: null,
      content: '', order: 1, created_at: '2026-01-01',
    }
    expect(l.youtube_url).toBeNull()
  })

  it('Comment parent_id is nullable for top-level', () => {
    const c: Comment = {
      id: '1', lesson_id: '2', user_id: '3', parent_id: null,
      content: 'Hello', created_at: '2026-01-01',
    }
    expect(c.parent_id).toBeNull()
  })

  it('ModuleWithLessons extends Module with lessons array', () => {
    const m: ModuleWithLessons = {
      id: '1', title: 'Intro', order: 0, created_at: '2026-01-01',
      lessons: [],
    }
    expect(m.lessons).toEqual([])
  })
})
