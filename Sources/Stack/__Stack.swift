public import Buffer
public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Cardinal
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Ordinal
public import Storage
public import Tagged

@_documentation(visibility: public)
@frozen
public struct __Stack<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var column: S

    @inlinable
    public init(column: consuming S) { self.column = column }
}
