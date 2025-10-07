#include "raylib.h"

int main() {
    InitWindow(800, 600, "Raylib Test");
    
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Raylib is working!", 100, 100, 40, BLACK);
        EndDrawing();
    }
    
    CloseWindow();
    return 0;
}
