import type { LessonRequest } from '@/lib/types'

type Props = { requests: LessonRequest[] }

export function RequestList({ requests }: Props) {
  if (requests.length === 0) {
    return <p className="text-sm text-muted-foreground">No requests yet. Be the first!</p>
  }

  return (
    <div className="space-y-3">
      {requests.map(r => (
        <div key={r.id} className="p-4 border rounded-lg bg-white space-y-1">
          <p className="font-medium text-sm">{r.title}</p>
          <p className="text-sm text-muted-foreground">{r.description}</p>
          <p className="text-xs text-muted-foreground">
            {new Date(r.created_at).toLocaleDateString()}
          </p>
        </div>
      ))}
    </div>
  )
}
