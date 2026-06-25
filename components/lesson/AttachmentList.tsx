'use client'
import { Download } from 'lucide-react'
import { createClient } from '@/lib/supabase/client'
import type { LessonAttachment } from '@/lib/types'

type Props = { attachments: LessonAttachment[] }

export function AttachmentList({ attachments }: Props) {
  if (attachments.length === 0) return null

  async function handleDownload(attachment: LessonAttachment) {
    const supabase = createClient()
    const { data } = await supabase.storage
      .from('attachments')
      .createSignedUrl(attachment.storage_path, 60)
    if (data?.signedUrl) window.open(data.signedUrl, '_blank')
  }

  return (
    <div>
      <h3 className="font-semibold text-sm mb-2">Attachments</h3>
      <ul className="space-y-1">
        {attachments.map(a => (
          <li key={a.id}>
            <button
              onClick={() => handleDownload(a)}
              className="flex items-center gap-2 text-sm text-primary hover:underline"
            >
              <Download className="w-3.5 h-3.5" />
              {a.file_name}
            </button>
          </li>
        ))}
      </ul>
    </div>
  )
}
