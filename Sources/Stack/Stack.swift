public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer
public import Cardinal
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Storage
public import Tagged

@_documentation(visibility: internal)
public protocol __StackColumnProtocol: Store.`Protocol`, ~Copyable {

    var count: Tagged<Element, Cardinal> { get }

    var isEmpty: Bool { get }
}

extension Buffer.Linear: __StackColumnProtocol
where S: Store.`Protocol`, S: ~Copyable {}

extension Buffer.Linear.Bounded: __StackColumnProtocol
where S: Store.`Protocol`, S: ~Copyable {}

@_documentation(visibility: public)
@frozen
public struct __Stack<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var column: S

    @inlinable
    public init(column: consuming S) { self.column = column }
}

extension __Stack where S: ~Copyable {

    @inlinable
    public consuming func take() -> S { column }
}

extension __Stack: Copyable where S: Copyable {}
extension __Stack: Sendable where S: Sendable & ~Copyable {}

extension __Stack where S: ~Copyable, S: __StackColumnProtocol {

    @inlinable
    public var count: Tagged<S.Element, Cardinal> { column.count }

    @inlinable
    public var isEmpty: Bool { column.isEmpty }

    @inlinable
    package func slot(_ k: Int) -> Index<S.Element> {
        Index(UInt(k))
    }

    @inlinable
    public var top: S.Element {

        _read { yield column[slot(Int(clamping: count.underlying.rawValue) - 1)] }
    }

    @inlinable
    public mutating func pop() -> S.Element? {
        let n = Int(clamping: count.underlying.rawValue)
        if n == 0 { return nil }
        return column.move(at: slot(n - 1))
    }
}

extension __Stack where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>
    ) where S == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear {
        self.init(column: S(minimumCapacity: minimumCapacity))
    }

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>()
    where S == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear {
        self.init(minimumCapacity: Tagged<E, Cardinal>(4 as UInt))
    }

    @inlinable
    public mutating func push<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ element: consuming E
    ) where S == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear {
        column.append(element)
    }
}
