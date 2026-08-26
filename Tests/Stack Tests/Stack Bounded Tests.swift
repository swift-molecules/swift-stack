import Index
import Testing

@testable import Stack

@Suite
struct `Stack.Bounded Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Stack.Bounded Tests`.Unit {
    @Test
    func `push up to capacity, then push throws Error.full (rejected element destroyed)`() throws {
        var s = Stack<Int>.Bounded(capacity: Index<Int>.Count(3))
        try s.push(1)
        try s.push(2)
        try s.push(3)
        let count = s.count
        let t = s.top
        #expect(count == Index<Int>.Count(3))
        #expect(t == 3)

        var caught: Stack<Int>.Bounded.Error?
        do throws(Stack<Int>.Bounded.Error) {
            try s.push(4)
            Issue.record("expected Stack.Error.full on overflow")
        } catch {
            caught = error
        }
        let countAfter = s.count
        let topAfter = s.top
        #expect(caught == .full)
        #expect(countAfter == Index<Int>.Count(3))
        #expect(topAfter == 3)
    }

    @Test
    func `bounded pop yields LIFO order and drains to nil`() throws {
        var s = Stack<Int>.Bounded(capacity: Index<Int>.Count(4))
        try s.push(10)
        try s.push(20)
        try s.push(30)
        var drained: [Int] = []
        while let next = s.pop() { drained.append(next) }
        let empty = s.isEmpty
        let overDrain = s.pop()
        #expect(drained == [30, 20, 10])
        #expect(empty)
        #expect(overDrain == nil)
    }
}
