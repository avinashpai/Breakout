import Raylib

extension Vector2: @retroactive Numeric {
    public typealias Magnitude = Float
    public var magnitude: Magnitude {
        abs(sqrt(self.x * self.x + self.y * self.y))
    }

    public static var zero: Vector2 { .init(x: 0, y: 0) }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    public static func * (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func += (lhs: inout Self, rhs: Self) {
        lhs = .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public init?<T>(exactly source: T) where T: BinaryInteger {
        self = Vector2(x: Float(source), y: Float(source))
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self = Vector2(x: Float(value), y: Float(value))
    }
}
