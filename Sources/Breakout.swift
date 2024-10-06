import Raylib

struct Breakout {
    static let blockRows = 16
    static let blockColumns = 16
    static let blockColors: [Color] = [
        DARKGRAY, GRAY, BROWN, BEIGE,
        PURPLE, VIOLET, BLUE, SKYBLUE,
        LIME, GREEN, YELLOW, GOLD,
        ORANGE, YELLOW, RED, MAROON,
    ]

    var bar: Bar
    var ball: Ball
    var blocks: [Block]

    init(screenWidth: Int32, screenHeight: Int32) {
        InitWindow(screenWidth, screenHeight, "Breakout!")

        bar = Bar(
            color: DARKGRAY,
            pos: .init(x: Float(GetScreenWidth()) / 2, y: Float(GetScreenHeight()) * (4 / 5)),
            size: .init(x: 80, y: 20),
            speed: .init(x: 0, y: 0)
        )

        ball = Ball(
            color: RAYWHITE,
            radius: 10,
            pos: .init(x: Float(GetScreenWidth()) / 2, y: Float(GetScreenHeight()) / 2),
            speed: .init(x: 5.0, y: 4.0),
        )

        precondition(Self.blockRows == Self.blockColors.count)
        blocks = (0..<Self.blockRows).flatMap { i in
            (0..<Self.blockColumns).map { j in
                .init(
                    color: Self.blockColors[j % Self.blockColors.count],
                    pos: .init(x: Float(i) * Block.size.x, y: Float(j) * Block.size.y),
                )
            }
        }
    }

    private func collidedWith(_ ball: Ball, rect: Rectangle) -> (Vector2, Bool) {
        var direction = Vector2(x: 1, y: 1)
        var testX = ball.pos.x
        var testY = ball.pos.y

        if ball.pos.x < rect.x {
            testX = rect.x
            direction.x = -1
        } else if ball.pos.x > rect.x + rect.width {
            testX = rect.x + rect.width
            direction.x = -1
        }

        if ball.pos.y < rect.y {
            testY = rect.y
            direction.y = -1
        } else if ball.pos.y > rect.y + rect.height {
            testY = rect.y + rect.height
            direction.y = -1
        }

        let distX = ball.pos.x - testX
        let distY = ball.pos.y - testY
        let distance = sqrt((distX * distX) + (distY * distY))
        return (direction, distance <= ball.radius)
    }

    private func handleCollisions(_ moveables: inout [Moveable], _ blocks: inout [Block]) {
        guard var ball: Ball = moveables[0] as? Ball else {
            return
        }

        guard let bar: Bar = moveables[1] as? Bar else {
            return
        }

        if case let (direction, collided) = collidedWith(
            ball,
            rect:
                .init(x: bar.pos.x, y: bar.pos.y, width: bar.size.x, height: bar.size.y)),
            collided == true
        {
            ball.speed *= direction
        }

        blocks = blocks.filter {
            let (direction, collided) = collidedWith(
                ball,
                rect:
                    .init(x: $0.pos.x, y: $0.pos.y, width: Block.size.x, height: Block.size.y))
            if !collided {
                return true
            } else {
                ball.speed *= direction
                return false
            }
        }

        moveables[0] = ball
    }

    func run() throws {
        SetTargetFPS(60)
        SetConfigFlags(FLAG_MSAA_4X_HINT.rawValue)

        var moveables: [Moveable] = [ball, bar]
        var resolvedBlocks: [Block] = self.blocks
        var pause = false
        var frameCounter = 0

        while !WindowShouldClose() {
            if IsKeyPressed(Int32(KEY_SPACE.rawValue)) {
                pause = !pause
            }

            if !pause {
                moveables = moveables.map {
                    $0.updatePosition().handleBounds()
                }
                handleCollisions(&moveables, &resolvedBlocks)
            } else {
                frameCounter += 1
            }

            BeginDrawing()
            ClearBackground(DARKBLUE)

            DrawText(
                "Press SPACE to pause", GetScreenWidth() / 2 - 60, GetScreenHeight() - 25, 20, GRAY)

            if pause && (frameCounter / 30) % 2 == 1 {
                DrawText("PAUSED", GetScreenWidth() / 2 - 45, GetScreenHeight() / 2, 30, GRAY)
            }

            let drawables: [Drawable] = moveables + resolvedBlocks
            for drawable in drawables {
                drawable.draw()
            }

            DrawFPS(10, 10)

            EndDrawing()
        }
        CloseWindow()
    }
}
