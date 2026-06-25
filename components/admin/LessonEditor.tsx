'use client'
import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'
import Underline from '@tiptap/extension-underline'
import Link from '@tiptap/extension-link'
import Image from '@tiptap/extension-image'
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { createClient } from '@/lib/supabase/client'
import { AttachmentUploader } from './AttachmentUploader'
import type { Lesson, LessonAttachment } from '@/lib/types'
import { Bold, Italic, Underline as UnderlineIcon, List, ListOrdered, Code } from 'lucide-react'

type Props = {
  moduleId: string
  lesson?: Lesson & { lesson_attachments: LessonAttachment[] }
  order?: number
  onClose: () => void
}

export function LessonEditor({ moduleId, lesson, order, onClose }: Props) {
  const [title, setTitle] = useState(lesson?.title ?? '')
  const [youtubeUrl, setYoutubeUrl] = useState(lesson?.youtube_url ?? '')
  const [saving, setSaving] = useState(false)
  const [savedLessonId, setSavedLessonId] = useState<string | null>(lesson?.id ?? null)
  const [attachments, setAttachments] = useState<LessonAttachment[]>(lesson?.lesson_attachments ?? [])
  const router = useRouter()

  const editor = useEditor({
    extensions: [StarterKit, Underline, Link, Image.configure({})],
    content: lesson?.content ?? '',
  })

  async function refreshAttachments(id: string) {
    const supabase = createClient()
    const { data } = await supabase.from('lesson_attachments').select('*').eq('lesson_id', id)
    setAttachments(data ?? [])
  }

  async function handleSave() {
    if (!title.trim()) return
    setSaving(true)
    const supabase = createClient()
    const content = editor?.getHTML() ?? ''

    if (savedLessonId) {
      await supabase.from('lessons').update({
        title: title.trim(),
        youtube_url: youtubeUrl.trim() || null,
        content,
      }).eq('id', savedLessonId)
    } else {
      const { data } = await supabase.from('lessons').insert({
        module_id: moduleId,
        title: title.trim(),
        youtube_url: youtubeUrl.trim() || null,
        content,
        order: order ?? 0,
      }).select().single()
      if (data) setSavedLessonId(data.id)
    }
    setSaving(false)
    router.refresh()
  }

  if (!editor) return null

  return (
    <div className="border rounded-lg p-6 bg-white space-y-4">
      <div className="space-y-1">
        <Label htmlFor="lesson-title">Title</Label>
        <Input id="lesson-title" value={title} onChange={e => setTitle(e.target.value)}
          placeholder="Lesson title" />
      </div>

      <div className="space-y-1">
        <Label htmlFor="yt-url">YouTube URL (optional)</Label>
        <Input id="yt-url" value={youtubeUrl} onChange={e => setYoutubeUrl(e.target.value)}
          placeholder="https://www.youtube.com/watch?v=..." />
      </div>

      <div className="space-y-1">
        <Label>Content</Label>
        <div className="border rounded-md overflow-hidden">
          <div className="flex gap-1 p-2 border-b bg-gray-50 flex-wrap">
            {[
              { action: () => editor.chain().focus().toggleBold().run(), icon: Bold, label: 'Bold' },
              { action: () => editor.chain().focus().toggleItalic().run(), icon: Italic, label: 'Italic' },
              // eslint-disable-next-line @typescript-eslint/no-explicit-any
              { action: () => (editor.chain().focus() as any).toggleUnderline().run(), icon: UnderlineIcon, label: 'Underline' },
              { action: () => editor.chain().focus().toggleBulletList().run(), icon: List, label: 'Bullet list' },
              { action: () => editor.chain().focus().toggleOrderedList().run(), icon: ListOrdered, label: 'Numbered list' },
              { action: () => editor.chain().focus().toggleCode().run(), icon: Code, label: 'Code' },
            ].map(({ action, icon: Icon, label }) => (
              <button key={label} type="button" onClick={action}
                title={label}
                className="p-1.5 rounded hover:bg-gray-200 text-sm transition-colors">
                <Icon className="w-3.5 h-3.5" />
              </button>
            ))}
          </div>
          <EditorContent editor={editor}
            className="prose prose-sm max-w-none p-3 min-h-[200px] focus:outline-none [&_.ProseMirror]:outline-none" />
        </div>
      </div>

      {savedLessonId ? (
        <AttachmentUploader
          lessonId={savedLessonId}
          existing={attachments}
          onUpdate={() => refreshAttachments(savedLessonId)}
        />
      ) : (
        <p className="text-xs text-muted-foreground">Save the lesson first to add attachments.</p>
      )}

      <div className="flex gap-2 justify-end">
        <Button variant="ghost" type="button" onClick={onClose}>Cancel</Button>
        <Button type="button" onClick={handleSave} disabled={saving || !title.trim()}>
          {saving ? 'Saving...' : 'Save lesson'}
        </Button>
      </div>
    </div>
  )
}
