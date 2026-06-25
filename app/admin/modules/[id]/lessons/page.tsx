import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import { LessonManager } from './LessonManager'

export default async function LessonsPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()

  const [{ data: mod }, { data: lessons }] = await Promise.all([
    supabase.from('modules').select('*').eq('id', id).single(),
    supabase.from('lessons').select('*, lesson_attachments(*)').eq('module_id', id).order('order'),
  ])

  if (!mod) notFound()

  return (
    <div className="p-8 max-w-2xl space-y-6">
      <div>
        <p className="text-sm text-muted-foreground">Module</p>
        <h1 className="text-xl font-bold">{mod.title}</h1>
      </div>
      <LessonManager moduleId={id} initialLessons={lessons ?? []} />
    </div>
  )
}
