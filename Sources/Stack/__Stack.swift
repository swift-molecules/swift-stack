import Buffer
public import Buffer_Linear_Bounded_Primitive
import Buffer_Linear_Primitive
import Cardinal
import Index
import Memory_Allocator
import Memory_Allocator_Protocol
import Ordinal
import Storage
import Tagged

@_documentation(visibility: public)
@frozen
public struct __Stack<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var column: S

    @inlinable
    public init(column: consuming S) { self.column = column }
}
