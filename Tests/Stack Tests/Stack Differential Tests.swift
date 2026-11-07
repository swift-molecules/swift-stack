import Stack
import Testing

private struct SplitMix64: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { self.state = seed }
}

extension SplitMix64 {
    mutating func next() -> UInt64 {
        state = state &+ 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

@Suite
struct `Stack Differential Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Stack Differential Tests`.Integration {
    @Test
    func `600 mixed ops: duplicates, interleaved push/pop, growth across reallocations`() {
        var rng = SplitMix64(seed: 0x5EED_1234_ABCD_0001)
        var stack = Stack<Int>()
        var oracle: [Int] = []

        let totalOps = 600
        var pushes = 0
        var interleavedPops = 0

        for _ in 0..<totalOps {

            let doPush = oracle.isEmpty || (Int(rng.next() % 100) < 58)
            if doPush {
                let value = Int(rng.next() % 40)
                stack.push(value)
                oracle.append(value)
                pushes += 1
            } else {
                let expected = oracle.removeLast()
                let got = stack.pop()
                #expect(got == expected)
                interleavedPops += 1
            }
        }

        var tail: [Int] = []
        while let next = stack.pop() { tail.append(next) }
        var oracleTail: [Int] = []
        while let next = oracle.popLast() { oracleTail.append(next) }
        #expect(tail == oracleTail)

        let overDrain = stack.pop()
        #expect(overDrain == nil)

        #expect(pushes + interleavedPops == totalOps)
        #expect(pushes >= 300)
        #expect(interleavedPops >= 100)
    }
}
