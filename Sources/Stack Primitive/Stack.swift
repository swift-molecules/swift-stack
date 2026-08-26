public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Buffer_Protocol
public import Index
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol
public import Storage_Contiguous
public import Storage_Primitive
public import Store_Protocol

@_documentation(visibility: public)
@frozen
public struct __Stack<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var column: S

    @inlinable
    public init(column: consuming S) { self.column = column }
}

extension __Stack {

    @inlinable
    public consuming func take() -> S { column }
}

extension __Stack: Copyable where S: Copyable {}
extension __Stack: Sendable where S: Sendable & ~Copyable {}

extension __Stack where S: ~Copyable, S: Store.`Protocol` & Buffer.`Protocol` {

    @inlinable
    public var count: Index<S.Element>.Count { column.count }

    @inlinable
    public var isEmpty: Bool { column.isEmpty }

    @inlinable
    package func slot(_ k: Int) -> Index<S.Element> {
        Index(Ordinal(UInt(k)))
    }

    @inlinable
    public var top: S.Element {

        _read { yield column[slot(Int(clamping: count) - 1)] }
    }

    @inlinable
    public mutating func pop() -> S.Element? {
        let n = Int(clamping: count)
        if n == 0 { return nil }
        column.unshare()
        return column.move(at: slot(n - 1))
    }
}

extension __Stack where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Index<E>.Count = Index<E>.Count(4)
    ) where S == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear {
        self.init(column: S(minimumCapacity: minimumCapacity))
    }

    @inlinable
    public mutating func push<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ element: consuming E
    ) where S == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear {
        column.append(element)
    }
}
