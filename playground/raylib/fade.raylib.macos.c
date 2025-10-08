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

int main(void)
{
    // 初始化窗口
    const int screenWidth = 800;
    const int screenHeight = 450;
    InitWindow(screenWidth, screenHeight, "图片渐变过渡效果");
    
    // 加载两张图片纹理
    // 注意：请替换为你的实际图片路径
    Texture2D texture1 = LoadTexture("../../assets/bg/a.jpg");
    Texture2D texture2 = LoadTexture("../../assets/bg/b.jpg");
    
    // 加载着色器
    Shader shader = LoadShaderFromMemory(NULL, fadeShader);

    int texture1Loc = GetShaderLocation(shader, "texture1");
    
    // 获取着色器中的uniform位置
    int progressLoc = GetShaderLocation(shader, "progress");
    float progress = 0.0f;

    
    // 主循环
    float duration = 2.0f; // 过渡持续时间（秒）
    float elapsed = 0.0f;
    bool isReversing = false;
    
    SetTargetFPS(60);
    
    while (!WindowShouldClose())
    {
        // 更新进度
        elapsed += GetFrameTime();
              
            progress = elapsed / duration;
            if (progress >= 1.0f) {
                progress = 1.0f;
                elapsed = 0.0f;
            }
                  
        SetShaderValue(shader, progressLoc, &progress, SHADER_UNIFORM_FLOAT);
        
        // 绘制
        BeginDrawing();
            ClearBackground(BLACK);
            
            // 应用着色器
            BeginShaderMode(shader);
            
            // 绘制第一张纹理（作为底色）
            SetShaderValueTexture(shader, texture1Loc, texture2);
//            DrawTexture(texture1, 0, 0, WHITE);
            
            // 绘制第二张纹理（着色器会混合这两张纹理）
            DrawTexture(texture1, 0, 0, WHITE);
            
            EndShaderMode();
            
            // 显示说明文字
            DrawText("图片渐变过渡效果", 10, 10, 20, WHITE);
            DrawText(TextFormat("进度: %.2f", progress), 10, 40, 20, WHITE);
            DrawText("按ESC退出", 10, 70, 20, WHITE);
            
        EndDrawing();
    }
    
    // 清理资源
    UnloadTexture(texture1);
    UnloadTexture(texture2);
    UnloadShader(shader);
    CloseWindow();
    
    return 0;
}
