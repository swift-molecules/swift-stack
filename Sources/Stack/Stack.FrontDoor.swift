public import Buffer_Linear_Primitive
public import Buffer
public import Memory_Allocator
public import Memory_Small
public import Storage

public typealias Stack<E: ~Copyable> =
    __Stack<Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear>
