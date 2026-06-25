type Props = { html: string }

export function LessonContent({ html }: Props) {
  return (
    <div
      className="prose prose-slate max-w-none"
      dangerouslySetInnerHTML={{ __html: html }}
    />
  )
}
