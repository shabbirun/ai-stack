// Placeholder — full implementation in Task 11
type Props = { lessonId: string; userId: string }

export async function CommentSection({ lessonId, userId }: Props) {
  return (
    <div className="space-y-4">
      <h2 className="font-semibold">Comments</h2>
      <p className="text-sm text-muted-foreground">Comments coming soon.</p>
    </div>
  )
}
