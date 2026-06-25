import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { Sidebar } from '@/components/layout/Sidebar'
import type { ModuleWithLessons } from '@/lib/types'

export default async function CourseLayout({ children }: { children: React.ReactNode }) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: modules } = await supabase
    .from('modules')
    .select('*, lessons(*)')
    .order('order')
    .order('order', { referencedTable: 'lessons' })

  const { data: progress } = await supabase
    .from('lesson_progress')
    .select('lesson_id')
    .eq('user_id', user.id)

  const modulesWithLessons: ModuleWithLessons[] = (modules ?? []).map((m: any) => ({
    ...m,
    lessons: m.lessons ?? [],
  }))

  const completedIds = (progress ?? []).map((p: any) => p.lesson_id)

  return (
    <div className="flex min-h-screen">
      <Sidebar modules={modulesWithLessons} completedLessonIds={completedIds} />
      <main className="flex-1 overflow-y-auto">
        {children}
      </main>
    </div>
  )
}
