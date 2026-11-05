# swift-stack

Use this package when your task needs last-in-first-out storage, including for `~Copyable` elements: push, read the top, pop. Start from `Stack<E>`, which grows without limit, or `Stack<E>.Bounded` when the number of elements must never exceed a capacity fixed at creation. If you need indexed access, use swift-array; if you need first-in-first-out order, use swift-queue-linked.

## Laws

- `pop()` returns elements in the reverse of the order they were pushed, across any interleaving of pushes and pops and across growth of the storage. On an empty stack it returns `nil` and leaves the stack empty.
- `top` is the most recently pushed element that has not been popped. Reading it on an empty stack is a programming error and traps, because the slot `count - 1` is converted to `UInt`.
- `Stack<E>.push` never fails.
- `Stack<E>.Bounded` holds exactly the `capacity` it was created with, no more. A push onto a full stack throws `.full`, leaves count and top unchanged, and destroys the rejected element.
- `take()` consumes the stack and returns its storage with every element in place; `init(column:)` on that storage gives back a stack with the same contents and order.
