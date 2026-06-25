import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { RequestForm } from '@/components/requests/RequestForm'
import { RequestList } from '@/components/requests/RequestList'

export default async function RequestsPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: requests } = await supabase
    .from('lesson_requests')
    .select('*')
    .order('created_at', { ascending: false })

  return (
    <div className="max-w-2xl mx-auto p-8 space-y-8">
      <RequestForm userId={user.id} />
      <div className="space-y-3">
        <h2 className="font-semibold">All Requests ({(requests ?? []).length})</h2>
        <RequestList requests={requests ?? []} />
      </div>
    </div>
  )
}
