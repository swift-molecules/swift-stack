import Index
import Testing

@testable import Stack

private struct Token: ~Copyable {
    let id: Int
    init(_ id: Int) { self.id = id }
}

@Suite
struct `Stack Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Stack Tests`.Unit {
    @Test
    func `empty stack reports isEmpty and count 0`() {
        let s = Stack<Int>()
        let empty = s.isEmpty
        let count = s.count
        #expect(empty)
        #expect(count == Index<Int>.Count(0))
    }

    @Test
    func `push then pop yields last-in-first-out order`() {
        var s = Stack<Int>()
        for value in [42, 3, 25, 7] { s.push(value) }
        let nonEmpty = !s.isEmpty
        let count = s.count
        let t = s.top
        #expect(nonEmpty)
        #expect(count == Index<Int>.Count(4))
        #expect(t == 7)

        var drained: [Int] = []
        while let next = s.pop() { drained.append(next) }
        let empty = s.isEmpty
        let overDrain = s.pop()
        #expect(drained == [7, 25, 3, 42])
        #expect(empty)
        #expect(overDrain == nil)
    }

    @Test
    func `top tracks the most-recently-pushed element`() {
        var s = Stack<Int>()
        s.push(9)
        let t0 = s.top
        #expect(t0 == 9)
        s.push(4)
        let t1 = s.top
        #expect(t1 == 4)
        s.push(8)
        let t2 = s.top
        #expect(t2 == 8)
        let popped = s.pop()
        let t3 = s.top
        #expect(popped == 8)
        #expect(t3 == 4)
    }

    @Test
    func `single-element stack: push, top, pop`() {
        var s = Stack<Int>()
        s.push(17)
        let count = s.count
        let t = s.top
        #expect(count == Index<Int>.Count(1))
        #expect(t == 17)
        let popped = s.pop()
        let empty = s.isEmpty
        #expect(popped == 17)
        #expect(empty)
        let overDrain = s.pop()
        #expect(overDrain == nil)
    }

    @Test
    func `~Copyable elements flow through push/pop/top`() {
        var s = Stack<Token>()
        s.push(Token(5))
        s.push(Token(1))
        s.push(Token(3))
        let peeked = s.top.id
        #expect(peeked == 3)

        var ids: [Int] = []
        while let token = s.pop() { ids.append(token.id) }
        let empty = s.isEmpty
        #expect(ids == [3, 1, 5])
        #expect(empty)
    }

    @Test
    func `growth past the initial capacity preserves LIFO order`() {
        var s = Stack<Int>(minimumCapacity: Index<Int>.Count(2))
        (1...64).forEach { s.push($0) }
        let count = s.count
        #expect(count == Index<Int>.Count(64))
        var expected = 64
        while let next = s.pop() {
            #expect(next == expected)
            expected -= 1
        }
    }
}
