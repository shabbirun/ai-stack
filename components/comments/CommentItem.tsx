'use client'
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Trash2, MessageSquare } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { createClient } from '@/lib/supabase/client'
import { CommentForm } from './CommentForm'
import type { Comment } from '@/lib/types'

type Props = {
  comment: Comment
  replies: Comment[]
  lessonId: string
  currentUserId: string
  isAdmin: boolean
}

export function CommentItem({ comment, replies, lessonId, currentUserId, isAdmin }: Props) {
  const [showReply, setShowReply] = useState(false)
  const router = useRouter()

  async function handleDelete(id: string) {
    const supabase = createClient()
    await supabase.from('comments').delete().eq('id', id)
    router.refresh()
  }

  function canDelete(authorId: string) {
    return isAdmin || authorId === currentUserId
  }

  return (
    <div className="space-y-3">
      <div className="flex gap-3">
        <div className="w-7 h-7 rounded-full bg-gray-200 flex items-center justify-center text-xs font-medium shrink-0">
          {comment.author_email?.[0]?.toUpperCase() ?? '?'}
        </div>
        <div className="flex-1 space-y-1">
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium">{comment.author_email ?? 'Anonymous'}</span>
            <span className="text-xs text-muted-foreground">
              {new Date(comment.created_at).toLocaleDateString()}
            </span>
          </div>
          <p className="text-sm">{comment.content}</p>
          <div className="flex gap-2">
            <button
              className="flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground transition-colors"
              onClick={() => setShowReply(r => !r)}
            >
              <MessageSquare className="w-3 h-3" /> Reply
            </button>
            {canDelete(comment.user_id) && (
              <button
                className="flex items-center gap-1 text-xs text-red-500 hover:text-red-600 transition-colors"
                onClick={() => handleDelete(comment.id)}
              >
                <Trash2 className="w-3 h-3" />
              </button>
            )}
          </div>
          {showReply && (
            <CommentForm
              lessonId={lessonId}
              userId={currentUserId}
              parentId={comment.id}
              placeholder="Write a reply..."
              onSuccess={() => { setShowReply(false); router.refresh() }}
              onCancel={() => setShowReply(false)}
            />
          )}
        </div>
      </div>

      {replies.length > 0 && (
        <div className="ml-10 space-y-3 border-l-2 pl-4">
          {replies.map(reply => (
            <div key={reply.id} className="flex gap-3">
              <div className="w-6 h-6 rounded-full bg-gray-200 flex items-center justify-center text-xs font-medium shrink-0">
                {reply.author_email?.[0]?.toUpperCase() ?? '?'}
              </div>
              <div className="flex-1 space-y-1">
                <div className="flex items-center gap-2">
                  <span className="text-sm font-medium">{reply.author_email ?? 'Anonymous'}</span>
                  <span className="text-xs text-muted-foreground">
                    {new Date(reply.created_at).toLocaleDateString()}
                  </span>
                </div>
                <p className="text-sm">{reply.content}</p>
                {canDelete(reply.user_id) && (
                  <button
                    className="flex items-center gap-1 text-xs text-red-500 hover:text-red-600 transition-colors"
                    onClick={() => handleDelete(reply.id)}
                  >
                    <Trash2 className="w-3 h-3" />
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
