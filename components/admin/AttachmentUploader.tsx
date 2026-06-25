'use client'
import { useRef, useState } from 'react'
import { Button } from '@/components/ui/button'
import { createClient } from '@/lib/supabase/client'
import { Trash2, Upload } from 'lucide-react'
import type { LessonAttachment } from '@/lib/types'

type Props = {
  lessonId: string
  existing: LessonAttachment[]
  onUpdate: () => void
}

export function AttachmentUploader({ lessonId, existing, onUpdate }: Props) {
  const inputRef = useRef<HTMLInputElement>(null)
  const [uploading, setUploading] = useState(false)

  async function handleUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (!file) return
    setUploading(true)
    const supabase = createClient()
    const path = `${lessonId}/${Date.now()}-${file.name}`
    const { error } = await supabase.storage.from('attachments').upload(path, file)
    if (!error) {
      await supabase.from('lesson_attachments').insert({
        lesson_id: lessonId,
        file_name: file.name,
        storage_path: path,
      })
      onUpdate()
    }
    setUploading(false)
    if (inputRef.current) inputRef.current.value = ''
  }

  async function handleDelete(attachment: LessonAttachment) {
    const supabase = createClient()
    await supabase.storage.from('attachments').remove([attachment.storage_path])
    await supabase.from('lesson_attachments').delete().eq('id', attachment.id)
    onUpdate()
  }

  return (
    <div className="space-y-2">
      <p className="text-sm font-medium">Attachments</p>
      {existing.map(a => (
        <div key={a.id} className="flex items-center justify-between text-sm border rounded px-3 py-1.5">
          <span className="truncate">{a.file_name}</span>
          <button
            type="button"
            onClick={() => handleDelete(a)}
            className="text-red-500 hover:text-red-600 ml-2 shrink-0"
          >
            <Trash2 className="w-3.5 h-3.5" />
          </button>
        </div>
      ))}
      <input ref={inputRef} type="file" className="hidden" onChange={handleUpload} />
      <Button
        type="button"
        variant="outline"
        className="gap-1.5"
        disabled={uploading}
        onClick={() => inputRef.current?.click()}
      >
        <Upload className="w-3.5 h-3.5" />
        {uploading ? 'Uploading...' : 'Upload file'}
      </Button>
    </div>
  )
}
