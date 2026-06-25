export type Profile = {
  id: string
  is_admin: boolean
  has_paid: boolean
  stripe_customer_id: string | null
  created_at: string
  email?: string
}

export type Module = {
  id: string
  title: string
  order: number
  created_at: string
}

export type Lesson = {
  id: string
  module_id: string
  title: string
  youtube_url: string | null
  content: string
  order: number
  created_at: string
}

export type LessonAttachment = {
  id: string
  lesson_id: string
  file_name: string
  storage_path: string
  created_at: string
}

export type LessonProgress = {
  id: string
  user_id: string
  lesson_id: string
  completed_at: string
}

export type Comment = {
  id: string
  lesson_id: string
  user_id: string
  parent_id: string | null
  content: string
  created_at: string
  author_email?: string
}

export type LessonRequest = {
  id: string
  user_id: string
  title: string
  description: string
  created_at: string
  author_email?: string
}

export type ModuleWithLessons = Module & {
  lessons: Lesson[]
}
