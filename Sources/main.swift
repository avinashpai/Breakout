// 10-05-24
//
// Breakout
//
// Author:
//  Avinash Pai
//

import Raylib

protocol Hittable {}

struct Bar: Hittable {
    let color: Color
    var pos: Vector2
    var size: Vector2
    var speed: Vector2
}

struct Block: Hittable {
    var color: Color
    var pos: Vector2
}

struct Ball: Hittable {
    let color: Color
    let radius: Float
    var pos: Vector2
    var speed: Vector2
}

// main

let screenWidth: Int32 = 1280
let screenHeight: Int32 = 720

let blockColors: [Color] = [
    DARKGRAY, GRAY, BROWN, BEIGE,
    PURPLE, VIOLET, BLUE, SKYBLUE,
    LIME, GREEN, YELLOW, GOLD,
    ORANGE, YELLOW, RED, MAROON,
]

SetConfigFlags(FLAG_MSAA_4X_HINT.rawValue)
InitWindow(screenWidth, screenHeight, "Breakout!")

var bar = Bar(
    color: DARKGRAY,
    pos: .init(x: Float(GetScreenWidth()) / 2, y: Float(GetScreenHeight()) * (4 / 5)),
    size: .init(x: 80, y: 20),
    speed: .init(x: 0, y: 0)
)

var ball = Ball(
    color: MAROON,
    radius: 15,
    pos: .init(x: Float(GetScreenWidth()) / 2, y: Float(GetScreenHeight()) / 2),
    speed: .init(x: 5.0, y: 4.0),
)

let blocks: [Block] = (0..<16).flatMap { i in
    (0..<16).map { j in
        .init(
            color: blockColors[j % blockColors.count],
            pos: .init(x: Float(i) * bar.size.x, y: Float(j) * bar.size.y)
        )
    }
}

var pause = false
var frameCounter = 0

SetTargetFPS(60)

while !WindowShouldClose() {
    if IsKeyPressed(Int32(KEY_SPACE.rawValue)) {
        pause = !pause
    }

    if !pause {
        if IsKeyDown(Int32(KEY_D.rawValue)) {
            bar.speed.x = 8
        } else if IsKeyDown(Int32(KEY_A.rawValue)) {
            bar.speed.x = -8
        } else {
            bar.speed.x = 0
        }

        ball.pos += ball.speed
        bar.pos += bar.speed

        if ball.pos.x >= (Float(GetScreenWidth()) - ball.radius) || ball.pos.x <= ball.radius {
            ball.speed.x *= -1
        }

        if ball.pos.y >= (Float(GetScreenHeight()) - ball.radius) || ball.pos.y <= ball.radius {
            ball.speed.y *= -1
        }

        if bar.pos.x <= 0 {
            bar.pos.x = 0
        } else if bar.pos.x >= (Float(GetScreenWidth()) - bar.size.x) {
            bar.pos.x = Float(GetScreenWidth()) - bar.size.x
        }

    } else {
        frameCounter += 1
    }

    BeginDrawing()
    ClearBackground(RAYWHITE)

    DrawCircleV(ball.pos, ball.radius, ball.color)
    DrawRectangleV(bar.pos, bar.size, bar.color)
    DrawText("Press SPACE to pause", GetScreenWidth() / 2 - 60, GetScreenHeight() - 25, 20, GRAY)

    for block in blocks {
        DrawRectangleV(block.pos, bar.size, block.color)
        DrawRectangleLinesEx(
            .init(x: block.pos.x, y: block.pos.y, width: bar.size.x, height: bar.size.y),
            0.5,
            BLACK)
    }

    if pause && (frameCounter / 30) % 2 == 1 {
        DrawText("PAUSED", GetScreenWidth() / 2 - 45, GetScreenHeight() / 2, 30, GRAY)
    }

    DrawFPS(10, 10)

    EndDrawing()
}
CloseWindow()
// end
