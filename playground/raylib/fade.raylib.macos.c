#include "raylib.h"
#include <unistd.h>

// 渐变过渡着色器
const char* fadeShader = 
  "#version 330\n"
  "in vec2 fragTexCoord;"
  "in vec4 fragColor;"
  "uniform sampler2D texture0;"
  "uniform sampler2D texture1;"
  "uniform float progress;"
  "out vec4 finalColor;"
  "void main()"
  "{"
  "    vec4 color1 = texture(texture0, fragTexCoord);"
  "    vec4 color2 = texture(texture1, fragTexCoord);"
  "    finalColor = mix(color1, color2, progress);"
  "}";

int main()
{
  const int screenWidth = 800;
  const int screenHeight = 450;
  InitWindow(screenWidth, screenHeight, "Effect");
    
  Texture2D texture1 = LoadTexture("../../assets/bg/a.jpg");
  Texture2D texture2 = LoadTexture("../../assets/bg/b.jpg");
    
  Shader shader = LoadShaderFromMemory(NULL, fadeShader);

  int texture1Loc = GetShaderLocation(shader, "texture1");
    
  int progressLoc = GetShaderLocation(shader, "progress");
  float progress = 0.0f;

    
  float duration = 2.0f; 
  float elapsed = 0.0f;
    
  SetTargetFPS(60);
    
  while (!WindowShouldClose())
    {
      elapsed += GetFrameTime();
              
      progress = elapsed / duration;
      if (progress >= 1.0f) {
        progress = 1.0f;
        elapsed = 0.0f;
      }
                  
      SetShaderValue(shader, progressLoc, &progress, SHADER_UNIFORM_FLOAT);
        
      BeginDrawing();
      ClearBackground(BLACK);
            
      BeginShaderMode(shader);
            
      SetShaderValueTexture(shader, texture1Loc, texture2);
      DrawTexture(texture1, 0, 0, WHITE);
            
      EndShaderMode();
      EndDrawing();
    }
  
  UnloadTexture(texture1);
  UnloadTexture(texture2);
  UnloadShader(shader);
  CloseWindow();
    
  return 0;
}
