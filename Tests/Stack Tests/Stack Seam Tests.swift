import Buffer_Linear_Bounded_Primitive
import Buffer_Linear_Primitive
import Buffer_Primitive
import Buffer_Test_Support
import Index
import Memory_Allocator_Primitive
import Memory_Heap
import Stack
import Storage_Contiguous
import Storage_Primitive
import Testing

@Suite
struct `Stack Seam Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Stack Seam Tests`.Integration {
    @Test
    func `[DS-024] Seam.Ledger laws hold for the canonical Stack column`() {
        let violations = Seam.Ledger.violations(
            makeEmpty: {
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear(
                    minimumCapacity: Index<Int>.Count(4)
                )
            },
            element: { $0 }
        )
        #expect(violations.isEmpty, "\(violations)")
    }

    @Test
    func `[DS-024] Seam.Ledger laws hold for the Stack.Bounded column`() {
        let violations = Seam.Ledger.violations(
            makeEmpty: {
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Bounded(
                    minimumCapacity: Index<Int>.Count(64)
                )
            },
            element: { $0 }
        )
        #expect(violations.isEmpty, "\(violations)")
    }
}
