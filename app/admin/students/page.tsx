import { createClient } from '@/lib/supabase/server'
import { RevokeButton } from './RevokeButton'

export default async function StudentsPage() {
  const supabase = await createClient()
  const { data: students } = await supabase
    .from('profiles')
    .select('id, email, created_at, has_paid')
    .eq('has_paid', true)
    .order('created_at', { ascending: false })

  return (
    <div className="p-8 space-y-6">
      <h1 className="text-xl font-bold">Students ({(students ?? []).length})</h1>
      <div className="bg-white border rounded-lg overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="text-left px-4 py-3 font-medium text-muted-foreground">Email</th>
              <th className="text-left px-4 py-3 font-medium text-muted-foreground">Joined</th>
              <th className="px-4 py-3"></th>
            </tr>
          </thead>
          <tbody>
            {(students ?? []).map((s: any) => (
              <tr key={s.id} className="border-b last:border-0">
                <td className="px-4 py-3">{s.email ?? s.id.slice(0, 8)}</td>
                <td className="px-4 py-3 text-muted-foreground">
                  {new Date(s.created_at).toLocaleDateString()}
                </td>
                <td className="px-4 py-3 text-right">
                  <RevokeButton userId={s.id} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {(students ?? []).length === 0 && (
          <p className="px-4 py-6 text-sm text-muted-foreground text-center">No paid students yet.</p>
        )}
      </div>
    </div>
  )
}
