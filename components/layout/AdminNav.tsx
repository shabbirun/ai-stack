'use client'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import { LayoutDashboard, BookOpen, MessageSquarePlus, Users } from 'lucide-react'

const links = [
  { href: '/admin', label: 'Overview', icon: LayoutDashboard },
  { href: '/admin/modules', label: 'Modules', icon: BookOpen },
  { href: '/admin/requests', label: 'Requests', icon: MessageSquarePlus },
  { href: '/admin/students', label: 'Students', icon: Users },
]

export function AdminNav() {
  const pathname = usePathname()
  return (
    <aside className="w-56 shrink-0 border-r bg-white h-screen sticky top-0 p-4 space-y-1">
      <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider px-2 mb-3">Admin</p>
      {links.map(({ href, label, icon: Icon }) => (
        <Link key={href} href={href}
          className={cn(
            'flex items-center gap-2 px-2 py-1.5 text-sm rounded-md transition-colors',
            pathname === href || (href !== '/admin' && pathname.startsWith(href))
              ? 'bg-gray-100 font-medium text-foreground'
              : 'text-muted-foreground hover:text-foreground hover:bg-gray-50'
          )}>
          <Icon className="w-4 h-4" />
          {label}
        </Link>
      ))}
      <div className="pt-4 border-t mt-4">
        <Link href="/dashboard"
          className="flex items-center gap-2 px-2 py-1.5 text-sm text-muted-foreground hover:text-foreground rounded-md hover:bg-gray-50 transition-colors">
          ← Back to course
        </Link>
      </div>
    </aside>
  )
}
