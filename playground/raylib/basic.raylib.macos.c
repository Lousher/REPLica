#include "raylib.h"

int main(void)
{
  const int screenWidth = GetScreenWidth();
  const int screenHeight = GetScreenHeight();

    InitWindow(screenWidth, screenHeight, "Raylib Basic Loop");
    SetTargetFPS(60);
    Texture tex = LoadTexture("../../assets/bg/yuwen.bedroom.morning.png");

    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawTexture(tex, 0, 0, WHITE);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
