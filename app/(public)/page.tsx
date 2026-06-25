import Link from 'next/link'
import { buttonVariants } from '@/components/ui/button'
import { cn } from '@/lib/utils'

export default function LandingPage() {
  return (
    <div className="text-center space-y-6 max-w-lg">
      <h1 className="text-4xl font-bold tracking-tight">Learn at your own pace</h1>
      <p className="text-muted-foreground text-lg">
        Get lifetime access to all course content, lessons, and future updates.
      </p>
      <div className="flex gap-3 justify-center">
        <Link href="/signup" className={cn(buttonVariants({ size: 'lg' }))}>
          Get started
        </Link>
        <Link href="/login" className={cn(buttonVariants({ variant: 'outline', size: 'lg' }))}>
          Sign in
        </Link>
      </div>
    </div>
  )
}
