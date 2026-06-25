import { createClient } from '@/lib/supabase/server'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

export default async function AdminDashboard() {
  const supabase = await createClient()

  const [
    { count: totalStudents },
    { count: paidStudents },
    { count: totalLessons },
    { data: recentRequests },
  ] = await Promise.all([
    supabase.from('profiles').select('*', { count: 'exact', head: true }),
    supabase.from('profiles').select('*', { count: 'exact', head: true }).eq('has_paid', true),
    supabase.from('lessons').select('*', { count: 'exact', head: true }),
    supabase.from('lesson_requests').select('title, created_at').order('created_at', { ascending: false }).limit(5),
  ])

  return (
    <div className="p-8 space-y-6">
      <h1 className="text-xl font-bold">Overview</h1>
      <div className="grid grid-cols-3 gap-4">
        {[
          { label: 'Total students', value: totalStudents ?? 0 },
          { label: 'Paid students', value: paidStudents ?? 0 },
          { label: 'Total lessons', value: totalLessons ?? 0 },
        ].map(({ label, value }) => (
          <Card key={label}>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">{label}</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-3xl font-bold">{value}</p>
            </CardContent>
          </Card>
        ))}
      </div>

      <div>
        <h2 className="font-semibold mb-3">Recent lesson requests</h2>
        {(recentRequests ?? []).length === 0
          ? <p className="text-sm text-muted-foreground">None yet.</p>
          : (
            <div className="space-y-2">
              {(recentRequests ?? []).map((r: any) => (
                <div key={r.id ?? r.created_at} className="p-3 bg-white border rounded-lg text-sm">
                  <p className="font-medium">{r.title}</p>
                  <p className="text-muted-foreground text-xs mt-0.5">
                    {new Date(r.created_at).toLocaleDateString()}
                  </p>
                </div>
              ))}
            </div>
          )
        }
      </div>
    </div>
  )
}
