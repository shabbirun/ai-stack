'use client'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { CheckCircle2, Circle, ChevronDown, ChevronRight, BookOpen, MessageSquarePlus } from 'lucide-react'
import { cn } from '@/lib/utils'
import type { ModuleWithLessons } from '@/lib/types'
import { useState } from 'react'
import { LogoutButton } from './LogoutButton'

type Props = {
  modules: ModuleWithLessons[]
  completedLessonIds: string[]
}

export function Sidebar({ modules, completedLessonIds }: Props) {
  const pathname = usePathname()
  const completedSet = new Set(completedLessonIds)

  const totalLessons = modules.reduce((sum, m) => sum + m.lessons.length, 0)
  const totalCompleted = completedLessonIds.length
  const pct = totalLessons > 0 ? Math.round((totalCompleted / totalLessons) * 100) : 0

  return (
    <aside className="w-72 shrink-0 border-r bg-white h-screen sticky top-0 overflow-y-auto flex flex-col">
      <div className="p-4 border-b">
        <Link href="/dashboard" className="flex items-center gap-2 font-semibold text-sm">
          <BookOpen className="w-4 h-4" />
          Course
        </Link>
        <div className="mt-3">
          <div className="flex justify-between text-xs text-muted-foreground mb-1">
            <span>{totalCompleted}/{totalLessons} complete</span>
            <span>{pct}%</span>
          </div>
          <div className="h-1.5 bg-gray-100 rounded-full overflow-hidden">
            <div className="h-full bg-green-500 rounded-full transition-all"
              style={{ width: `${pct}%` }} />
          </div>
        </div>
      </div>

      <nav className="flex-1 p-2">
        {modules.map(mod => (
          <ModuleSection
            key={mod.id}
            module={mod}
            completedSet={completedSet}
            currentPath={pathname}
          />
        ))}
      </nav>

      <div className="p-4 border-t">
        <Link href="/requests"
          className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors">
          <MessageSquarePlus className="w-4 h-4" />
          Request a lesson
        </Link>
        <div className="mt-2">
          <LogoutButton />
        </div>
      </div>
    </aside>
  )
}

function ModuleSection({
  module, completedSet, currentPath
}: {
  module: ModuleWithLessons
  completedSet: Set<string>
  currentPath: string
}) {
  const completed = module.lessons.filter(l => completedSet.has(l.id)).length
  const [open, setOpen] = useState(true)

  return (
    <div className="mb-1">
      <button
        onClick={() => setOpen(o => !o)}
        className="w-full flex items-center justify-between px-2 py-1.5 text-sm font-medium hover:bg-gray-50 rounded-md"
      >
        <span className="truncate">{module.title}</span>
        <div className="flex items-center gap-1 text-xs text-muted-foreground shrink-0 ml-2">
          <span>{completed}/{module.lessons.length}</span>
          {open ? <ChevronDown className="w-3 h-3" /> : <ChevronRight className="w-3 h-3" />}
        </div>
      </button>

      {open && (
        <ul className="ml-2">
          {module.lessons.map(lesson => {
            const done = completedSet.has(lesson.id)
            const active = currentPath === `/lesson/${lesson.id}`
            return (
              <li key={lesson.id}>
                <Link
                  href={`/lesson/${lesson.id}`}
                  className={cn(
                    'flex items-center gap-2 px-2 py-1.5 text-sm rounded-md transition-colors',
                    active ? 'bg-gray-100 text-foreground font-medium' : 'text-muted-foreground hover:text-foreground hover:bg-gray-50'
                  )}
                >
                  {done
                    ? <CheckCircle2 className="w-3.5 h-3.5 text-green-500 shrink-0" />
                    : <Circle className="w-3.5 h-3.5 shrink-0" />
                  }
                  <span className="truncate">{lesson.title}</span>
                </Link>
              </li>
            )
          })}
        </ul>
      )}
    </div>
  )
}
