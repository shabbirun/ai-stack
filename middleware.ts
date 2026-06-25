// middleware.ts
import { NextResponse, type NextRequest } from 'next/server'
import { updateSession } from '@/lib/supabase/middleware'
import { createServerClient } from '@supabase/ssr'

export async function middleware(request: NextRequest) {
  const { supabaseResponse, user } = await updateSession(request)
  const path = request.nextUrl.pathname

  const isCourseRoute = path.startsWith('/dashboard') ||
    path.startsWith('/lesson') ||
    path.startsWith('/requests') ||
    path.startsWith('/profile')
  const isAdminRoute = path.startsWith('/admin')

  if (!isCourseRoute && !isAdminRoute) return supabaseResponse

  function redirectWithCookies(url: string) {
    const redirect = NextResponse.redirect(new URL(url, request.url))
    supabaseResponse.cookies.getAll().forEach(cookie => {
      redirect.cookies.set(cookie.name, cookie.value)
    })
    return redirect
  }

  if (!user) return redirectWithCookies('/login')

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => request.cookies.getAll(),
        setAll: () => {},
      },
    }
  )

  const { data: profile } = await supabase
    .from('profiles')
    .select('has_paid, is_admin')
    .eq('id', user.id)
    .single()

  if (isAdminRoute && !profile?.is_admin) return redirectWithCookies('/dashboard')
  if (isCourseRoute && !profile?.has_paid) return redirectWithCookies('/pay')

  return supabaseResponse
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|api).*)',
  ],
}
