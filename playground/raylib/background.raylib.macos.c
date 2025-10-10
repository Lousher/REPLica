#include "raylib.h"
#include <unistd.h>

void InitFullscreen(const char* title) {
  int width = GetMonitorWidth(0);
  int height = GetMonitorHeight(0);

  //SetConfigFlags(FLAG_FULLSCREEN_MODE);
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
    DrawTexturePro(texture, (Rectangle){0, 0, texture.width, texture.height },
		   (Rectangle){0, 0, GetMonitorWidth(0), GetMonitorHeight(0) },
		   (Vector2){0, 0}, 0.0f, WHITE);
    EndDrawing();
  }

  UnloadTexture(texture);
  CloseWindow();
}

int main() {
  InitFullscreen("Test Original Raylib");
  DisplayImage("../../assets/bg/yuwen.bedroom.morning.png");
}
