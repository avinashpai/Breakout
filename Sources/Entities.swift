import Raylib

protocol Drawable {
    var alive: Bool { get set }
    func draw()
}

protocol Hittable: Drawable {}

protocol Moveable: Hittable {
    var pos: Vector2 { get set }
    var speed: Vector2 { get set }

    func updatePosition() -> Self
    func handleBounds() -> Self
}

struct Bar: Moveable {
    let color: Color
    var pos: Vector2
    var size: Vector2
    var speed: Vector2
    var alive = true

    func handleBounds() -> Bar {
        var pos = self.pos
        if self.pos.x <= 0 {
            pos.x = 0
        } else if self.pos.x >= (Float(GetScreenWidth()) - self.size.x) {
            pos.x = Float(GetScreenWidth()) - self.size.x
        }
        return .init(color: self.color, pos: pos, size: self.size, speed: self.speed)
    }

    func updatePosition() -> Bar {
        var speed = self.speed
        if IsKeyDown(Int32(KEY_D.rawValue)) {
            speed.x = 8
        } else if IsKeyDown(Int32(KEY_A.rawValue)) {
            speed.x = -8
        } else {
            speed.x = 0
        }
        return .init(
            color: self.color,
            pos: self.pos + speed,
            size: self.size,
            speed: self.speed
        )
    }

    func draw() {
        DrawRectangleV(self.pos, self.size, self.color)
        DrawRectangleLinesEx(
            .init(x: self.pos.x, y: self.pos.y, width: self.size.x, height: self.size.y), 0.5,
            SKYBLUE)
    }
}

struct Block: Hittable {
    var color: Color
    var pos: Vector2
    var alive = true
    static let size = Vector2(x: 80, y: 20)

    func draw() {
        DrawRectangleV(self.pos, Block.size, self.color)
        DrawRectangleLinesEx(
            .init(x: self.pos.x, y: self.pos.y, width: Block.size.x, height: Block.size.y),
            0.5,
            BLACK)
    }
}

struct Ball: Moveable {
    let color: Color
    let radius: Float
    var pos: Vector2
    var speed: Vector2
    var alive = true

    func updatePosition() -> Ball {
        .init(color: self.color, radius: self.radius, pos: self.pos + self.speed, speed: self.speed)
    }

    func handleBounds() -> Ball {
        var direction = Vector2(x: 1, y: 1)

        if self.pos.x >= (Float(GetScreenWidth()) - self.radius) || self.pos.x <= self.radius {
            direction.x = -1
        }

        if self.pos.y >= (Float(GetScreenHeight()) - self.radius) || self.pos.y <= self.radius {
            direction.y = -1
        }

        return .init(
            color: self.color, radius: self.radius, pos: self.pos, speed: self.speed * direction)
    }

    func draw() {
        DrawCircleV(self.pos, self.radius, self.color)
    }
}
