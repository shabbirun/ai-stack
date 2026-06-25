'use client'
import { useRouter } from 'next/navigation'
import { CommentForm } from './CommentForm'
import { CommentItem } from './CommentItem'
import type { Comment } from '@/lib/types'

type Props = {
  lessonId: string
  userId: string
  isAdmin: boolean
  topLevel: Comment[]
  replies: Comment[]
}

export function CommentClientSection({ lessonId, userId, isAdmin, topLevel, replies }: Props) {
  const router = useRouter()

  return (
    <div className="space-y-6">
      <CommentForm
        lessonId={lessonId}
        userId={userId}
        onSuccess={() => router.refresh()}
      />
      <div className="space-y-6">
        {topLevel.map(comment => (
          <CommentItem
            key={comment.id}
            comment={comment}
            replies={replies.filter(r => r.parent_id === comment.id)}
            lessonId={lessonId}
            currentUserId={userId}
            isAdmin={isAdmin}
          />
        ))}
      </div>
    </div>
  )
}
