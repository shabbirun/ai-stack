import { createClient } from '@/lib/supabase/server'
import { CommentClientSection } from './CommentClientSection'
import type { Comment } from '@/lib/types'

type Props = { lessonId: string; userId: string }

export async function CommentSection({ lessonId, userId }: Props) {
  const supabase = await createClient()

  const { data: commentsRaw } = await supabase
    .from('comments')
    .select('*')
    .eq('lesson_id', lessonId)
    .order('created_at', { ascending: true })

  const comments: Comment[] = commentsRaw ?? []

  const [{ data: profile }, { data: profileEmails }] = await Promise.all([
    supabase.from('profiles').select('is_admin').eq('id', userId).single(),
    comments.length > 0
      ? supabase.from('profiles').select('id, email').in('id', [...new Set(comments.map(c => c.user_id))])
      : Promise.resolve({ data: [] }),
  ])

  const emailMap: Record<string, string> = {}
  ;(profileEmails ?? []).forEach((p: { id: string; email: string | null }) => {
    if (p.email) emailMap[p.id] = p.email
  })

  const enriched: Comment[] = comments.map(c => ({
    ...c,
    author_email: emailMap[c.user_id] ?? undefined,
  }))

  const topLevel = enriched.filter(c => !c.parent_id)
  const replies = enriched.filter(c => !!c.parent_id)

  return (
    <div className="space-y-6">
      <h2 className="font-semibold">Comments ({topLevel.length})</h2>
      <CommentClientSection
        lessonId={lessonId}
        userId={userId}
        isAdmin={profile?.is_admin ?? false}
        topLevel={topLevel}
        replies={replies}
      />
    </div>
  )
}
