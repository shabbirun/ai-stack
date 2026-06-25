'use client'
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { DraggableList } from '@/components/admin/DraggableList'
import { createClient } from '@/lib/supabase/client'
import { Pencil, Trash2, ChevronRight } from 'lucide-react'

type ModuleRow = {
  id: string
  title: string
  order: number
  lessons: { count: number }[]
}

export function ModuleManager({ initialModules }: { initialModules: ModuleRow[] }) {
  const [creating, setCreating] = useState(false)
  const [newTitle, setNewTitle] = useState('')
  const [editId, setEditId] = useState<string | null>(null)
  const [editTitle, setEditTitle] = useState('')
  const router = useRouter()

  async function handleCreate(e: React.FormEvent) {
    e.preventDefault()
    if (!newTitle.trim()) return
    const supabase = createClient()
    await supabase.from('modules').insert({
      title: newTitle.trim(),
      order: initialModules.length,
    })
    setNewTitle('')
    setCreating(false)
    router.refresh()
  }

  async function handleRename(id: string) {
    if (!editTitle.trim()) return
    const supabase = createClient()
    await supabase.from('modules').update({ title: editTitle.trim() }).eq('id', id)
    setEditId(null)
    router.refresh()
  }

  async function handleDelete(id: string, lessonCount: number) {
    if (lessonCount > 0) {
      alert('Remove all lessons from this module before deleting it.')
      return
    }
    if (!confirm('Delete this module?')) return
    const supabase = createClient()
    await supabase.from('modules').delete().eq('id', id)
    router.refresh()
  }

  async function handleReorder(ids: string[]) {
    const supabase = createClient()
    await Promise.all(ids.map((id, index) =>
      supabase.from('modules').update({ order: index }).eq('id', id)
    ))
  }

  function getLessonCount(mod: ModuleRow): number {
    if (Array.isArray(mod.lessons) && mod.lessons.length > 0) {
      const first = mod.lessons[0]
      if (typeof first === 'object' && first !== null && 'count' in first) {
        return (first as { count: number }).count
      }
    }
    return 0
  }

  return (
    <div className="space-y-4">
      <DraggableList
        items={initialModules}
        onReorder={handleReorder}
        renderItem={(mod) => {
          const count = getLessonCount(mod)
          return (
            <div className="flex items-center gap-2 w-full">
              {editId === mod.id ? (
                <form
                  onSubmit={e => { e.preventDefault(); handleRename(mod.id) }}
                  className="flex gap-2 flex-1"
                >
                  <Input
                    value={editTitle}
                    onChange={e => setEditTitle(e.target.value)}
                    autoFocus
                    className="h-7"
                  />
                  <Button type="submit" className="h-7 text-xs">Save</Button>
                  <Button
                    type="button"
                    variant="ghost"
                    className="h-7 text-xs"
                    onClick={() => setEditId(null)}
                  >
                    Cancel
                  </Button>
                </form>
              ) : (
                <>
                  <span className="flex-1 font-medium text-sm">{mod.title}</span>
                  <span className="text-xs text-muted-foreground">{count} lessons</span>
                  <Button
                    variant="ghost"
                    className="h-7 w-7 p-0"
                    onClick={() => { setEditId(mod.id); setEditTitle(mod.title) }}
                  >
                    <Pencil className="w-3.5 h-3.5" />
                  </Button>
                  <Button
                    variant="ghost"
                    className="h-7 w-7 p-0 text-red-500 hover:text-red-600"
                    onClick={() => handleDelete(mod.id, count)}
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                  </Button>
                  <Link
                    href={`/admin/modules/${mod.id}/lessons`}
                    className="flex items-center justify-center h-7 w-7 rounded-md hover:bg-gray-100 transition-colors"
                  >
                    <ChevronRight className="w-3.5 h-3.5" />
                  </Link>
                </>
              )}
            </div>
          )
        }}
      />

      {creating ? (
        <form onSubmit={handleCreate} className="flex gap-2">
          <Input
            value={newTitle}
            onChange={e => setNewTitle(e.target.value)}
            placeholder="Module title"
            autoFocus
          />
          <Button type="submit">Add</Button>
          <Button type="button" variant="ghost" onClick={() => setCreating(false)}>Cancel</Button>
        </form>
      ) : (
        <Button variant="outline" onClick={() => setCreating(true)}>+ Add Module</Button>
      )}
    </div>
  )
}
