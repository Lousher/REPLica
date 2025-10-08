#include "raylib.h"
#include <math.h>
#include <unistd.h>

// 横向睁眼效果着色器
const char* horizontalEyeOpenShader = 
"#version 330\n"
"in vec2 fragTexCoord;"
"in vec4 fragColor;"
"uniform sampler2D texture0;"
"uniform float progress;"
"out vec4 finalColor;"
"void main()"
"{"
"    float distanceFromCenter = abs(fragTexCoord.y - 0.5);"
"    float threshold = progress * 0.5;"
"    float alpha = smoothstep(threshold - 0.05, threshold + 0.05, distanceFromCenter);"
"    vec4 texColor = texture(texture0, fragTexCoord);"
"    finalColor = mix(vec4(0.0, 0.0, 0.0, 1.0), texColor, alpha);"
"}";

int main(void)
{
    // 初始化窗口
    const int screenWidth = 800;
    const int screenHeight = 450;
    InitWindow(screenWidth, screenHeight, "简单睁眼效果示例");
    
    // 创建一个简单的背景纹理（如果没有外部纹理）
    Image img = GenImageColor(screenWidth, screenHeight, BLUE);
    ImageDrawCircle(&img, screenWidth/2, screenHeight/2, 100, RED);
    ImageDrawText(&img, "Raylib 睁眼效果", screenWidth/2 - 100, screenHeight/2 - 10, 20, WHITE);
    Texture2D background = LoadTextureFromImage(img);
    UnloadImage(img);
    
    // 加载着色器
    Shader eyeShader = LoadShaderFromMemory(NULL, horizontalEyeOpenShader);
    int progressLoc = GetShaderLocation(eyeShader, "progress");
    float progress = 0.0f;
    SetShaderValue(eyeShader, progressLoc, &progress, SHADER_UNIFORM_FLOAT);
    
    // 主循环
    float duration = 2.0f; // 效果持续时间（秒）
    float elapsed = 0.0f;
    bool effectComplete = false;
    
    SetTargetFPS(60);
    
    while (!WindowShouldClose())
    {
        // 更新进度
        if (!effectComplete)
        {
            elapsed += GetFrameTime();
            progress = elapsed / duration;
            
            if (progress > 1.0f)
            {
                progress = 1.0f;
                effectComplete = true;
            }
            
            SetShaderValue(eyeShader, progressLoc, &progress, SHADER_UNIFORM_FLOAT);
        }
        
        // 按空格键重新开始效果
        if (IsKeyPressed(KEY_SPACE))
        {
            elapsed = 0.0f;
            progress = 0.0f;
            effectComplete = false;
            SetShaderValue(eyeShader, progressLoc, &progress, SHADER_UNIFORM_FLOAT);
        }
        
        // 绘制
        BeginDrawing();
            ClearBackground(BLACK);
            
            if (effectComplete)
            {
                // 效果完成后直接绘制纹理
                DrawTexture(background, 0, 0, WHITE);
            }
            else
            {
                // 应用睁眼效果着色器
                BeginShaderMode(eyeShader);
                DrawTexture(background, 0, 0, WHITE);
                EndShaderMode();
            }
            
            // 显示说明文字
            DrawText("横向睁眼效果演示", 10, 10, 20, WHITE);
            DrawText(TextFormat("进度: %.2f", progress), 10, 40, 20, WHITE);
            DrawText("按空格键重新开始效果", 10, 70, 20, WHITE);
            
        EndDrawing();
    }
    
    // 清理资源
    UnloadTexture(background);
    UnloadShader(eyeShader);
    CloseWindow();
    
    return 0;
}
