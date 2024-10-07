import Raylib

struct Breakout {
    static let screenWidth: Int32 = 1280
    static let screenHeight: Int32 = 720

    static let blockRows = 16
    static let blockColumns = 12
    static let blockColors: [Color] = [
        DARKGRAY, GRAY, BROWN,
        PURPLE, VIOLET, SKYBLUE,
        LIME, GREEN, GOLD,
        ORANGE, YELLOW, MAROON,
    ]

    static let bar = Bar(
        color: DARKGRAY,
        pos: .init(x: Float(GetScreenWidth()) / 2 - 50, y: Float(GetScreenHeight()) * (4 / 5)),
        size: .init(x: 100, y: 15),
        speed: .init(x: 0, y: 0)
    )

    static let ball = Ball(
        color: RAYWHITE,
        radius: 10,
        pos: .init(x: Float(GetScreenWidth()) / 2 - 10, y: Float(GetScreenHeight()) / 2 + 10),
        speed: .init(x: 5.0, y: 4.0),
    )

    static let blocks: [Block] = (0..<Self.blockRows).flatMap { i in
        (0..<Self.blockColumns).map { j in
            .init(
                color: Self.blockColors[j % Self.blockColors.count],
                pos: .init(x: Float(i) * Block.size.x, y: Float(j) * Block.size.y),
            )
        }
    }

    struct State {
        var bar = Breakout.bar
        var ball = Breakout.ball
        var blocks = Breakout.blocks

        var pause = false

        var lives = 5
        var frameCounter = 0

        var won: Bool {
            self.blocks.isEmpty
        }

        var gameover: Bool {
            self.won || self.lives == 0
        }

        mutating func reset() {
            bar = Breakout.bar
            ball = Breakout.ball
            blocks = Breakout.blocks

            pause = false

            lives = 5
            frameCounter = 0
        }
    }

    private static func handleCollisions(_ bar: Bar, _ ball: inout Ball, _ blocks: inout [Block]) {
        var nBall = ball
        if case let (direction, collided) = nBall.collidedWith(
            rect:
                .init(x: bar.pos.x, y: bar.pos.y, width: bar.size.x, height: bar.size.y)),
            collided == true
        {
            nBall.speed *= direction
        }

        blocks = blocks.filter {
            let (direction, collided) = nBall.collidedWith(
                rect:
                    .init(x: $0.pos.x, y: $0.pos.y, width: Block.size.x, height: Block.size.y))
            if !collided {
                return true
            } else {
                nBall.speed *= direction
                return false
            }
        }

        ball = nBall
    }

    static func run() {
        SetTargetFPS(60)
        SetConfigFlags(FLAG_MSAA_4X_HINT.rawValue)
        InitWindow(Self.screenWidth, Self.screenHeight, "Breakout!")

        var state = State()
        while !WindowShouldClose() {
            if IsKeyPressed(Int32(KEY_SPACE.rawValue)) {
                state.pause = !state.pause
            }

            if !state.pause && !state.gameover {
                state.bar = state.bar.updatePosition().handleBounds()
                state.ball = state.ball.updatePosition().handleBounds(&state.lives)
                Self.handleCollisions(state.bar, &state.ball, &state.blocks)
            } else {
                state.frameCounter += 1
            }

            BeginDrawing()
            ClearBackground(DARKBLUE)

            if state.gameover {
                DrawTextCentered(
                    "\(state.won ? "YOU WIN!": "GAMEOVER")", 50, state.won ? GREEN : RED)
                DrawTextCenteredX(
                    "Exit window or press R to restart", GetScreenHeight() / 2 + 25, 25, GRAY)
            } else {
                DrawTextCenteredX(
                    "Press SPACE to pause", GetScreenHeight() - 25, 20,
                    GRAY)

                if state.pause && (state.frameCounter / 30) % 2 == 1 {
                    DrawTextCentered("PAUSED", 50, GRAY)
                }

                DrawTextCenteredX(
                    "Lives: \(state.lives)", GetScreenHeight() - 55, 25, RED)

                let drawables: [Drawable] = [state.bar, state.ball] + state.blocks
                for drawable in drawables {
                    drawable.draw()
                }
            }

            DrawFPS(10, 10)

            EndDrawing()

            if IsKeyPressed(Int32(KEY_R.rawValue)) {
                state.reset()
            }
        }

        CloseWindow()
    }
}
