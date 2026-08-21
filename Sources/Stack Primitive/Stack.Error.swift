extension __Stack where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case full
    }
}
