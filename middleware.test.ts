import { describe, it, expect } from 'vitest'

function isCourseRoute(path: string) {
  return path.startsWith('/dashboard') ||
    path.startsWith('/lesson') ||
    path.startsWith('/requests')
}

function isAdminRoute(path: string) {
  return path.startsWith('/admin')
}

describe('middleware route matching', () => {
  it('identifies course routes', () => {
    expect(isCourseRoute('/dashboard')).toBe(true)
    expect(isCourseRoute('/lesson/abc')).toBe(true)
    expect(isCourseRoute('/requests')).toBe(true)
    expect(isCourseRoute('/login')).toBe(false)
    expect(isCourseRoute('/pay')).toBe(false)
    expect(isCourseRoute('/')).toBe(false)
  })

  it('identifies admin routes', () => {
    expect(isAdminRoute('/admin')).toBe(true)
    expect(isAdminRoute('/admin/modules')).toBe(true)
    expect(isAdminRoute('/dashboard')).toBe(false)
    expect(isAdminRoute('/login')).toBe(false)
  })

  it('course and admin routes are mutually exclusive', () => {
    const path = '/admin'
    expect(isCourseRoute(path) && isAdminRoute(path)).toBe(false)
  })
})
