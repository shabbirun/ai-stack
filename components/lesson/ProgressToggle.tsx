'use client'
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { CheckCircle2, Circle } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { createClient } from '@/lib/supabase/client'

type Props = { lessonId: string; userId: string; initialCompleted: boolean }

export function ProgressToggle({ lessonId, userId, initialCompleted }: Props) {
  const [completed, setCompleted] = useState(initialCompleted)
  const [loading, setLoading] = useState(false)
  const router = useRouter()

  async function toggle() {
    setLoading(true)
    const supabase = createClient()

    if (completed) {
      await supabase
        .from('lesson_progress')
        .delete()
        .eq('lesson_id', lessonId)
        .eq('user_id', userId)
    } else {
      await supabase
        .from('lesson_progress')
        .upsert({ lesson_id: lessonId, user_id: userId })
    }

    setCompleted(c => !c)
    setLoading(false)
    router.refresh()
  }

  return (
    <Button
      variant={completed ? 'default' : 'outline'}
      onClick={toggle}
      disabled={loading}
      className="gap-1.5"
    >
      {completed
        ? <><CheckCircle2 className="w-4 h-4" /> Completed</>
        : <><Circle className="w-4 h-4" /> Mark complete</>
      }
    </Button>
  )
}
