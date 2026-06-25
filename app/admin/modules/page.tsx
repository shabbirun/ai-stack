import { createClient } from '@/lib/supabase/server'
import { ModuleManager } from './ModuleManager'

export default async function ModulesPage() {
  const supabase = await createClient()
  const { data: modules } = await supabase
    .from('modules')
    .select('id, title, "order", lessons(count)')
    .order('order')

  return (
    <div className="p-8 max-w-2xl space-y-6">
      <h1 className="text-xl font-bold">Modules</h1>
      <ModuleManager initialModules={modules ?? []} />
    </div>
  )
}
