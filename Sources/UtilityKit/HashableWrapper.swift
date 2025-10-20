import Foundation

public struct HashableWrapper<T: Hashable>: Hashable {
    public let value: T
    
    public init(value: T) {
        self.value = value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    public static func == (lhs: HashableWrapper<T>, rhs: HashableWrapper<T>) -> Bool {
        return lhs.value == rhs.value
    }
}
