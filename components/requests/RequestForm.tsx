'use client'
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { createClient } from '@/lib/supabase/client'

type Props = { userId: string }

export function RequestForm({ userId }: Props) {
  const [title, setTitle] = useState('')
  const [description, setDescription] = useState('')
  const [loading, setLoading] = useState(false)
  const [success, setSuccess] = useState(false)
  const router = useRouter()

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    const supabase = createClient()
    await supabase.from('lesson_requests').insert({
      user_id: userId,
      title: title.trim(),
      description: description.trim(),
    })
    setTitle('')
    setDescription('')
    setLoading(false)
    setSuccess(true)
    router.refresh()
    setTimeout(() => setSuccess(false), 3000)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4 p-6 border rounded-lg bg-white">
      <h2 className="font-semibold">Request a Lesson</h2>
      {success && <p className="text-sm text-green-600">Request submitted!</p>}
      <div className="space-y-1">
        <Label htmlFor="req-title">Topic</Label>
        <Input id="req-title" value={title} onChange={e => setTitle(e.target.value)}
          placeholder="What do you want to learn?" required />
      </div>
      <div className="space-y-1">
        <Label htmlFor="req-desc">Details</Label>
        <Textarea id="req-desc" value={description} onChange={e => setDescription(e.target.value)}
          placeholder="Give more context..." rows={3} required />
      </div>
      <Button type="submit" disabled={loading}>
        {loading ? 'Submitting...' : 'Submit request'}
      </Button>
    </form>
  )
}
