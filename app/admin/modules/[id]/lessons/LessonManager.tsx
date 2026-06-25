'use client'
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { DraggableList } from '@/components/admin/DraggableList'
import { LessonEditor } from '@/components/admin/LessonEditor'
import { createClient } from '@/lib/supabase/client'
import { Pencil, Trash2 } from 'lucide-react'
import type { Lesson, LessonAttachment } from '@/lib/types'

type LessonRow = Lesson & { lesson_attachments: LessonAttachment[] }

export function LessonManager({ moduleId, initialLessons }: {
  moduleId: string
  initialLessons: LessonRow[]
}) {
  const [creating, setCreating] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const router = useRouter()

  async function handleDelete(id: string) {
    if (!confirm('Delete this lesson?')) return
    const supabase = createClient()
    await supabase.from('lessons').delete().eq('id', id)
    router.refresh()
  }

  async function handleReorder(ids: string[]) {
    const supabase = createClient()
    await Promise.all(ids.map((id, index) =>
      supabase.from('lessons').update({ order: index }).eq('id', id)
    ))
  }

  return (
    <div className="space-y-4">
      <DraggableList
        items={initialLessons}
        onReorder={handleReorder}
        renderItem={(lesson) => (
          <div className="flex flex-col gap-2 w-full">
            {editingId === lesson.id ? (
              <LessonEditor
                moduleId={moduleId}
                lesson={lesson}
                onClose={() => { setEditingId(null); router.refresh() }}
              />
            ) : (
              <div className="flex items-center gap-2">
                <span className="flex-1 text-sm font-medium">{lesson.title}</span>
                <Button
                  variant="ghost"
                  className="h-7 w-7 p-0"
                  onClick={() => setEditingId(lesson.id)}
                >
                  <Pencil className="w-3.5 h-3.5" />
                </Button>
                <Button
                  variant="ghost"
                  className="h-7 w-7 p-0 text-red-500 hover:text-red-600"
                  onClick={() => handleDelete(lesson.id)}
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </Button>
              </div>
            )}
          </div>
        )}
      />

      {creating ? (
        <LessonEditor
          moduleId={moduleId}
          order={initialLessons.length}
          onClose={() => { setCreating(false); router.refresh() }}
        />
      ) : (
        <Button variant="outline" onClick={() => setCreating(true)}>+ Add Lesson</Button>
      )}
    </div>
  )
}
