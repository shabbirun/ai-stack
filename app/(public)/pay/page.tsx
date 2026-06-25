'use client'
import { useState, Suspense } from 'react'
import { useSearchParams } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

function PayContent() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const params = useSearchParams()
  const cancelled = params.get('payment') === 'cancelled'

  async function handleCheckout() {
    setLoading(true)
    setError('')
    try {
      const res = await fetch('/api/stripe/checkout', { method: 'POST' })
      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        setError(body.error ?? 'Something went wrong. Please try again.')
        return
      }
      const { url } = await res.json()
      if (!url) {
        setError('No checkout URL returned. Please try again.')
        return
      }
      window.location.href = url
    } catch {
      setError('Network error. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <Card className="w-full max-w-sm text-center">
      <CardHeader>
        <CardTitle>Get Lifetime Access</CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        {cancelled && (
          <p className="text-sm text-yellow-600">Payment cancelled. Try again when you're ready.</p>
        )}
        {error && <p className="text-sm text-red-500">{error}</p>}
        <div>
          <p className="text-4xl font-bold">$97</p>
          <p className="text-muted-foreground text-sm mt-1">one-time payment</p>
        </div>
        <ul className="text-sm text-left space-y-1 text-muted-foreground">
          <li>✓ All modules and lessons</li>
          <li>✓ Downloadable resources</li>
          <li>✓ Future content updates</li>
          <li>✓ Comment on lessons</li>
        </ul>
        <Button className="w-full" onClick={handleCheckout} disabled={loading}>
          {loading ? 'Redirecting...' : 'Buy now — $97'}
        </Button>
      </CardContent>
    </Card>
  )
}

export default function PayPage() {
  return (
    <Suspense>
      <PayContent />
    </Suspense>
  )
}
