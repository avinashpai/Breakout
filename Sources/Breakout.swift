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
    var blocks: [Block] = (0..<blockRows).flatMap { i in
        (0..<blockColumns).map { j in
            .init(
                color: blockColors[j % blockColors.count],
                pos: .init(x: Float(i) * Block.size.x, y: Float(j) * Block.size.y),
            )
        }
    }

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

    }

    private func handleCollisions(_ blocks: inout [Block]) {
        // TODO: check if ball collided with bar

        blocks = blocks.map { block in
            // TODO: Check if call collided w block
            if false {
                .init(color: block.color, pos: block.pos, alive: false)
            } else {
                block
            }
        }.filter { $0.alive }
    }

    func run() throws {
        precondition(Self.blockRows == Self.blockColors.count)

        SetTargetFPS(60)
        SetConfigFlags(FLAG_MSAA_4X_HINT.rawValue)

        var moveables: [Moveable] = [ball, bar]
        var resolvedBlocks: [Block] = []
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
                resolvedBlocks = self.blocks
                handleCollisions(&resolvedBlocks)
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
