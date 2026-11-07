import Cardinal
import Stack
import Storage
import Tagged
import Testing

@Suite
struct `Stack Seam Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Stack Seam Tests`.Integration {
    @Test
    func `canonical Stack column round-trips through the generic seam`() {
        var original = Stack<Int>()
        original.push(7)
        let column = original.take()
        var roundTripped = Stack<Int>(column: column)
        #expect(roundTripped.pop() == 7)
    }

    @Test
    func `bounded Stack column round-trips through the generic seam`() throws {
        var original = Stack<Int>.Bounded(capacity: Tagged<Int, Cardinal>(4 as UInt))
        try original.push(11)
        let column = original.take()
        var roundTripped = Stack<Int>.Bounded(column: column)
        #expect(roundTripped.pop() == 11)
    }
}
