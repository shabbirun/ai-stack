import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { CheckCircle2, Circle } from 'lucide-react'

export default async function DashboardPage() {
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

  const completedSet = new Set((progress ?? []).map((p: any) => p.lesson_id))

  return (
    <div className="max-w-3xl mx-auto p-8 space-y-6">
      <h1 className="text-2xl font-bold">Course Content</h1>
      {(modules ?? []).map((mod: any) => {
        const lessons = mod.lessons ?? []
        const completed = lessons.filter((l: any) => completedSet.has(l.id)).length
        return (
          <Card key={mod.id}>
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle className="text-base">{mod.title}</CardTitle>
                <span className="text-sm text-muted-foreground">{completed}/{lessons.length}</span>
              </div>
            </CardHeader>
            <CardContent>
              <ul className="space-y-1">
                {lessons.map((lesson: any) => (
                  <li key={lesson.id}>
                    <Link
                      href={`/lesson/${lesson.id}`}
                      className="flex items-center gap-2 py-1 text-sm hover:text-primary transition-colors"
                    >
                      {completedSet.has(lesson.id)
                        ? <CheckCircle2 className="w-4 h-4 text-green-500" />
                        : <Circle className="w-4 h-4 text-muted-foreground" />
                      }
                      {lesson.title}
                    </Link>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>
        )
      })}
    </div>
  )
}
