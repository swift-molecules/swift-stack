public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Index
public import Memory_Allocator_Primitive
public import Memory_Heap
public import Storage_Contiguous
public import Storage_Primitive
public import Store_Protocol

extension __Stack where S: Store.Direct, S: ~Copyable {

    public typealias Bounded = __Stack<S.Bounded>
}

extension __Stack where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(capacity: Index<E>.Count)
    where S == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Bounded {
        self.init(column: S(minimumCapacity: capacity))
    }

    @inlinable
    public mutating func push<E: ~Copyable>(_ element: consuming E) throws(Error)
    where S == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Bounded {
        guard column.append(element) == nil else {
            throw .full
        }
    }
}
