#include "raylib.h"
#include <unistd.h>

void InitFullscreen(const char* title) {
  int width = GetMonitorWidth(0);
  int height = GetMonitorHeight(0);

  SetConfigFlags(FLAG_FULLSCREEN_MODE);
  InitWindow(width, height, title);
  SetTargetFPS(60);
}

void DisplayImage(const char* path) {
  if (!IsWindowReady()) {
    TraceLog(LOG_WARNING, "Must call InitFullscreen Before");
    return;
  }

  Image image = LoadImage(path);

  if (image.data == NULL) {
    TraceLog(LOG_WARNING, "Cannot Load Image: %s", path);
  }

  Texture2D texture = LoadTextureFromImage(image);

  UnloadImage(image);

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);
    DrawTextureEx(texture, (Vector2){0, 0}, 0.0f, 1.0f, WHITE);
    EndDrawing();
  }

  UnloadTexture(texture);
  CloseWindow();
}

