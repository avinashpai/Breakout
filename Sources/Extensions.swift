import Raylib

extension Vector2: @retroactive AdditiveArithmetic {
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
}
