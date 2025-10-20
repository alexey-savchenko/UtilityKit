import Foundation

struct HashableWrapper<T: Hashable>: Hashable {
    let value: T

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func == (lhs: HashableWrapper<T>, rhs: HashableWrapper<T>) -> Bool {
        return lhs.value == rhs.value
    }
}
