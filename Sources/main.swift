// 10-05-24
//
// Breakout
//
// Author:
//  Avinash Pai
//

import Raylib

protocol Drawable {
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

// main

let screenWidth: Int32 = 1280
let screenHeight: Int32 = 720

let blockRows = 16
let blockColumns = 16
let blockColors: [Color] = [
    DARKGRAY, GRAY, BROWN, BEIGE,
    PURPLE, VIOLET, BLUE, SKYBLUE,
    LIME, GREEN, YELLOW, GOLD,
    ORANGE, YELLOW, RED, MAROON,
]
precondition(blockRows == blockColors.count)

SetConfigFlags(FLAG_MSAA_4X_HINT.rawValue)
InitWindow(screenWidth, screenHeight, "Breakout!")

var bar = Bar(
    color: DARKGRAY,
    pos: .init(x: Float(GetScreenWidth()) / 2, y: Float(GetScreenHeight()) * (4 / 5)),
    size: .init(x: 80, y: 20),
    speed: .init(x: 0, y: 0)
)

var ball = Ball(
    color: RAYWHITE,
    radius: 10,
    pos: .init(x: Float(GetScreenWidth()) / 2, y: Float(GetScreenHeight()) / 2),
    speed: .init(x: 5.0, y: 4.0),
)

let blocks: [Block] = (0..<blockRows).flatMap { i in
    (0..<blockColumns).map { j in
        .init(
            color: blockColors[j % blockColors.count],
            pos: .init(x: Float(i) * Block.size.x, y: Float(j) * Block.size.y)
        )
    }
}

var moveables: [Moveable] = [ball, bar]

var pause = false
var frameCounter = 0

SetTargetFPS(60)

while !WindowShouldClose() {
    if IsKeyPressed(Int32(KEY_SPACE.rawValue)) {
        pause = !pause
    }

    if !pause {
        moveables = moveables.map {
            $0.updatePosition().handleBounds()
        }
    } else {
        frameCounter += 1
    }

    BeginDrawing()
    ClearBackground(DARKBLUE)

    DrawText("Press SPACE to pause", GetScreenWidth() / 2 - 60, GetScreenHeight() - 25, 20, GRAY)

    if pause && (frameCounter / 30) % 2 == 1 {
        DrawText("PAUSED", GetScreenWidth() / 2 - 45, GetScreenHeight() / 2, 30, GRAY)
    }

    let drawables: [Drawable] = moveables + blocks
    for drawable in drawables {
        drawable.draw()
    }

    DrawFPS(10, 10)

    EndDrawing()
}
CloseWindow()
// end
