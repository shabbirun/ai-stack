import { notFound, redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { YouTubeEmbed } from '@/components/lesson/YouTubeEmbed'
import { LessonContent } from '@/components/lesson/LessonContent'
import { AttachmentList } from '@/components/lesson/AttachmentList'
import { ProgressToggle } from '@/components/lesson/ProgressToggle'
import { CommentSection } from '@/components/comments/CommentSection'
import { Separator } from '@/components/ui/separator'

export default async function LessonPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const [{ data: lesson }, { data: attachments }, { data: progress }] = await Promise.all([
    supabase.from('lessons').select('*').eq('id', id).single(),
    supabase.from('lesson_attachments').select('*').eq('lesson_id', id),
    supabase.from('lesson_progress').select('id').eq('lesson_id', id).eq('user_id', user.id).maybeSingle(),
  ])

  if (!lesson) notFound()

  return (
    <div className="max-w-3xl mx-auto p-8 space-y-8">
      <div className="space-y-2">
        <h1 className="text-2xl font-bold">{lesson.title}</h1>
        <ProgressToggle lessonId={id} userId={user.id} initialCompleted={!!progress} />
      </div>

      {lesson.youtube_url && <YouTubeEmbed url={lesson.youtube_url} />}

      {lesson.content && <LessonContent html={lesson.content} />}

      {attachments && attachments.length > 0 && (
        <>
          <Separator />
          <AttachmentList attachments={attachments} />
        </>
      )}

      <Separator />
      <CommentSection lessonId={id} userId={user.id} />
    </div>
  )
}
