'use client'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { createClient } from '@/lib/supabase/client'

export function RevokeButton({ userId }: { userId: string }) {
  const router = useRouter()

  async function handleRevoke() {
    if (!confirm('Revoke access for this student?')) return
    const supabase = createClient()
    await supabase.from('profiles').update({ has_paid: false }).eq('id', userId)
    router.refresh()
  }

  return (
    <Button
      variant="ghost"
      className="text-red-500 hover:text-red-600 h-7 text-xs"
      onClick={handleRevoke}
    >
      Revoke
    </Button>
  )
}
