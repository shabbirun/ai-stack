'use client'
import { useSearchParams } from 'next/navigation'
import { Suspense } from 'react'
import Link from 'next/link'
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { MailCheck } from 'lucide-react'

function ConfirmContent() {
  const params = useSearchParams()
  const email = params.get('email') ?? 'your email'

  return (
    <Card className="w-full max-w-sm text-center">
      <CardHeader>
        <div className="flex justify-center mb-2">
          <MailCheck className="w-10 h-10 text-green-500" />
        </div>
        <CardTitle>Check your email</CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-sm text-muted-foreground">
          We sent a confirmation link to <span className="font-medium text-foreground">{email}</span>.
          Click it to activate your account.
        </p>
      </CardContent>
      <CardFooter className="flex flex-col gap-2">
        <p className="text-xs text-muted-foreground">
          Already confirmed?{' '}
          <Link href="/login" className="underline">Sign in</Link>
        </p>
      </CardFooter>
    </Card>
  )
}

export default function SignupConfirmPage() {
  return (
    <Suspense>
      <ConfirmContent />
    </Suspense>
  )
}
