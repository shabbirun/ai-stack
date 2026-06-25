'use client'
import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Textarea } from '@/components/ui/textarea'
import { createClient } from '@/lib/supabase/client'

type Props = {
  lessonId: string
  userId: string
  parentId?: string
  onSuccess: () => void
  onCancel?: () => void
  placeholder?: string
}

export function CommentForm({ lessonId, userId, parentId, onSuccess, onCancel, placeholder }: Props) {
  const [content, setContent] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!content.trim()) return
    setLoading(true)
    const supabase = createClient()
    await supabase.from('comments').insert({
      lesson_id: lessonId,
      user_id: userId,
      parent_id: parentId ?? null,
      content: content.trim(),
    })
    setContent('')
    setLoading(false)
    onSuccess()
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-2">
      <Textarea
        value={content}
        onChange={e => setContent(e.target.value)}
        placeholder={placeholder ?? 'Write a comment...'}
        rows={3}
        className="resize-none"
      />
      <div className="flex gap-2 justify-end">
        {onCancel && (
          <Button type="button" variant="ghost" onClick={onCancel}>
            Cancel
          </Button>
        )}
        <Button type="submit" disabled={loading || !content.trim()}>
          {loading ? 'Posting...' : 'Post'}
        </Button>
      </div>
    </form>
  )
}
