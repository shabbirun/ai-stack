import { createClient } from '@/lib/supabase/server'

export default async function AdminRequestsPage() {
  const supabase = await createClient()
  const { data: requests } = await supabase
    .from('lesson_requests')
    .select('*, profiles(email)')
    .order('created_at', { ascending: false })

  return (
    <div className="p-8 space-y-6">
      <h1 className="text-xl font-bold">Lesson Requests ({(requests ?? []).length})</h1>
      <div className="bg-white border rounded-lg overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="text-left px-4 py-3 font-medium text-muted-foreground">Topic</th>
              <th className="text-left px-4 py-3 font-medium text-muted-foreground">Details</th>
              <th className="text-left px-4 py-3 font-medium text-muted-foreground">Student</th>
              <th className="text-left px-4 py-3 font-medium text-muted-foreground">Date</th>
            </tr>
          </thead>
          <tbody>
            {(requests ?? []).map((r: any) => (
              <tr key={r.id} className="border-b last:border-0">
                <td className="px-4 py-3 font-medium">{r.title}</td>
                <td className="px-4 py-3 text-muted-foreground max-w-xs">
                  <span className="line-clamp-2">{r.description}</span>
                </td>
                <td className="px-4 py-3 text-muted-foreground">{r.profiles?.email ?? '—'}</td>
                <td className="px-4 py-3 text-muted-foreground whitespace-nowrap">
                  {new Date(r.created_at).toLocaleDateString()}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {(requests ?? []).length === 0 && (
          <p className="px-4 py-6 text-sm text-muted-foreground text-center">No requests yet.</p>
        )}
      </div>
    </div>
  )
}
