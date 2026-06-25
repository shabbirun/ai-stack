'use client'
import {
  DndContext, closestCenter, PointerSensor, useSensor, useSensors,
  type DragEndEvent
} from '@dnd-kit/core'
import {
  SortableContext, verticalListSortingStrategy, useSortable, arrayMove
} from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { GripVertical } from 'lucide-react'
import { useState } from 'react'

type Item = { id: string }

type Props<T extends Item> = {
  items: T[]
  onReorder: (ids: string[]) => Promise<void>
  renderItem: (item: T) => React.ReactNode
}

export function DraggableList<T extends Item>({ items, onReorder, renderItem }: Props<T>) {
  const [list, setList] = useState(items)
  const sensors = useSensors(useSensor(PointerSensor))

  async function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event
    if (!over || active.id === over.id) return
    const oldIndex = list.findIndex(i => i.id === active.id)
    const newIndex = list.findIndex(i => i.id === over.id)
    const reordered = arrayMove(list, oldIndex, newIndex)
    setList(reordered)
    await onReorder(reordered.map(i => i.id))
  }

  return (
    <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
      <SortableContext items={list.map(i => i.id)} strategy={verticalListSortingStrategy}>
        <div className="space-y-2">
          {list.map(item => (
            <SortableRow key={item.id} id={item.id}>
              {renderItem(item)}
            </SortableRow>
          ))}
        </div>
      </SortableContext>
    </DndContext>
  )
}

function SortableRow({ id, children }: { id: string; children: React.ReactNode }) {
  const { attributes, listeners, setNodeRef, transform, transition } = useSortable({ id })
  return (
    <div ref={setNodeRef}
      style={{ transform: CSS.Transform.toString(transform), transition }}
      className="flex items-center gap-2 bg-white border rounded-lg p-3">
      <button {...attributes} {...listeners}
        className="cursor-grab text-muted-foreground hover:text-foreground touch-none">
        <GripVertical className="w-4 h-4" />
      </button>
      <div className="flex-1">{children}</div>
    </div>
  )
}
