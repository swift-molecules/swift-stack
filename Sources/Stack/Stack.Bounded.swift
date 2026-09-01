public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer
public import Cardinal
public import Memory_Allocator
public import Memory_Small
public import Storage
public import Tagged

extension __Stack where S: Store.Direct, S: ~Copyable {

    public typealias Bounded = __Stack<S.Bounded>
}

extension __Stack where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(capacity: Tagged<E, Cardinal>)
    where S == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear.Bounded {
        self.init(column: S(minimumCapacity: capacity))
    }

    @inlinable
    public mutating func push<E: ~Copyable>(_ element: consuming E) throws(Error)
    where S == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear.Bounded {
        guard column.append(element) == nil else {
            throw .full
        }
    }
}
