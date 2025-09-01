#include "raylib.h"
#include <unistd.h>

int main(void) {
  const int screenWidth = 800;
  const int screenHeight = 600;
  const char* title = "Raylib macOs Demo";

  int fileSize;
  unsigned char *fontFileData = LoadFileData("Circle.otf", &fileSize);

  char* text = "这是一条测试数据？";

  int codePointsCount;
  int *codePoints = LoadCodepoints(text, &codePointsCount);

  InitWindow(screenWidth, screenHeight, title);

  Font myFont = LoadFontFromMemory(".otf", fontFileData, fileSize, 500, codePoints, codePointsCount);
  UnloadCodepoints(codePoints);

  Vector2 textPosition = {
    300, 200
  };

  SetTargetFPS(60);

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground((Color){135, 206, 235, 255});
        DrawCircle(screenWidth/2, screenHeight/2, 50, GREEN);
        
        DrawTextEx(myFont, text, textPosition, 50, 0, DARKBLUE);

        DrawText("成功安装", 340, screenHeight/2 - 80, 40, MAROON);
        DrawText("按ESC或关闭窗口退出", 260, 500, 20, DARKGRAY);
        
        DrawText(TextFormat("FPS: %d", GetFPS()), 10, 10, 20, RED);
        
        EndDrawing();
  }

  CloseWindow();
  UnloadFont(myFont);

  return 0;
}
