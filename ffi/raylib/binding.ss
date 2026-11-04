(library (ffi raylib binding)
  (export RAYLIB_VERSION_MAJOR RAYLIB_VERSION_MINOR
   RAYLIB_VERSION_PATCH RAYLIB_VERSION PI FLAG_VSYNC_HINT
   FLAG_FULLSCREEN_MODE FLAG_WINDOW_RESIZABLE
   FLAG_WINDOW_UNDECORATED FLAG_WINDOW_HIDDEN
   FLAG_WINDOW_MINIMIZED FLAG_WINDOW_MAXIMIZED
   FLAG_WINDOW_UNFOCUSED FLAG_WINDOW_TOPMOST
   FLAG_WINDOW_ALWAYS_RUN FLAG_WINDOW_TRANSPARENT
   FLAG_WINDOW_HIGHDPI FLAG_WINDOW_MOUSE_PASSTHROUGH
   FLAG_BORDERLESS_WINDOWED_MODE FLAG_MSAA_4X_HINT
   FLAG_INTERLACED_HINT LOG_ALL LOG_TRACE LOG_DEBUG LOG_INFO
   LOG_WARNING LOG_ERROR LOG_FATAL LOG_NONE KEY_NULL
   KEY_APOSTROPHE KEY_COMMA KEY_MINUS KEY_PERIOD KEY_SLASH
   KEY_ZERO KEY_ONE KEY_TWO KEY_THREE KEY_FOUR KEY_FIVE KEY_SIX
   KEY_SEVEN KEY_EIGHT KEY_NINE KEY_SEMICOLON KEY_EQUAL KEY_A
   KEY_B KEY_C KEY_D KEY_E KEY_F KEY_G KEY_H KEY_I KEY_J KEY_K
   KEY_L KEY_M KEY_N KEY_O KEY_P KEY_Q KEY_R KEY_S KEY_T KEY_U
   KEY_V KEY_W KEY_X KEY_Y KEY_Z KEY_LEFT_BRACKET KEY_BACKSLASH
   KEY_RIGHT_BRACKET KEY_GRAVE KEY_SPACE KEY_ESCAPE KEY_ENTER
   KEY_TAB KEY_BACKSPACE KEY_INSERT KEY_DELETE KEY_RIGHT
   KEY_LEFT KEY_DOWN KEY_UP KEY_PAGE_UP KEY_PAGE_DOWN KEY_HOME
   KEY_END KEY_CAPS_LOCK KEY_SCROLL_LOCK KEY_NUM_LOCK
   KEY_PRINT_SCREEN KEY_PAUSE KEY_F1 KEY_F2 KEY_F3 KEY_F4
   KEY_F5 KEY_F6 KEY_F7 KEY_F8 KEY_F9 KEY_F10 KEY_F11 KEY_F12
   KEY_LEFT_SHIFT KEY_LEFT_CONTROL KEY_LEFT_ALT KEY_LEFT_SUPER
   KEY_RIGHT_SHIFT KEY_RIGHT_CONTROL KEY_RIGHT_ALT
   KEY_RIGHT_SUPER KEY_KB_MENU KEY_KP_0 KEY_KP_1 KEY_KP_2
   KEY_KP_3 KEY_KP_4 KEY_KP_5 KEY_KP_6 KEY_KP_7 KEY_KP_8
   KEY_KP_9 KEY_KP_DECIMAL KEY_KP_DIVIDE KEY_KP_MULTIPLY
   KEY_KP_SUBTRACT KEY_KP_ADD KEY_KP_ENTER KEY_KP_EQUAL
   KEY_BACK KEY_MENU KEY_VOLUME_UP KEY_VOLUME_DOWN
   MOUSE_BUTTON_LEFT MOUSE_BUTTON_RIGHT MOUSE_BUTTON_MIDDLE
   MOUSE_BUTTON_SIDE MOUSE_BUTTON_EXTRA MOUSE_BUTTON_FORWARD
   MOUSE_BUTTON_BACK MOUSE_CURSOR_DEFAULT MOUSE_CURSOR_ARROW
   MOUSE_CURSOR_IBEAM MOUSE_CURSOR_CROSSHAIR
   MOUSE_CURSOR_POINTING_HAND MOUSE_CURSOR_RESIZE_EW
   MOUSE_CURSOR_RESIZE_NS MOUSE_CURSOR_RESIZE_NWSE
   MOUSE_CURSOR_RESIZE_NESW MOUSE_CURSOR_RESIZE_ALL
   MOUSE_CURSOR_NOT_ALLOWED GAMEPAD_BUTTON_UNKNOWN
   GAMEPAD_BUTTON_LEFT_FACE_UP GAMEPAD_BUTTON_LEFT_FACE_RIGHT
   GAMEPAD_BUTTON_LEFT_FACE_DOWN GAMEPAD_BUTTON_LEFT_FACE_LEFT
   GAMEPAD_BUTTON_RIGHT_FACE_UP GAMEPAD_BUTTON_RIGHT_FACE_RIGHT
   GAMEPAD_BUTTON_RIGHT_FACE_DOWN
   GAMEPAD_BUTTON_RIGHT_FACE_LEFT GAMEPAD_BUTTON_LEFT_TRIGGER_1
   GAMEPAD_BUTTON_LEFT_TRIGGER_2 GAMEPAD_BUTTON_RIGHT_TRIGGER_1
   GAMEPAD_BUTTON_RIGHT_TRIGGER_2 GAMEPAD_BUTTON_MIDDLE_LEFT
   GAMEPAD_BUTTON_MIDDLE GAMEPAD_BUTTON_MIDDLE_RIGHT
   GAMEPAD_BUTTON_LEFT_THUMB GAMEPAD_BUTTON_RIGHT_THUMB
   GAMEPAD_AXIS_LEFT_X GAMEPAD_AXIS_LEFT_Y GAMEPAD_AXIS_RIGHT_X
   GAMEPAD_AXIS_RIGHT_Y GAMEPAD_AXIS_LEFT_TRIGGER
   GAMEPAD_AXIS_RIGHT_TRIGGER MATERIAL_MAP_ALBEDO
   MATERIAL_MAP_METALNESS MATERIAL_MAP_NORMAL
   MATERIAL_MAP_ROUGHNESS MATERIAL_MAP_OCCLUSION
   MATERIAL_MAP_EMISSION MATERIAL_MAP_HEIGHT
   MATERIAL_MAP_CUBEMAP MATERIAL_MAP_IRRADIANCE
   MATERIAL_MAP_PREFILTER MATERIAL_MAP_BRDF
   SHADER_LOC_VERTEX_POSITION SHADER_LOC_VERTEX_TEXCOORD01
   SHADER_LOC_VERTEX_TEXCOORD02 SHADER_LOC_VERTEX_NORMAL
   SHADER_LOC_VERTEX_TANGENT SHADER_LOC_VERTEX_COLOR
   SHADER_LOC_MATRIX_MVP SHADER_LOC_MATRIX_VIEW
   SHADER_LOC_MATRIX_PROJECTION SHADER_LOC_MATRIX_MODEL
   SHADER_LOC_MATRIX_NORMAL SHADER_LOC_VECTOR_VIEW
   SHADER_LOC_COLOR_DIFFUSE SHADER_LOC_COLOR_SPECULAR
   SHADER_LOC_COLOR_AMBIENT SHADER_LOC_MAP_ALBEDO
   SHADER_LOC_MAP_METALNESS SHADER_LOC_MAP_NORMAL
   SHADER_LOC_MAP_ROUGHNESS SHADER_LOC_MAP_OCCLUSION
   SHADER_LOC_MAP_EMISSION SHADER_LOC_MAP_HEIGHT
   SHADER_LOC_MAP_CUBEMAP SHADER_LOC_MAP_IRRADIANCE
   SHADER_LOC_MAP_PREFILTER SHADER_LOC_MAP_BRDF
   SHADER_LOC_VERTEX_BONEIDS SHADER_LOC_VERTEX_BONEWEIGHTS
   SHADER_LOC_MATRIX_BONETRANSFORMS
   SHADER_LOC_VERTEX_INSTANCETRANSFORM SHADER_UNIFORM_FLOAT
   SHADER_UNIFORM_VEC2 SHADER_UNIFORM_VEC3 SHADER_UNIFORM_VEC4
   SHADER_UNIFORM_INT SHADER_UNIFORM_IVEC2 SHADER_UNIFORM_IVEC3
   SHADER_UNIFORM_IVEC4 SHADER_UNIFORM_UINT
   SHADER_UNIFORM_UIVEC2 SHADER_UNIFORM_UIVEC3
   SHADER_UNIFORM_UIVEC4 SHADER_UNIFORM_SAMPLER2D
   SHADER_ATTRIB_FLOAT SHADER_ATTRIB_VEC2 SHADER_ATTRIB_VEC3
   SHADER_ATTRIB_VEC4 PIXELFORMAT_UNCOMPRESSED_GRAYSCALE
   PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA
   PIXELFORMAT_UNCOMPRESSED_R5G6B5
   PIXELFORMAT_UNCOMPRESSED_R8G8B8
   PIXELFORMAT_UNCOMPRESSED_R5G5B5A1
   PIXELFORMAT_UNCOMPRESSED_R4G4B4A4
   PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
   PIXELFORMAT_UNCOMPRESSED_R32
   PIXELFORMAT_UNCOMPRESSED_R32G32B32
   PIXELFORMAT_UNCOMPRESSED_R32G32B32A32
   PIXELFORMAT_UNCOMPRESSED_R16
   PIXELFORMAT_UNCOMPRESSED_R16G16B16
   PIXELFORMAT_UNCOMPRESSED_R16G16B16A16
   PIXELFORMAT_COMPRESSED_DXT1_RGB
   PIXELFORMAT_COMPRESSED_DXT1_RGBA
   PIXELFORMAT_COMPRESSED_DXT3_RGBA
   PIXELFORMAT_COMPRESSED_DXT5_RGBA
   PIXELFORMAT_COMPRESSED_ETC1_RGB
   PIXELFORMAT_COMPRESSED_ETC2_RGB
   PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA
   PIXELFORMAT_COMPRESSED_PVRT_RGB
   PIXELFORMAT_COMPRESSED_PVRT_RGBA
   PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA
   PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA TEXTURE_FILTER_POINT
   TEXTURE_FILTER_BILINEAR TEXTURE_FILTER_TRILINEAR
   TEXTURE_FILTER_ANISOTROPIC_4X TEXTURE_FILTER_ANISOTROPIC_8X
   TEXTURE_FILTER_ANISOTROPIC_16X TEXTURE_WRAP_REPEAT
   TEXTURE_WRAP_CLAMP TEXTURE_WRAP_MIRROR_REPEAT
   TEXTURE_WRAP_MIRROR_CLAMP CUBEMAP_LAYOUT_AUTO_DETECT
   CUBEMAP_LAYOUT_LINE_VERTICAL CUBEMAP_LAYOUT_LINE_HORIZONTAL
   CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR
   CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE FONT_DEFAULT FONT_BITMAP
   FONT_SDF BLEND_ALPHA BLEND_ADDITIVE BLEND_MULTIPLIED
   BLEND_ADD_COLORS BLEND_SUBTRACT_COLORS
   BLEND_ALPHA_PREMULTIPLY BLEND_CUSTOM BLEND_CUSTOM_SEPARATE
   GESTURE_NONE GESTURE_TAP GESTURE_DOUBLETAP GESTURE_HOLD
   GESTURE_DRAG GESTURE_SWIPE_RIGHT GESTURE_SWIPE_LEFT
   GESTURE_SWIPE_UP GESTURE_SWIPE_DOWN GESTURE_PINCH_IN
   GESTURE_PINCH_OUT CAMERA_CUSTOM CAMERA_FREE CAMERA_ORBITAL
   CAMERA_FIRST_PERSON CAMERA_THIRD_PERSON CAMERA_PERSPECTIVE
   CAMERA_ORTHOGRAPHIC NPATCH_NINE_PATCH
   NPATCH_THREE_PATCH_VERTICAL NPATCH_THREE_PATCH_HORIZONTAL
   TraceLogCallback LoadFileDataCallback SaveFileDataCallback
   LoadFileTextCallback SaveFileTextCallback AudioCallback
   Vector2 Vector3 Vector4 Quaternion Matrix Color Rectangle
   Image Texture Texture2D TextureCubemap RenderTexture
   RenderTexture2D NPatchInfo GlyphInfo Font Camera3D Camera
   Camera2D Mesh Shader MaterialMap Material Transform
   ModelAnimPose BoneInfo ModelSkeleton Model ModelAnimation
   Ray RayCollision BoundingBox Wave AudioStream Sound Music
   VrDeviceInfo VrStereoConfig FilePathList AutomationEvent
   AutomationEventList InitWindow CloseWindow WindowShouldClose
   IsWindowReady IsWindowFullscreen IsWindowHidden
   IsWindowMinimized IsWindowMaximized IsWindowFocused
   IsWindowResized IsWindowState SetWindowState
   ClearWindowState ToggleFullscreen ToggleBorderlessWindowed
   MaximizeWindow MinimizeWindow RestoreWindow SetWindowIcon
   SetWindowIcons SetWindowTitle SetWindowPosition
   SetWindowMonitor SetWindowMinSize SetWindowMaxSize
   SetWindowSize SetWindowOpacity SetWindowFocused
   GetWindowHandle GetScreenWidth GetScreenHeight
   GetRenderWidth GetRenderHeight GetMonitorCount
   GetCurrentMonitor GetMonitorPosition GetMonitorWidth
   GetMonitorHeight GetMonitorPhysicalWidth
   GetMonitorPhysicalHeight GetMonitorRefreshRate
   GetWindowPosition GetWindowScaleDPI GetMonitorName
   SetClipboardText GetClipboardText GetClipboardImage
   EnableEventWaiting DisableEventWaiting ShowCursor HideCursor
   IsCursorHidden EnableCursor DisableCursor IsCursorOnScreen
   ClearBackground BeginDrawing EndDrawing BeginMode2D
   EndMode2D BeginMode3D EndMode3D BeginTextureMode
   EndTextureMode BeginShaderMode EndShaderMode BeginBlendMode
   EndBlendMode BeginScissorMode EndScissorMode
   BeginVrStereoMode EndVrStereoMode LoadVrStereoConfig
   UnloadVrStereoConfig LoadShader LoadShaderFromMemory
   IsShaderValid GetShaderLocation GetShaderLocationAttrib
   SetShaderValue SetShaderValueV SetShaderValueMatrix
   SetShaderValueTexture UnloadShader GetScreenToWorldRay
   GetScreenToWorldRayEx GetWorldToScreen GetWorldToScreenEx
   GetWorldToScreen2D GetScreenToWorld2D GetCameraMatrix
   GetCameraMatrix2D SetTargetFPS GetFrameTime GetTime GetFPS
   SwapScreenBuffer PollInputEvents WaitTime SetRandomSeed
   GetRandomValue LoadRandomSequence UnloadRandomSequence
   TakeScreenshot SetConfigFlags OpenURL SetTraceLogLevel
   TraceLog SetTraceLogCallback MemAlloc MemRealloc MemFree
   LoadFileData UnloadFileData SaveFileData ExportDataAsCode
   LoadFileText UnloadFileText SaveFileText
   SetLoadFileDataCallback SetSaveFileDataCallback
   SetLoadFileTextCallback SetSaveFileTextCallback FileRename
   FileRemove FileCopy FileMove FileTextReplace
   FileTextFindIndex FileExists DirectoryExists IsFileExtension
   IsFileHidden GetFileLength GetFileModTime GetFileExtension
   GetFileName GetFileNameWithoutExt GetDirectoryPath
   GetPrevDirectoryPath GetWorkingDirectory
   GetApplicationDirectory MakeDirectory ChangeDirectory
   IsPathFile IsPathDirectory IsPathAbsolute IsFileNameValid
   LoadDirectoryFiles LoadDirectoryFilesEx UnloadDirectoryFiles
   IsFileDropped LoadDroppedFiles UnloadDroppedFiles
   GetDirectoryFileCount GetDirectoryFileCountEx CompressData
   DecompressData EncodeDataBase64 DecodeDataBase64
   ComputeCRC32 ComputeMD5 ComputeSHA1 ComputeSHA256
   LoadAutomationEventList UnloadAutomationEventList
   ExportAutomationEventList SetAutomationEventList
   SetAutomationEventBaseFrame StartAutomationEventRecording
   StopAutomationEventRecording PlayAutomationEvent
   IsKeyPressed IsKeyPressedRepeat IsKeyDown IsKeyReleased
   IsKeyUp GetKeyPressed GetCharPressed GetKeyName SetExitKey
   IsGamepadAvailable GetGamepadName IsGamepadButtonPressed
   IsGamepadButtonDown IsGamepadButtonReleased
   IsGamepadButtonUp GetGamepadButtonPressed
   GetGamepadAxisCount GetGamepadAxisMovement
   SetGamepadMappings SetGamepadVibration IsMouseButtonPressed
   IsMouseButtonDown IsMouseButtonReleased IsMouseButtonUp
   GetMouseX GetMouseY GetMousePosition GetMouseDelta
   SetMousePosition SetMouseOffset SetMouseScale
   GetMouseWheelMove GetMouseWheelMoveV SetMouseCursor
   GetTouchX GetTouchY GetTouchPosition GetTouchPointId
   GetTouchPointCount SetGesturesEnabled IsGestureDetected
   GetGestureDetected GetGestureHoldDuration
   GetGestureDragVector GetGestureDragAngle
   GetGesturePinchVector GetGesturePinchAngle UpdateCamera
   UpdateCameraPro SetShapesTexture GetShapesTexture
   GetShapesTextureRectangle DrawPixel DrawPixelV DrawLine
   DrawLineV DrawLineEx DrawLineStrip DrawLineBezier
   DrawLineDashed DrawTriangle DrawTriangleGradient
   DrawTriangleLines DrawTriangleLinesEx DrawTriangleFan
   DrawTriangleStrip DrawRectangle DrawRectangleV
   DrawRectangleRec DrawRectanglePro DrawRectangleGradientV
   DrawRectangleGradientH DrawRectangleGradientEx
   DrawRectangleLines DrawRectangleLinesEx DrawRectangleRounded
   DrawRectangleRoundedLines DrawRectangleRoundedLinesEx
   DrawPoly DrawPolyLines DrawPolyLinesEx DrawCircle
   DrawCircleV DrawCircleGradient DrawCircleSector
   DrawCircleSectorLines DrawCircleSectorLinesEx
   DrawCircleLines DrawCircleLinesV DrawCircleLinesEx
   DrawEllipse DrawEllipseV DrawEllipseLines DrawEllipseLinesV
   DrawEllipseLinesEx DrawRing DrawRingLines DrawRingLinesEx
   DrawSplineLinear DrawSplineBasis DrawSplineCatmullRom
   DrawSplineBezierQuadratic DrawSplineBezierCubic
   DrawSplineSegmentLinear DrawSplineSegmentBasis
   DrawSplineSegmentCatmullRom DrawSplineSegmentBezierQuadratic
   DrawSplineSegmentBezierCubic GetSplinePointLinear
   GetSplinePointBasis GetSplinePointCatmullRom
   GetSplinePointBezierQuadratic GetSplinePointBezierCubic
   CheckCollisionRecs CheckCollisionCircles
   CheckCollisionCircleRec CheckCollisionCircleLine
   CheckCollisionPointRec CheckCollisionPointCircle
   CheckCollisionPointTriangle CheckCollisionPointLine
   CheckCollisionPointPoly CheckCollisionLines GetCollisionRec
   LoadImage LoadImageRaw LoadImageAnim LoadImageAnimFromMemory
   LoadImageFromMemory LoadImageFromTexture LoadImageFromScreen
   IsImageValid UnloadImage ExportImage ExportImageToMemory
   ExportImageAsCode GenImageColor GenImageGradientLinear
   GenImageGradientRadial GenImageGradientSquare
   GenImageChecked GenImageWhiteNoise GenImagePerlinNoise
   GenImageCellular GenImageText ImageCopy ImageFromImage
   ImageFromChannel ImageText ImageTextEx ImageFormat
   ImageToPOT ImageCrop ImageAlphaCrop ImageAlphaClear
   ImageAlphaMask ImageAlphaPremultiply ImageBlurGaussian
   ImageKernelConvolution ImageResize ImageResizeNN
   ImageResizeCanvas ImageMipmaps ImageDither ImageFlipVertical
   ImageFlipHorizontal ImageRotate ImageRotateCW ImageRotateCCW
   ImageColorTint ImageColorInvert ImageColorGrayscale
   ImageColorContrast ImageColorBrightness ImageColorReplace
   LoadImageColors LoadImagePalette UnloadImageColors
   UnloadImagePalette GetImageAlphaBorder GetImageColor
   ImageClearBackground ImageDrawPixel ImageDrawPixelV
   ImageDrawLine ImageDrawLineV ImageDrawLineEx
   ImageDrawLineStrip ImageDrawTriangle
   ImageDrawTriangleGradient ImageDrawTriangleLines
   ImageDrawTriangleFan ImageDrawTriangleStrip
   ImageDrawRectangle ImageDrawRectangleV ImageDrawRectangleRec
   ImageDrawRectanglePro ImageDrawRectangleLines
   ImageDrawRectangleLinesEx ImageDrawRectangleGradientEx
   ImageDrawCircle ImageDrawCircleV ImageDrawCircleLines
   ImageDrawCircleLinesV ImageDrawCircleGradient ImageDrawImage
   ImageDrawImageEx ImageDrawImageRec ImageDrawImagePro
   ImageDrawText ImageDrawTextEx ImageDrawTextPro LoadTexture
   LoadTextureFromImage LoadTextureCubemap LoadRenderTexture
   LoadRenderTextureEx IsTextureValid UnloadTexture
   IsRenderTextureValid UnloadRenderTexture UpdateTexture
   UpdateTextureRec GenTextureMipmaps SetTextureFilter
   SetTextureWrap DrawTexture DrawTextureV DrawTextureEx
   DrawTextureRec DrawTexturePro DrawTextureNPatch ColorIsEqual
   Fade ColorToInt ColorNormalize ColorFromNormalized
   ColorToHSV ColorFromHSV ColorTint ColorBrightness
   ColorContrast ColorAlpha ColorAlphaBlend ColorLerp GetColor
   GetPixelColor SetPixelColor GetPixelDataSize GetFontDefault
   LoadFont LoadFontEx LoadFontFromImage LoadFontFromMemory
   IsFontValid LoadFontData GenImageFontAtlas UnloadFontData
   UnloadFont ExportFontAsCode DrawFPS DrawText DrawTextEx
   DrawTextPro DrawTextCodepoint DrawTextCodepoints
   SetTextLineSpacing MeasureText MeasureTextEx
   MeasureTextCodepoints GetGlyphIndex GetGlyphInfo
   GetGlyphAtlasRec LoadUTF8 UnloadUTF8 LoadCodepoints
   UnloadCodepoints GetCodepointCount GetCodepoint
   GetCodepointNext GetCodepointPrevious CodepointToUTF8
   LoadTextLines UnloadTextLines TextCopy TextIsEqual
   TextLength TextFormat TextSubtext TextRemoveSpaces
   GetTextBetween TextReplace TextReplaceAlloc
   TextReplaceBetween TextReplaceBetweenAlloc TextInsert
   TextInsertAlloc TextJoin TextSplit TextAppend TextFindIndex
   TextToUpper TextToLower TextToPascal TextToSnake TextToCamel
   TextToInteger TextToFloat DrawLine3D DrawPoint3D
   DrawCircle3D DrawTriangle3D DrawTriangleStrip3D DrawCube
   DrawCubeV DrawCubeWires DrawCubeWiresV DrawSphere
   DrawSphereEx DrawSphereWires DrawCylinder DrawCylinderEx
   DrawCylinderWires DrawCylinderWiresEx DrawCapsule
   DrawCapsuleWires DrawPlane DrawRay DrawGrid LoadModel
   LoadModelFromMesh IsModelValid UnloadModel
   GetModelBoundingBox DrawModel DrawModelEx DrawModelWires
   DrawModelWiresEx DrawBoundingBox DrawBillboard
   DrawBillboardRec DrawBillboardPro UploadMesh
   UpdateMeshBuffer UnloadMesh DrawMesh DrawMeshInstanced
   GetMeshBoundingBox GenMeshTangents ExportMesh
   ExportMeshAsCode GenMeshPoly GenMeshPlane GenMeshCube
   GenMeshSphere GenMeshHemiSphere GenMeshCylinder GenMeshCone
   GenMeshTorus GenMeshKnot GenMeshHeightmap GenMeshCubicmap
   LoadMaterials LoadMaterialDefault IsMaterialValid
   UnloadMaterial SetMaterialTexture SetModelMeshMaterial
   LoadModelAnimations UpdateModelAnimation
   UpdateModelAnimationEx UnloadModelAnimations
   IsModelAnimationValid CheckCollisionSpheres
   CheckCollisionBoxes CheckCollisionBoxSphere
   GetRayCollisionSphere GetRayCollisionBox GetRayCollisionMesh
   GetRayCollisionTriangle GetRayCollisionQuad InitAudioDevice
   CloseAudioDevice IsAudioDeviceReady SetMasterVolume
   GetMasterVolume LoadWave LoadWaveFromMemory IsWaveValid
   LoadSound LoadSoundFromWave LoadSoundAlias IsSoundValid
   UpdateSound UnloadWave UnloadSound UnloadSoundAlias
   ExportWave ExportWaveAsCode PlaySound StopSound PauseSound
   ResumeSound IsSoundPlaying SetSoundVolume SetSoundPitch
   SetSoundPan WaveCopy WaveCrop WaveFormat LoadWaveSamples
   UnloadWaveSamples LoadMusicStream LoadMusicStreamFromMemory
   IsMusicValid UnloadMusicStream PlayMusicStream
   IsMusicStreamPlaying UpdateMusicStream StopMusicStream
   PauseMusicStream ResumeMusicStream SeekMusicStream
   SetMusicVolume SetMusicPitch SetMusicPan GetMusicTimeLength
   GetMusicTimePlayed LoadAudioStream IsAudioStreamValid
   UnloadAudioStream UpdateAudioStream IsAudioStreamProcessed
   PlayAudioStream PauseAudioStream ResumeAudioStream
   IsAudioStreamPlaying StopAudioStream SetAudioStreamVolume
   SetAudioStreamPitch SetAudioStreamPan
   SetAudioStreamBufferSizeDefault SetAudioStreamCallback
   AttachAudioStreamProcessor DetachAudioStreamProcessor
   AttachAudioMixedProcessor DetachAudioMixedProcessor)
  (import (chezscheme))
  (define RAYLIB_VERSION_MAJOR 6)
  (define RAYLIB_VERSION_MINOR 5)
  (define RAYLIB_VERSION_PATCH 0)
  (define RAYLIB_VERSION "6.5-dev")
  (define PI 3.141592653589793)
  (define FLAG_VSYNC_HINT 64)
  (define FLAG_FULLSCREEN_MODE 2)
  (define FLAG_WINDOW_RESIZABLE 4)
  (define FLAG_WINDOW_UNDECORATED 8)
  (define FLAG_WINDOW_HIDDEN 128)
  (define FLAG_WINDOW_MINIMIZED 512)
  (define FLAG_WINDOW_MAXIMIZED 1024)
  (define FLAG_WINDOW_UNFOCUSED 2048)
  (define FLAG_WINDOW_TOPMOST 4096)
  (define FLAG_WINDOW_ALWAYS_RUN 256)
  (define FLAG_WINDOW_TRANSPARENT 16)
  (define FLAG_WINDOW_HIGHDPI 8192)
  (define FLAG_WINDOW_MOUSE_PASSTHROUGH 16384)
  (define FLAG_BORDERLESS_WINDOWED_MODE 32768)
  (define FLAG_MSAA_4X_HINT 32)
  (define FLAG_INTERLACED_HINT 65536)
  (define LOG_ALL 0)
  (define LOG_TRACE 1)
  (define LOG_DEBUG 2)
  (define LOG_INFO 3)
  (define LOG_WARNING 4)
  (define LOG_ERROR 5)
  (define LOG_FATAL 6)
  (define LOG_NONE 7)
  (define KEY_NULL 0)
  (define KEY_APOSTROPHE 39)
  (define KEY_COMMA 44)
  (define KEY_MINUS 45)
  (define KEY_PERIOD 46)
  (define KEY_SLASH 47)
  (define KEY_ZERO 48)
  (define KEY_ONE 49)
  (define KEY_TWO 50)
  (define KEY_THREE 51)
  (define KEY_FOUR 52)
  (define KEY_FIVE 53)
  (define KEY_SIX 54)
  (define KEY_SEVEN 55)
  (define KEY_EIGHT 56)
  (define KEY_NINE 57)
  (define KEY_SEMICOLON 59)
  (define KEY_EQUAL 61)
  (define KEY_A 65)
  (define KEY_B 66)
  (define KEY_C 67)
  (define KEY_D 68)
  (define KEY_E 69)
  (define KEY_F 70)
  (define KEY_G 71)
  (define KEY_H 72)
  (define KEY_I 73)
  (define KEY_J 74)
  (define KEY_K 75)
  (define KEY_L 76)
  (define KEY_M 77)
  (define KEY_N 78)
  (define KEY_O 79)
  (define KEY_P 80)
  (define KEY_Q 81)
  (define KEY_R 82)
  (define KEY_S 83)
  (define KEY_T 84)
  (define KEY_U 85)
  (define KEY_V 86)
  (define KEY_W 87)
  (define KEY_X 88)
  (define KEY_Y 89)
  (define KEY_Z 90)
  (define KEY_LEFT_BRACKET 91)
  (define KEY_BACKSLASH 92)
  (define KEY_RIGHT_BRACKET 93)
  (define KEY_GRAVE 96)
  (define KEY_SPACE 32)
  (define KEY_ESCAPE 256)
  (define KEY_ENTER 257)
  (define KEY_TAB 258)
  (define KEY_BACKSPACE 259)
  (define KEY_INSERT 260)
  (define KEY_DELETE 261)
  (define KEY_RIGHT 262)
  (define KEY_LEFT 263)
  (define KEY_DOWN 264)
  (define KEY_UP 265)
  (define KEY_PAGE_UP 266)
  (define KEY_PAGE_DOWN 267)
  (define KEY_HOME 268)
  (define KEY_END 269)
  (define KEY_CAPS_LOCK 280)
  (define KEY_SCROLL_LOCK 281)
  (define KEY_NUM_LOCK 282)
  (define KEY_PRINT_SCREEN 283)
  (define KEY_PAUSE 284)
  (define KEY_F1 290)
  (define KEY_F2 291)
  (define KEY_F3 292)
  (define KEY_F4 293)
  (define KEY_F5 294)
  (define KEY_F6 295)
  (define KEY_F7 296)
  (define KEY_F8 297)
  (define KEY_F9 298)
  (define KEY_F10 299)
  (define KEY_F11 300)
  (define KEY_F12 301)
  (define KEY_LEFT_SHIFT 340)
  (define KEY_LEFT_CONTROL 341)
  (define KEY_LEFT_ALT 342)
  (define KEY_LEFT_SUPER 343)
  (define KEY_RIGHT_SHIFT 344)
  (define KEY_RIGHT_CONTROL 345)
  (define KEY_RIGHT_ALT 346)
  (define KEY_RIGHT_SUPER 347)
  (define KEY_KB_MENU 348)
  (define KEY_KP_0 320)
  (define KEY_KP_1 321)
  (define KEY_KP_2 322)
  (define KEY_KP_3 323)
  (define KEY_KP_4 324)
  (define KEY_KP_5 325)
  (define KEY_KP_6 326)
  (define KEY_KP_7 327)
  (define KEY_KP_8 328)
  (define KEY_KP_9 329)
  (define KEY_KP_DECIMAL 330)
  (define KEY_KP_DIVIDE 331)
  (define KEY_KP_MULTIPLY 332)
  (define KEY_KP_SUBTRACT 333)
  (define KEY_KP_ADD 334)
  (define KEY_KP_ENTER 335)
  (define KEY_KP_EQUAL 336)
  (define KEY_BACK 4)
  (define KEY_MENU 5)
  (define KEY_VOLUME_UP 24)
  (define KEY_VOLUME_DOWN 25)
  (define MOUSE_BUTTON_LEFT 0)
  (define MOUSE_BUTTON_RIGHT 1)
  (define MOUSE_BUTTON_MIDDLE 2)
  (define MOUSE_BUTTON_SIDE 3)
  (define MOUSE_BUTTON_EXTRA 4)
  (define MOUSE_BUTTON_FORWARD 5)
  (define MOUSE_BUTTON_BACK 6)
  (define MOUSE_CURSOR_DEFAULT 0)
  (define MOUSE_CURSOR_ARROW 1)
  (define MOUSE_CURSOR_IBEAM 2)
  (define MOUSE_CURSOR_CROSSHAIR 3)
  (define MOUSE_CURSOR_POINTING_HAND 4)
  (define MOUSE_CURSOR_RESIZE_EW 5)
  (define MOUSE_CURSOR_RESIZE_NS 6)
  (define MOUSE_CURSOR_RESIZE_NWSE 7)
  (define MOUSE_CURSOR_RESIZE_NESW 8)
  (define MOUSE_CURSOR_RESIZE_ALL 9)
  (define MOUSE_CURSOR_NOT_ALLOWED 10)
  (define GAMEPAD_BUTTON_UNKNOWN 0)
  (define GAMEPAD_BUTTON_LEFT_FACE_UP 1)
  (define GAMEPAD_BUTTON_LEFT_FACE_RIGHT 2)
  (define GAMEPAD_BUTTON_LEFT_FACE_DOWN 3)
  (define GAMEPAD_BUTTON_LEFT_FACE_LEFT 4)
  (define GAMEPAD_BUTTON_RIGHT_FACE_UP 5)
  (define GAMEPAD_BUTTON_RIGHT_FACE_RIGHT 6)
  (define GAMEPAD_BUTTON_RIGHT_FACE_DOWN 7)
  (define GAMEPAD_BUTTON_RIGHT_FACE_LEFT 8)
  (define GAMEPAD_BUTTON_LEFT_TRIGGER_1 9)
  (define GAMEPAD_BUTTON_LEFT_TRIGGER_2 10)
  (define GAMEPAD_BUTTON_RIGHT_TRIGGER_1 11)
  (define GAMEPAD_BUTTON_RIGHT_TRIGGER_2 12)
  (define GAMEPAD_BUTTON_MIDDLE_LEFT 13)
  (define GAMEPAD_BUTTON_MIDDLE 14)
  (define GAMEPAD_BUTTON_MIDDLE_RIGHT 15)
  (define GAMEPAD_BUTTON_LEFT_THUMB 16)
  (define GAMEPAD_BUTTON_RIGHT_THUMB 17)
  (define GAMEPAD_AXIS_LEFT_X 0)
  (define GAMEPAD_AXIS_LEFT_Y 1)
  (define GAMEPAD_AXIS_RIGHT_X 2)
  (define GAMEPAD_AXIS_RIGHT_Y 3)
  (define GAMEPAD_AXIS_LEFT_TRIGGER 4)
  (define GAMEPAD_AXIS_RIGHT_TRIGGER 5)
  (define MATERIAL_MAP_ALBEDO 0)
  (define MATERIAL_MAP_METALNESS 1)
  (define MATERIAL_MAP_NORMAL 2)
  (define MATERIAL_MAP_ROUGHNESS 3)
  (define MATERIAL_MAP_OCCLUSION 4)
  (define MATERIAL_MAP_EMISSION 5)
  (define MATERIAL_MAP_HEIGHT 6)
  (define MATERIAL_MAP_CUBEMAP 7)
  (define MATERIAL_MAP_IRRADIANCE 8)
  (define MATERIAL_MAP_PREFILTER 9)
  (define MATERIAL_MAP_BRDF 10)
  (define SHADER_LOC_VERTEX_POSITION 0)
  (define SHADER_LOC_VERTEX_TEXCOORD01 1)
  (define SHADER_LOC_VERTEX_TEXCOORD02 2)
  (define SHADER_LOC_VERTEX_NORMAL 3)
  (define SHADER_LOC_VERTEX_TANGENT 4)
  (define SHADER_LOC_VERTEX_COLOR 5)
  (define SHADER_LOC_MATRIX_MVP 6)
  (define SHADER_LOC_MATRIX_VIEW 7)
  (define SHADER_LOC_MATRIX_PROJECTION 8)
  (define SHADER_LOC_MATRIX_MODEL 9)
  (define SHADER_LOC_MATRIX_NORMAL 10)
  (define SHADER_LOC_VECTOR_VIEW 11)
  (define SHADER_LOC_COLOR_DIFFUSE 12)
  (define SHADER_LOC_COLOR_SPECULAR 13)
  (define SHADER_LOC_COLOR_AMBIENT 14)
  (define SHADER_LOC_MAP_ALBEDO 15)
  (define SHADER_LOC_MAP_METALNESS 16)
  (define SHADER_LOC_MAP_NORMAL 17)
  (define SHADER_LOC_MAP_ROUGHNESS 18)
  (define SHADER_LOC_MAP_OCCLUSION 19)
  (define SHADER_LOC_MAP_EMISSION 20)
  (define SHADER_LOC_MAP_HEIGHT 21)
  (define SHADER_LOC_MAP_CUBEMAP 22)
  (define SHADER_LOC_MAP_IRRADIANCE 23)
  (define SHADER_LOC_MAP_PREFILTER 24)
  (define SHADER_LOC_MAP_BRDF 25)
  (define SHADER_LOC_VERTEX_BONEIDS 26)
  (define SHADER_LOC_VERTEX_BONEWEIGHTS 27)
  (define SHADER_LOC_MATRIX_BONETRANSFORMS 28)
  (define SHADER_LOC_VERTEX_INSTANCETRANSFORM 29)
  (define SHADER_UNIFORM_FLOAT 0)
  (define SHADER_UNIFORM_VEC2 1)
  (define SHADER_UNIFORM_VEC3 2)
  (define SHADER_UNIFORM_VEC4 3)
  (define SHADER_UNIFORM_INT 4)
  (define SHADER_UNIFORM_IVEC2 5)
  (define SHADER_UNIFORM_IVEC3 6)
  (define SHADER_UNIFORM_IVEC4 7)
  (define SHADER_UNIFORM_UINT 8)
  (define SHADER_UNIFORM_UIVEC2 9)
  (define SHADER_UNIFORM_UIVEC3 10)
  (define SHADER_UNIFORM_UIVEC4 11)
  (define SHADER_UNIFORM_SAMPLER2D 12)
  (define SHADER_ATTRIB_FLOAT 0)
  (define SHADER_ATTRIB_VEC2 1)
  (define SHADER_ATTRIB_VEC3 2)
  (define SHADER_ATTRIB_VEC4 3)
  (define PIXELFORMAT_UNCOMPRESSED_GRAYSCALE 1)
  (define PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA 2)
  (define PIXELFORMAT_UNCOMPRESSED_R5G6B5 3)
  (define PIXELFORMAT_UNCOMPRESSED_R8G8B8 4)
  (define PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 5)
  (define PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 6)
  (define PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 7)
  (define PIXELFORMAT_UNCOMPRESSED_R32 8)
  (define PIXELFORMAT_UNCOMPRESSED_R32G32B32 9)
  (define PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 10)
  (define PIXELFORMAT_UNCOMPRESSED_R16 11)
  (define PIXELFORMAT_UNCOMPRESSED_R16G16B16 12)
  (define PIXELFORMAT_UNCOMPRESSED_R16G16B16A16 13)
  (define PIXELFORMAT_COMPRESSED_DXT1_RGB 14)
  (define PIXELFORMAT_COMPRESSED_DXT1_RGBA 15)
  (define PIXELFORMAT_COMPRESSED_DXT3_RGBA 16)
  (define PIXELFORMAT_COMPRESSED_DXT5_RGBA 17)
  (define PIXELFORMAT_COMPRESSED_ETC1_RGB 18)
  (define PIXELFORMAT_COMPRESSED_ETC2_RGB 19)
  (define PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA 20)
  (define PIXELFORMAT_COMPRESSED_PVRT_RGB 21)
  (define PIXELFORMAT_COMPRESSED_PVRT_RGBA 22)
  (define PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA 23)
  (define PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA 24)
  (define TEXTURE_FILTER_POINT 0)
  (define TEXTURE_FILTER_BILINEAR 1)
  (define TEXTURE_FILTER_TRILINEAR 2)
  (define TEXTURE_FILTER_ANISOTROPIC_4X 3)
  (define TEXTURE_FILTER_ANISOTROPIC_8X 4)
  (define TEXTURE_FILTER_ANISOTROPIC_16X 5)
  (define TEXTURE_WRAP_REPEAT 0)
  (define TEXTURE_WRAP_CLAMP 1)
  (define TEXTURE_WRAP_MIRROR_REPEAT 2)
  (define TEXTURE_WRAP_MIRROR_CLAMP 3)
  (define CUBEMAP_LAYOUT_AUTO_DETECT 0)
  (define CUBEMAP_LAYOUT_LINE_VERTICAL 1)
  (define CUBEMAP_LAYOUT_LINE_HORIZONTAL 2)
  (define CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR 3)
  (define CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE 4)
  (define FONT_DEFAULT 0)
  (define FONT_BITMAP 1)
  (define FONT_SDF 2)
  (define BLEND_ALPHA 0)
  (define BLEND_ADDITIVE 1)
  (define BLEND_MULTIPLIED 2)
  (define BLEND_ADD_COLORS 3)
  (define BLEND_SUBTRACT_COLORS 4)
  (define BLEND_ALPHA_PREMULTIPLY 5)
  (define BLEND_CUSTOM 6)
  (define BLEND_CUSTOM_SEPARATE 7)
  (define GESTURE_NONE 0)
  (define GESTURE_TAP 1)
  (define GESTURE_DOUBLETAP 2)
  (define GESTURE_HOLD 4)
  (define GESTURE_DRAG 8)
  (define GESTURE_SWIPE_RIGHT 16)
  (define GESTURE_SWIPE_LEFT 32)
  (define GESTURE_SWIPE_UP 64)
  (define GESTURE_SWIPE_DOWN 128)
  (define GESTURE_PINCH_IN 256)
  (define GESTURE_PINCH_OUT 512)
  (define CAMERA_CUSTOM 0)
  (define CAMERA_FREE 1)
  (define CAMERA_ORBITAL 2)
  (define CAMERA_FIRST_PERSON 3)
  (define CAMERA_THIRD_PERSON 4)
  (define CAMERA_PERSPECTIVE 0)
  (define CAMERA_ORTHOGRAPHIC 1)
  (define NPATCH_NINE_PATCH 0)
  (define NPATCH_THREE_PATCH_VERTICAL 1)
  (define NPATCH_THREE_PATCH_HORIZONTAL 2)
  (define-ftype rAudioBuffer (struct))
  (define-ftype rAudioProcessor (struct))
  (define-ftype TraceLogCallback
    (function (integer-32 string void*) void))
  (define-ftype LoadFileDataCallback
    (function (string (* integer-32)) (* unsigned-8)))
  (define-ftype SaveFileDataCallback
    (function (string void* integer-32) stdbool))
  (define-ftype LoadFileTextCallback
    (function (string) string))
  (define-ftype SaveFileTextCallback
    (function (string string) stdbool))
  (define-ftype AudioCallback
    (function (void* unsigned-32) void))
  (define-ftype Vector2
    (struct [x single-float] [y single-float]))
  (define-ftype Vector3
    (struct [x single-float] [y single-float] [z single-float]))
  (define-ftype Vector4
    (struct
      [x single-float]
      [y single-float]
      [z single-float]
      [w single-float]))
  (alias Quaternion Vector4)
  (define-ftype Matrix
    (struct
      [m0 single-float]
      [m4 single-float]
      [m8 single-float]
      [m12 single-float]
      [m1 single-float]
      [m5 single-float]
      [m9 single-float]
      [m13 single-float]
      [m2 single-float]
      [m6 single-float]
      [m10 single-float]
      [m14 single-float]
      [m3 single-float]
      [m7 single-float]
      [m11 single-float]
      [m15 single-float]))
  (define-ftype Color
    (struct
      [r unsigned-8]
      [g unsigned-8]
      [b unsigned-8]
      [a unsigned-8]))
  (define-ftype Rectangle
    (struct
      [x single-float]
      [y single-float]
      [width single-float]
      [height single-float]))
  (define-ftype Image
    (struct
      [data void*]
      [width integer-32]
      [height integer-32]
      [mipmaps integer-32]
      [format integer-32]))
  (define-ftype Texture
    (struct
      [id unsigned-32]
      [width integer-32]
      [height integer-32]
      [mipmaps integer-32]
      [format integer-32]))
  (alias Texture2D Texture)
  (alias TextureCubemap Texture)
  (define-ftype RenderTexture
    (struct [id unsigned-32] [texture Texture] [depth Texture]))
  (alias RenderTexture2D RenderTexture)
  (define-ftype NPatchInfo
    (struct
      [source Rectangle]
      [left integer-32]
      [top integer-32]
      [right integer-32]
      [bottom integer-32]
      [layout integer-32]))
  (define-ftype GlyphInfo
    (struct
      [value integer-32]
      [offsetX integer-32]
      [offsetY integer-32]
      [advanceX integer-32]
      [image Image]))
  (define-ftype Font
    (struct
      [baseSize integer-32]
      [glyphCount integer-32]
      [glyphPadding integer-32]
      [texture Texture2D]
      [recs (* Rectangle)]
      [glyphs (* GlyphInfo)]))
  (define-ftype Camera3D
    (struct
      [position Vector3]
      [target Vector3]
      [up Vector3]
      [fovy single-float]
      [projection integer-32]))
  (alias Camera Camera3D)
  (define-ftype Camera2D
    (struct
      [offset Vector2]
      [target Vector2]
      [rotation single-float]
      [zoom single-float]))
  (define-ftype Mesh
    (struct
      [vertexCount integer-32]
      [triangleCount integer-32]
      [vertices (* single-float)]
      [texcoords (* single-float)]
      [texcoords2 (* single-float)]
      [normals (* single-float)]
      [tangents (* single-float)]
      [colors (* unsigned-8)]
      [indices (* unsigned-16)]
      [boneCount integer-32]
      [boneIndices (* unsigned-8)]
      [boneWeights (* single-float)]
      [animVertices (* single-float)]
      [animNormals (* single-float)]
      [vaoId unsigned-32]
      [vboId (* unsigned-32)]))
  (define-ftype Shader
    (struct [id unsigned-32] [locs (* integer-32)]))
  (define-ftype MaterialMap
    (struct
      [texture Texture2D]
      [color Color]
      [value single-float]))
  (define-ftype Material
    (struct
      [shader Shader]
      [maps (* MaterialMap)]
      [params (array 4 single-float)]))
  (define-ftype Transform
    (struct
      [translation Vector3]
      [rotation Quaternion]
      [scale Vector3]))
  (define-ftype ModelAnimPose (* Transform))
  (define-ftype BoneInfo
    (struct [name (array 32 char)] [parent integer-32]))
  (define-ftype ModelSkeleton
    (struct
      [boneCount unsigned-32]
      [bones (* BoneInfo)]
      [bindPose ModelAnimPose]))
  (define-ftype Model
    (struct
      [transform Matrix]
      [meshCount integer-32]
      [materialCount integer-32]
      [meshes (* Mesh)]
      [materials (* Material)]
      [meshMaterial (* integer-32)]
      [skeleton ModelSkeleton]
      [currentPose ModelAnimPose]
      [boneMatrices (* Matrix)]))
  (define-ftype ModelAnimation
    (struct
      [name (array 32 char)]
      [boneCount unsigned-32]
      [keyframeCount integer-32]
      [keyframePoses (* ModelAnimPose)]))
  (define-ftype Ray
    (struct [position Vector3] [direction Vector3]))
  (define-ftype RayCollision
    (struct
      [hit boolean]
      [distance single-float]
      [point Vector3]
      [normal Vector3]))
  (define-ftype BoundingBox
    (struct [min Vector3] [max Vector3]))
  (define-ftype Wave
    (struct
      [frameCount unsigned-32]
      [sampleRate unsigned-32]
      [sampleSize unsigned-32]
      [channels unsigned-32]
      [data void*]))
  (define-ftype AudioStream
    (struct
      [buffer (* rAudioBuffer)]
      [processor (* rAudioProcessor)]
      [sampleRate unsigned-32]
      [sampleSize unsigned-32]
      [channels unsigned-32]))
  (define-ftype Sound
    (struct [stream AudioStream] [frameCount unsigned-32]))
  (define-ftype Music
    (struct
      [stream AudioStream]
      [frameCount unsigned-32]
      [looping boolean]
      [ctxType integer-32]
      [ctxData void*]))
  (define-ftype VrDeviceInfo
    (struct
      [hResolution integer-32]
      [vResolution integer-32]
      [hScreenSize single-float]
      [vScreenSize single-float]
      [eyeToScreenDistance single-float]
      [lensSeparationDistance single-float]
      [interpupillaryDistance single-float]
      [lensDistortionValues (array 4 single-float)]
      [chromaAbCorrection (array 4 single-float)]))
  (define-ftype VrStereoConfig
    (struct
      [projection (array 2 Matrix)]
      [viewOffset (array 2 Matrix)]
      [leftLensCenter (array 2 single-float)]
      [rightLensCenter (array 2 single-float)]
      [leftScreenCenter (array 2 single-float)]
      [rightScreenCenter (array 2 single-float)]
      [scale (array 2 single-float)]
      [scaleIn (array 2 single-float)]))
  (define-ftype FilePathList
    (struct [count unsigned-32] [paths (* (* char))]))
  (define-ftype AutomationEvent
    (struct
      [frame unsigned-32]
      [type unsigned-32]
      [params (array 4 integer-32)]))
  (define-ftype AutomationEventList
    (struct
      [capacity unsigned-32]
      [count unsigned-32]
      [events (* AutomationEvent)]))
  (define-ftype *char (* char))
  (define-ftype *Rectangle (* Rectangle))
  (define InitWindow
    (let ([f #f])
      (lambda (width height title)
        (unless f
          (set! f
            (foreign-procedure #f "InitWindow"
              (integer-32 integer-32 string)
              void)))
        (f width height title))))
  (define CloseWindow
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "CloseWindow" () void)))
        (f))))
  (define WindowShouldClose
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "WindowShouldClose" () stdbool)))
        (f))))
  (define IsWindowReady
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "IsWindowReady" () stdbool)))
        (f))))
  (define IsWindowFullscreen
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "IsWindowFullscreen" () stdbool)))
        (f))))
  (define IsWindowHidden
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "IsWindowHidden" () stdbool)))
        (f))))
  (define IsWindowMinimized
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "IsWindowMinimized" () stdbool)))
        (f))))
  (define IsWindowMaximized
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "IsWindowMaximized" () stdbool)))
        (f))))
  (define IsWindowFocused
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "IsWindowFocused" () stdbool)))
        (f))))
  (define IsWindowResized
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "IsWindowResized" () stdbool)))
        (f))))
  (define IsWindowState
    (let ([f #f])
      (lambda (flag)
        (unless f
          (set! f
            (foreign-procedure #f "IsWindowState"
              (unsigned-32)
              stdbool)))
        (f flag))))
  (define SetWindowState
    (let ([f #f])
      (lambda (flags)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowState" (unsigned-32) void)))
        (f flags))))
  (define ClearWindowState
    (let ([f #f])
      (lambda (flags)
        (unless f
          (set! f
            (foreign-procedure #f "ClearWindowState"
              (unsigned-32)
              void)))
        (f flags))))
  (define ToggleFullscreen
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "ToggleFullscreen" () void)))
        (f))))
  (define ToggleBorderlessWindowed
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "ToggleBorderlessWindowed" () void)))
        (f))))
  (define MaximizeWindow
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "MaximizeWindow" () void)))
        (f))))
  (define MinimizeWindow
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "MinimizeWindow" () void)))
        (f))))
  (define RestoreWindow
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "RestoreWindow" () void)))
        (f))))
  (define SetWindowIcon
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowIcon" ((& Image)) void)))
        (f image))))
  (define SetWindowIcons
    (let ([f #f])
      (lambda (images count)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowIcons"
              ((* Image) integer-32)
              void)))
        (f images count))))
  (define SetWindowTitle
    (let ([f #f])
      (lambda (title)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowTitle" (string) void)))
        (f title))))
  (define SetWindowPosition
    (let ([f #f])
      (lambda (x y)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowPosition"
              (integer-32 integer-32)
              void)))
        (f x y))))
  (define SetWindowMonitor
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowMonitor"
              (integer-32)
              void)))
        (f monitor))))
  (define SetWindowMinSize
    (let ([f #f])
      (lambda (width height)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowMinSize"
              (integer-32 integer-32)
              void)))
        (f width height))))
  (define SetWindowMaxSize
    (let ([f #f])
      (lambda (width height)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowMaxSize"
              (integer-32 integer-32)
              void)))
        (f width height))))
  (define SetWindowSize
    (let ([f #f])
      (lambda (width height)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowSize"
              (integer-32 integer-32)
              void)))
        (f width height))))
  (define SetWindowOpacity
    (let ([f #f])
      (lambda (opacity)
        (unless f
          (set! f
            (foreign-procedure #f "SetWindowOpacity"
              (single-float)
              void)))
        (f opacity))))
  (define SetWindowFocused
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "SetWindowFocused" () void)))
        (f))))
  (define GetWindowHandle
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "GetWindowHandle" () void*)))
        (f))))
  (define GetScreenWidth
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetScreenWidth" () integer-32)))
        (f))))
  (define GetScreenHeight
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetScreenHeight" () integer-32)))
        (f))))
  (define GetRenderWidth
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetRenderWidth" () integer-32)))
        (f))))
  (define GetRenderHeight
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetRenderHeight" () integer-32)))
        (f))))
  (define GetMonitorCount
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorCount" () integer-32)))
        (f))))
  (define GetCurrentMonitor
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetCurrentMonitor" () integer-32)))
        (f))))
  (define GetMonitorPosition
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorPosition"
              (integer-32)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res monitor)
          ret-res))))
  (define GetMonitorWidth
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorWidth"
              (integer-32)
              integer-32)))
        (f monitor))))
  (define GetMonitorHeight
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorHeight"
              (integer-32)
              integer-32)))
        (f monitor))))
  (define GetMonitorPhysicalWidth
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorPhysicalWidth"
              (integer-32)
              integer-32)))
        (f monitor))))
  (define GetMonitorPhysicalHeight
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorPhysicalHeight"
              (integer-32)
              integer-32)))
        (f monitor))))
  (define GetMonitorRefreshRate
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorRefreshRate"
              (integer-32)
              integer-32)))
        (f monitor))))
  (define GetWindowPosition
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetWindowPosition" () (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res)
          ret-res))))
  (define GetWindowScaleDPI
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetWindowScaleDPI" () (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res)
          ret-res))))
  (define GetMonitorName
    (let ([f #f])
      (lambda (monitor)
        (unless f
          (set! f
            (foreign-procedure #f "GetMonitorName"
              (integer-32)
              string)))
        (f monitor))))
  (define SetClipboardText
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "SetClipboardText" (string) void)))
        (f text))))
  (define GetClipboardText
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetClipboardText" () string)))
        (f))))
  (define GetClipboardImage
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetClipboardImage" () (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res)
          ret-res))))
  (define EnableEventWaiting
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "EnableEventWaiting" () void)))
        (f))))
  (define DisableEventWaiting
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "DisableEventWaiting" () void)))
        (f))))
  (define ShowCursor
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "ShowCursor" () void)))
        (f))))
  (define HideCursor
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "HideCursor" () void)))
        (f))))
  (define IsCursorHidden
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "IsCursorHidden" () stdbool)))
        (f))))
  (define EnableCursor
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EnableCursor" () void)))
        (f))))
  (define DisableCursor
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "DisableCursor" () void)))
        (f))))
  (define IsCursorOnScreen
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "IsCursorOnScreen" () stdbool)))
        (f))))
  (define ClearBackground
    (let ([f #f])
      (lambda (color)
        (unless f
          (set! f
            (foreign-procedure #f "ClearBackground" ((& Color)) void)))
        (f color))))
  (define BeginDrawing
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "BeginDrawing" () void)))
        (f))))
  (define EndDrawing
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndDrawing" () void)))
        (f))))
  (define BeginMode2D
    (let ([f #f])
      (lambda (camera)
        (unless f
          (set! f
            (foreign-procedure #f "BeginMode2D" ((& Camera2D)) void)))
        (f camera))))
  (define EndMode2D
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndMode2D" () void)))
        (f))))
  (define BeginMode3D
    (let ([f #f])
      (lambda (camera)
        (unless f
          (set! f
            (foreign-procedure #f "BeginMode3D" ((& Camera3D)) void)))
        (f camera))))
  (define EndMode3D
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndMode3D" () void)))
        (f))))
  (define BeginTextureMode
    (let ([f #f])
      (lambda (target)
        (unless f
          (set! f
            (foreign-procedure #f "BeginTextureMode"
              ((& RenderTexture2D))
              void)))
        (f target))))
  (define EndTextureMode
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndTextureMode" () void)))
        (f))))
  (define BeginShaderMode
    (let ([f #f])
      (lambda (shader)
        (unless f
          (set! f
            (foreign-procedure #f "BeginShaderMode" ((& Shader)) void)))
        (f shader))))
  (define EndShaderMode
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndShaderMode" () void)))
        (f))))
  (define BeginBlendMode
    (let ([f #f])
      (lambda (mode)
        (unless f
          (set! f
            (foreign-procedure #f "BeginBlendMode" (integer-32) void)))
        (f mode))))
  (define EndBlendMode
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndBlendMode" () void)))
        (f))))
  (define BeginScissorMode
    (let ([f #f])
      (lambda (x y width height)
        (unless f
          (set! f
            (foreign-procedure #f "BeginScissorMode"
              (integer-32 integer-32 integer-32 integer-32)
              void)))
        (f x y width height))))
  (define EndScissorMode
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndScissorMode" () void)))
        (f))))
  (define BeginVrStereoMode
    (let ([f #f])
      (lambda (config)
        (unless f
          (set! f
            (foreign-procedure #f "BeginVrStereoMode"
              ((& VrStereoConfig))
              void)))
        (f config))))
  (define EndVrStereoMode
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "EndVrStereoMode" () void)))
        (f))))
  (define LoadVrStereoConfig
    (let ([f #f])
      (lambda (device)
        (unless f
          (set! f
            (foreign-procedure #f "LoadVrStereoConfig"
              ((& VrDeviceInfo))
              (& VrStereoConfig))))
        (let ([ret-res (make-ftype-pointer
                         VrStereoConfig
                         (foreign-alloc (ftype-sizeof VrStereoConfig)))])
          (f ret-res device)
          ret-res))))
  (define UnloadVrStereoConfig
    (let ([f #f])
      (lambda (config)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadVrStereoConfig"
              ((& VrStereoConfig))
              void)))
        (f config))))
  (define LoadShader
    (let ([f #f])
      (lambda (vsFileName fsFileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadShader"
              (string string)
              (& Shader))))
        (let ([ret-res (make-ftype-pointer
                         Shader
                         (foreign-alloc (ftype-sizeof Shader)))])
          (f ret-res vsFileName fsFileName)
          ret-res))))
  (define LoadShaderFromMemory
    (let ([f #f])
      (lambda (vsCode fsCode)
        (unless f
          (set! f
            (foreign-procedure #f "LoadShaderFromMemory"
              (string string)
              (& Shader))))
        (let ([ret-res (make-ftype-pointer
                         Shader
                         (foreign-alloc (ftype-sizeof Shader)))])
          (f ret-res vsCode fsCode)
          ret-res))))
  (define IsShaderValid
    (let ([f #f])
      (lambda (shader)
        (unless f
          (set! f
            (foreign-procedure #f "IsShaderValid"
              ((& Shader))
              stdbool)))
        (f shader))))
  (define GetShaderLocation
    (let ([f #f])
      (lambda (shader uniformName)
        (unless f
          (set! f
            (foreign-procedure #f "GetShaderLocation"
              ((& Shader) string)
              integer-32)))
        (f shader uniformName))))
  (define GetShaderLocationAttrib
    (let ([f #f])
      (lambda (shader attribName)
        (unless f
          (set! f
            (foreign-procedure #f "GetShaderLocationAttrib"
              ((& Shader) string)
              integer-32)))
        (f shader attribName))))
  (define SetShaderValue
    (let ([f #f])
      (lambda (shader locIndex value uniformType)
        (unless f
          (set! f
            (foreign-procedure #f "SetShaderValue"
              ((& Shader) integer-32 void* integer-32)
              void)))
        (f shader locIndex value uniformType))))
  (define SetShaderValueV
    (let ([f #f])
      (lambda (shader locIndex value uniformType count)
        (unless f
          (set! f
            (foreign-procedure #f "SetShaderValueV"
              ((& Shader) integer-32 void* integer-32 integer-32)
              void)))
        (f shader locIndex value uniformType count))))
  (define SetShaderValueMatrix
    (let ([f #f])
      (lambda (shader locIndex mat)
        (unless f
          (set! f
            (foreign-procedure #f "SetShaderValueMatrix"
              ((& Shader) integer-32 (& Matrix))
              void)))
        (f shader locIndex mat))))
  (define SetShaderValueTexture
    (let ([f #f])
      (lambda (shader locIndex texture)
        (unless f
          (set! f
            (foreign-procedure #f "SetShaderValueTexture"
              ((& Shader) integer-32 (& Texture2D))
              void)))
        (f shader locIndex texture))))
  (define UnloadShader
    (let ([f #f])
      (lambda (shader)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadShader" ((& Shader)) void)))
        (f shader))))
  (define GetScreenToWorldRay
    (let ([f #f])
      (lambda (position camera)
        (unless f
          (set! f
            (foreign-procedure #f "GetScreenToWorldRay"
              ((& Vector2) (& Camera))
              (& Ray))))
        (let ([ret-res (make-ftype-pointer
                         Ray
                         (foreign-alloc (ftype-sizeof Ray)))])
          (f ret-res position camera)
          ret-res))))
  (define GetScreenToWorldRayEx
    (let ([f #f])
      (lambda (position camera width height)
        (unless f
          (set! f
            (foreign-procedure #f "GetScreenToWorldRayEx"
              ((& Vector2) (& Camera) integer-32 integer-32)
              (& Ray))))
        (let ([ret-res (make-ftype-pointer
                         Ray
                         (foreign-alloc (ftype-sizeof Ray)))])
          (f ret-res position camera width height)
          ret-res))))
  (define GetWorldToScreen
    (let ([f #f])
      (lambda (position camera)
        (unless f
          (set! f
            (foreign-procedure #f "GetWorldToScreen"
              ((& Vector3) (& Camera))
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res position camera)
          ret-res))))
  (define GetWorldToScreenEx
    (let ([f #f])
      (lambda (position camera width height)
        (unless f
          (set! f
            (foreign-procedure #f "GetWorldToScreenEx"
              ((& Vector3) (& Camera) integer-32 integer-32)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res position camera width height)
          ret-res))))
  (define GetWorldToScreen2D
    (let ([f #f])
      (lambda (position camera)
        (unless f
          (set! f
            (foreign-procedure #f "GetWorldToScreen2D"
              ((& Vector2) (& Camera2D))
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res position camera)
          ret-res))))
  (define GetScreenToWorld2D
    (let ([f #f])
      (lambda (position camera)
        (unless f
          (set! f
            (foreign-procedure #f "GetScreenToWorld2D"
              ((& Vector2) (& Camera2D))
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res position camera)
          ret-res))))
  (define GetCameraMatrix
    (let ([f #f])
      (lambda (camera)
        (unless f
          (set! f
            (foreign-procedure #f "GetCameraMatrix"
              ((& Camera))
              (& Matrix))))
        (let ([ret-res (make-ftype-pointer
                         Matrix
                         (foreign-alloc (ftype-sizeof Matrix)))])
          (f ret-res camera)
          ret-res))))
  (define GetCameraMatrix2D
    (let ([f #f])
      (lambda (camera)
        (unless f
          (set! f
            (foreign-procedure #f "GetCameraMatrix2D"
              ((& Camera2D))
              (& Matrix))))
        (let ([ret-res (make-ftype-pointer
                         Matrix
                         (foreign-alloc (ftype-sizeof Matrix)))])
          (f ret-res camera)
          ret-res))))
  (define SetTargetFPS
    (let ([f #f])
      (lambda (fps)
        (unless f
          (set! f
            (foreign-procedure #f "SetTargetFPS" (integer-32) void)))
        (f fps))))
  (define GetFrameTime
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetFrameTime" () single-float)))
        (f))))
  (define GetTime
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "GetTime" () double-float)))
        (f))))
  (define GetFPS
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "GetFPS" () integer-32)))
        (f))))
  (define SwapScreenBuffer
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "SwapScreenBuffer" () void)))
        (f))))
  (define PollInputEvents
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "PollInputEvents" () void)))
        (f))))
  (define WaitTime
    (let ([f #f])
      (lambda (seconds)
        (unless f
          (set! f
            (foreign-procedure #f "WaitTime" (double-float) void)))
        (f seconds))))
  (define SetRandomSeed
    (let ([f #f])
      (lambda (seed)
        (unless f
          (set! f
            (foreign-procedure #f "SetRandomSeed" (unsigned-32) void)))
        (f seed))))
  (define GetRandomValue
    (let ([f #f])
      (lambda (min max)
        (unless f
          (set! f
            (foreign-procedure #f "GetRandomValue"
              (integer-32 integer-32)
              integer-32)))
        (f min max))))
  (define LoadRandomSequence
    (let ([f #f])
      (lambda (count min max)
        (unless f
          (set! f
            (foreign-procedure #f "LoadRandomSequence"
              (unsigned-32 integer-32 integer-32)
              (* integer-32))))
        (f count min max))))
  (define UnloadRandomSequence
    (let ([f #f])
      (lambda (sequence)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadRandomSequence"
              ((* integer-32))
              void)))
        (f sequence))))
  (define TakeScreenshot
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "TakeScreenshot" (string) void)))
        (f fileName))))
  (define SetConfigFlags
    (let ([f #f])
      (lambda (flags)
        (unless f
          (set! f
            (foreign-procedure #f "SetConfigFlags" (unsigned-32) void)))
        (f flags))))
  (define OpenURL
    (let ([f #f])
      (lambda (url)
        (unless f
          (set! f (foreign-procedure #f "OpenURL" (string) void)))
        (f url))))
  (define SetTraceLogLevel
    (let ([f #f])
      (lambda (logLevel)
        (unless f
          (set! f
            (foreign-procedure #f "SetTraceLogLevel"
              (integer-32)
              void)))
        (f logLevel))))
  (define TraceLog
    (let ([f #f])
      (lambda (logLevel text)
        (unless f
          (set! f
            (foreign-procedure #f "TraceLog" (integer-32 string) void)))
        (f logLevel text))))
  (define SetTraceLogCallback
    (let ([f #f])
      (lambda (callback)
        (unless f
          (set! f
            (foreign-procedure #f "SetTraceLogCallback" (void*) void)))
        (f callback))))
  (define MemAlloc
    (let ([f #f])
      (lambda (size)
        (unless f
          (set! f
            (foreign-procedure #f "MemAlloc" (unsigned-32) void*)))
        (f size))))
  (define MemRealloc
    (let ([f #f])
      (lambda (ptr size)
        (unless f
          (set! f
            (foreign-procedure #f "MemRealloc"
              (void* unsigned-32)
              void*)))
        (f ptr size))))
  (define MemFree
    (let ([f #f])
      (lambda (ptr)
        (unless f
          (set! f (foreign-procedure #f "MemFree" (void*) void)))
        (f ptr))))
  (define LoadFileData
    (let ([f #f])
      (lambda (fileName dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "LoadFileData"
              (string (* integer-32))
              (* unsigned-8))))
        (f fileName dataSize))))
  (define UnloadFileData
    (let ([f #f])
      (lambda (data)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadFileData"
              ((* unsigned-8))
              void)))
        (f data))))
  (define SaveFileData
    (let ([f #f])
      (lambda (fileName data dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "SaveFileData"
              (string void* integer-32)
              stdbool)))
        (f fileName data dataSize))))
  (define ExportDataAsCode
    (let ([f #f])
      (lambda (data dataSize fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportDataAsCode"
              ((* unsigned-8) integer-32 string)
              stdbool)))
        (f data dataSize fileName))))
  (define LoadFileText
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadFileText" (string) string)))
        (f fileName))))
  (define UnloadFileText
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadFileText" (string) void)))
        (f text))))
  (define SaveFileText
    (let ([f #f])
      (lambda (fileName text)
        (unless f
          (set! f
            (foreign-procedure #f "SaveFileText"
              (string string)
              stdbool)))
        (f fileName text))))
  (define SetLoadFileDataCallback
    (let ([f #f])
      (lambda (callback)
        (unless f
          (set! f
            (foreign-procedure #f "SetLoadFileDataCallback"
              (void*)
              void)))
        (f callback))))
  (define SetSaveFileDataCallback
    (let ([f #f])
      (lambda (callback)
        (unless f
          (set! f
            (foreign-procedure #f "SetSaveFileDataCallback"
              (void*)
              void)))
        (f callback))))
  (define SetLoadFileTextCallback
    (let ([f #f])
      (lambda (callback)
        (unless f
          (set! f
            (foreign-procedure #f "SetLoadFileTextCallback"
              (void*)
              void)))
        (f callback))))
  (define SetSaveFileTextCallback
    (let ([f #f])
      (lambda (callback)
        (unless f
          (set! f
            (foreign-procedure #f "SetSaveFileTextCallback"
              (void*)
              void)))
        (f callback))))
  (define FileRename
    (let ([f #f])
      (lambda (fileName fileRename)
        (unless f
          (set! f
            (foreign-procedure #f "FileRename"
              (string string)
              integer-32)))
        (f fileName fileRename))))
  (define FileRemove
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "FileRemove" (string) integer-32)))
        (f fileName))))
  (define FileCopy
    (let ([f #f])
      (lambda (srcPath dstPath)
        (unless f
          (set! f
            (foreign-procedure #f "FileCopy"
              (string string)
              integer-32)))
        (f srcPath dstPath))))
  (define FileMove
    (let ([f #f])
      (lambda (srcPath dstPath)
        (unless f
          (set! f
            (foreign-procedure #f "FileMove"
              (string string)
              integer-32)))
        (f srcPath dstPath))))
  (define FileTextReplace
    (let ([f #f])
      (lambda (fileName search replacement)
        (unless f
          (set! f
            (foreign-procedure #f "FileTextReplace"
              (string string string)
              integer-32)))
        (f fileName search replacement))))
  (define FileTextFindIndex
    (let ([f #f])
      (lambda (fileName search)
        (unless f
          (set! f
            (foreign-procedure #f "FileTextFindIndex"
              (string string)
              integer-32)))
        (f fileName search))))
  (define FileExists
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "FileExists" (string) stdbool)))
        (f fileName))))
  (define DirectoryExists
    (let ([f #f])
      (lambda (dirPath)
        (unless f
          (set! f
            (foreign-procedure #f "DirectoryExists" (string) stdbool)))
        (f dirPath))))
  (define IsFileExtension
    (let ([f #f])
      (lambda (fileName ext)
        (unless f
          (set! f
            (foreign-procedure #f "IsFileExtension"
              (string string)
              stdbool)))
        (f fileName ext))))
  (define IsFileHidden
    (let ([f #f])
      (lambda (filePath)
        (unless f
          (set! f
            (foreign-procedure #f "IsFileHidden" (string) stdbool)))
        (f filePath))))
  (define GetFileLength
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "GetFileLength" (string) integer-32)))
        (f fileName))))
  (define GetFileModTime
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "GetFileModTime" (string) long)))
        (f fileName))))
  (define GetFileExtension
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "GetFileExtension" (string) string)))
        (f fileName))))
  (define GetFileName
    (let ([f #f])
      (lambda (filePath)
        (unless f
          (set! f
            (foreign-procedure #f "GetFileName" (string) string)))
        (f filePath))))
  (define GetFileNameWithoutExt
    (let ([f #f])
      (lambda (filePath)
        (unless f
          (set! f
            (foreign-procedure #f "GetFileNameWithoutExt"
              (string)
              string)))
        (f filePath))))
  (define GetDirectoryPath
    (let ([f #f])
      (lambda (filePath)
        (unless f
          (set! f
            (foreign-procedure #f "GetDirectoryPath" (string) string)))
        (f filePath))))
  (define GetPrevDirectoryPath
    (let ([f #f])
      (lambda (dirPath)
        (unless f
          (set! f
            (foreign-procedure #f "GetPrevDirectoryPath"
              (string)
              string)))
        (f dirPath))))
  (define GetWorkingDirectory
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetWorkingDirectory" () string)))
        (f))))
  (define GetApplicationDirectory
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetApplicationDirectory" () string)))
        (f))))
  (define MakeDirectory
    (let ([f #f])
      (lambda (dirPath)
        (unless f
          (set! f
            (foreign-procedure #f "MakeDirectory" (string) integer-32)))
        (f dirPath))))
  (define ChangeDirectory
    (let ([f #f])
      (lambda (dirPath)
        (unless f
          (set! f
            (foreign-procedure #f "ChangeDirectory"
              (string)
              integer-32)))
        (f dirPath))))
  (define IsPathFile
    (let ([f #f])
      (lambda (path)
        (unless f
          (set! f
            (foreign-procedure #f "IsPathFile" (string) stdbool)))
        (f path))))
  (define IsPathDirectory
    (let ([f #f])
      (lambda (path)
        (unless f
          (set! f
            (foreign-procedure #f "IsPathDirectory" (string) stdbool)))
        (f path))))
  (define IsPathAbsolute
    (let ([f #f])
      (lambda (path)
        (unless f
          (set! f
            (foreign-procedure #f "IsPathAbsolute" (string) stdbool)))
        (f path))))
  (define IsFileNameValid
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "IsFileNameValid" (string) stdbool)))
        (f fileName))))
  (define LoadDirectoryFiles
    (let ([f #f])
      (lambda (dirPath)
        (unless f
          (set! f
            (foreign-procedure #f "LoadDirectoryFiles"
              (string)
              (& FilePathList))))
        (let ([ret-res (make-ftype-pointer
                         FilePathList
                         (foreign-alloc (ftype-sizeof FilePathList)))])
          (f ret-res dirPath)
          ret-res))))
  (define LoadDirectoryFilesEx
    (let ([f #f])
      (lambda (basePath filter scanSubdirs)
        (unless f
          (set! f
            (foreign-procedure #f "LoadDirectoryFilesEx"
              (string string stdbool)
              (& FilePathList))))
        (let ([ret-res (make-ftype-pointer
                         FilePathList
                         (foreign-alloc (ftype-sizeof FilePathList)))])
          (f ret-res basePath filter scanSubdirs)
          ret-res))))
  (define UnloadDirectoryFiles
    (let ([f #f])
      (lambda (files)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadDirectoryFiles"
              ((& FilePathList))
              void)))
        (f files))))
  (define IsFileDropped
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "IsFileDropped" () stdbool)))
        (f))))
  (define LoadDroppedFiles
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "LoadDroppedFiles"
              ()
              (& FilePathList))))
        (let ([ret-res (make-ftype-pointer
                         FilePathList
                         (foreign-alloc (ftype-sizeof FilePathList)))])
          (f ret-res)
          ret-res))))
  (define UnloadDroppedFiles
    (let ([f #f])
      (lambda (files)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadDroppedFiles"
              ((& FilePathList))
              void)))
        (f files))))
  (define GetDirectoryFileCount
    (let ([f #f])
      (lambda (dirPath)
        (unless f
          (set! f
            (foreign-procedure #f "GetDirectoryFileCount"
              (string)
              unsigned-32)))
        (f dirPath))))
  (define GetDirectoryFileCountEx
    (let ([f #f])
      (lambda (basePath filter scanSubdirs)
        (unless f
          (set! f
            (foreign-procedure #f "GetDirectoryFileCountEx"
              (string string stdbool)
              unsigned-32)))
        (f basePath filter scanSubdirs))))
  (define CompressData
    (let ([f #f])
      (lambda (data dataSize compDataSize)
        (unless f
          (set! f
            (foreign-procedure #f "CompressData"
              ((* unsigned-8) integer-32 (* integer-32))
              (* unsigned-8))))
        (f data dataSize compDataSize))))
  (define DecompressData
    (let ([f #f])
      (lambda (compData compDataSize dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "DecompressData"
              ((* unsigned-8) integer-32 (* integer-32))
              (* unsigned-8))))
        (f compData compDataSize dataSize))))
  (define EncodeDataBase64
    (let ([f #f])
      (lambda (data dataSize outputSize)
        (unless f
          (set! f
            (foreign-procedure #f "EncodeDataBase64"
              ((* unsigned-8) integer-32 (* integer-32))
              string)))
        (f data dataSize outputSize))))
  (define DecodeDataBase64
    (let ([f #f])
      (lambda (text outputSize)
        (unless f
          (set! f
            (foreign-procedure #f "DecodeDataBase64"
              (string (* integer-32))
              (* unsigned-8))))
        (f text outputSize))))
  (define ComputeCRC32
    (let ([f #f])
      (lambda (data dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "ComputeCRC32"
              ((* unsigned-8) integer-32)
              unsigned-32)))
        (f data dataSize))))
  (define ComputeMD5
    (let ([f #f])
      (lambda (data dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "ComputeMD5"
              ((* unsigned-8) integer-32)
              (* unsigned-32))))
        (f data dataSize))))
  (define ComputeSHA1
    (let ([f #f])
      (lambda (data dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "ComputeSHA1"
              ((* unsigned-8) integer-32)
              (* unsigned-32))))
        (f data dataSize))))
  (define ComputeSHA256
    (let ([f #f])
      (lambda (data dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "ComputeSHA256"
              ((* unsigned-8) integer-32)
              (* unsigned-32))))
        (f data dataSize))))
  (define LoadAutomationEventList
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadAutomationEventList"
              (string)
              (& AutomationEventList))))
        (let ([ret-res (make-ftype-pointer
                         AutomationEventList
                         (foreign-alloc
                           (ftype-sizeof AutomationEventList)))])
          (f ret-res fileName)
          ret-res))))
  (define UnloadAutomationEventList
    (let ([f #f])
      (lambda (list)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadAutomationEventList"
              ((& AutomationEventList))
              void)))
        (f list))))
  (define ExportAutomationEventList
    (let ([f #f])
      (lambda (list fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportAutomationEventList"
              ((& AutomationEventList) string)
              stdbool)))
        (f list fileName))))
  (define SetAutomationEventList
    (let ([f #f])
      (lambda (list)
        (unless f
          (set! f
            (foreign-procedure #f "SetAutomationEventList"
              ((* AutomationEventList))
              void)))
        (f list))))
  (define SetAutomationEventBaseFrame
    (let ([f #f])
      (lambda (frame)
        (unless f
          (set! f
            (foreign-procedure #f "SetAutomationEventBaseFrame"
              (integer-32)
              void)))
        (f frame))))
  (define StartAutomationEventRecording
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "StartAutomationEventRecording"
              ()
              void)))
        (f))))
  (define StopAutomationEventRecording
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "StopAutomationEventRecording"
              ()
              void)))
        (f))))
  (define PlayAutomationEvent
    (let ([f #f])
      (lambda (event)
        (unless f
          (set! f
            (foreign-procedure #f "PlayAutomationEvent"
              ((& AutomationEvent))
              void)))
        (f event))))
  (define IsKeyPressed
    (let ([f #f])
      (lambda (key)
        (unless f
          (set! f
            (foreign-procedure #f "IsKeyPressed" (integer-32) stdbool)))
        (f key))))
  (define IsKeyPressedRepeat
    (let ([f #f])
      (lambda (key)
        (unless f
          (set! f
            (foreign-procedure #f "IsKeyPressedRepeat"
              (integer-32)
              stdbool)))
        (f key))))
  (define IsKeyDown
    (let ([f #f])
      (lambda (key)
        (unless f
          (set! f
            (foreign-procedure #f "IsKeyDown" (integer-32) stdbool)))
        (f key))))
  (define IsKeyReleased
    (let ([f #f])
      (lambda (key)
        (unless f
          (set! f
            (foreign-procedure #f "IsKeyReleased"
              (integer-32)
              stdbool)))
        (f key))))
  (define IsKeyUp
    (let ([f #f])
      (lambda (key)
        (unless f
          (set! f
            (foreign-procedure #f "IsKeyUp" (integer-32) stdbool)))
        (f key))))
  (define GetKeyPressed
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetKeyPressed" () integer-32)))
        (f))))
  (define GetCharPressed
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetCharPressed" () integer-32)))
        (f))))
  (define GetKeyName
    (let ([f #f])
      (lambda (key)
        (unless f
          (set! f
            (foreign-procedure #f "GetKeyName" (integer-32) string)))
        (f key))))
  (define SetExitKey
    (let ([f #f])
      (lambda (key)
        (unless f
          (set! f
            (foreign-procedure #f "SetExitKey" (integer-32) void)))
        (f key))))
  (define IsGamepadAvailable
    (let ([f #f])
      (lambda (gamepad)
        (unless f
          (set! f
            (foreign-procedure #f "IsGamepadAvailable"
              (integer-32)
              stdbool)))
        (f gamepad))))
  (define GetGamepadName
    (let ([f #f])
      (lambda (gamepad)
        (unless f
          (set! f
            (foreign-procedure #f "GetGamepadName"
              (integer-32)
              string)))
        (f gamepad))))
  (define IsGamepadButtonPressed
    (let ([f #f])
      (lambda (gamepad button)
        (unless f
          (set! f
            (foreign-procedure #f "IsGamepadButtonPressed"
              (integer-32 integer-32)
              stdbool)))
        (f gamepad button))))
  (define IsGamepadButtonDown
    (let ([f #f])
      (lambda (gamepad button)
        (unless f
          (set! f
            (foreign-procedure #f "IsGamepadButtonDown"
              (integer-32 integer-32)
              stdbool)))
        (f gamepad button))))
  (define IsGamepadButtonReleased
    (let ([f #f])
      (lambda (gamepad button)
        (unless f
          (set! f
            (foreign-procedure #f "IsGamepadButtonReleased"
              (integer-32 integer-32)
              stdbool)))
        (f gamepad button))))
  (define IsGamepadButtonUp
    (let ([f #f])
      (lambda (gamepad button)
        (unless f
          (set! f
            (foreign-procedure #f "IsGamepadButtonUp"
              (integer-32 integer-32)
              stdbool)))
        (f gamepad button))))
  (define GetGamepadButtonPressed
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetGamepadButtonPressed"
              ()
              integer-32)))
        (f))))
  (define GetGamepadAxisCount
    (let ([f #f])
      (lambda (gamepad)
        (unless f
          (set! f
            (foreign-procedure #f "GetGamepadAxisCount"
              (integer-32)
              integer-32)))
        (f gamepad))))
  (define GetGamepadAxisMovement
    (let ([f #f])
      (lambda (gamepad axis)
        (unless f
          (set! f
            (foreign-procedure #f "GetGamepadAxisMovement"
              (integer-32 integer-32)
              single-float)))
        (f gamepad axis))))
  (define SetGamepadMappings
    (let ([f #f])
      (lambda (mappings)
        (unless f
          (set! f
            (foreign-procedure #f "SetGamepadMappings"
              (string)
              integer-32)))
        (f mappings))))
  (define SetGamepadVibration
    (let ([f #f])
      (lambda (gamepad leftMotor rightMotor duration)
        (unless f
          (set! f
            (foreign-procedure #f "SetGamepadVibration"
              (integer-32 single-float single-float single-float)
              void)))
        (f gamepad leftMotor rightMotor duration))))
  (define IsMouseButtonPressed
    (let ([f #f])
      (lambda (button)
        (unless f
          (set! f
            (foreign-procedure #f "IsMouseButtonPressed"
              (integer-32)
              stdbool)))
        (f button))))
  (define IsMouseButtonDown
    (let ([f #f])
      (lambda (button)
        (unless f
          (set! f
            (foreign-procedure #f "IsMouseButtonDown"
              (integer-32)
              stdbool)))
        (f button))))
  (define IsMouseButtonReleased
    (let ([f #f])
      (lambda (button)
        (unless f
          (set! f
            (foreign-procedure #f "IsMouseButtonReleased"
              (integer-32)
              stdbool)))
        (f button))))
  (define IsMouseButtonUp
    (let ([f #f])
      (lambda (button)
        (unless f
          (set! f
            (foreign-procedure #f "IsMouseButtonUp"
              (integer-32)
              stdbool)))
        (f button))))
  (define GetMouseX
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "GetMouseX" () integer-32)))
        (f))))
  (define GetMouseY
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "GetMouseY" () integer-32)))
        (f))))
  (define GetMousePosition
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetMousePosition" () (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res)
          ret-res))))
  (define GetMouseDelta
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetMouseDelta" () (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res)
          ret-res))))
  (define SetMousePosition
    (let ([f #f])
      (lambda (x y)
        (unless f
          (set! f
            (foreign-procedure #f "SetMousePosition"
              (integer-32 integer-32)
              void)))
        (f x y))))
  (define SetMouseOffset
    (let ([f #f])
      (lambda (offsetX offsetY)
        (unless f
          (set! f
            (foreign-procedure #f "SetMouseOffset"
              (integer-32 integer-32)
              void)))
        (f offsetX offsetY))))
  (define SetMouseScale
    (let ([f #f])
      (lambda (scaleX scaleY)
        (unless f
          (set! f
            (foreign-procedure #f "SetMouseScale"
              (single-float single-float)
              void)))
        (f scaleX scaleY))))
  (define GetMouseWheelMove
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetMouseWheelMove" () single-float)))
        (f))))
  (define GetMouseWheelMoveV
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetMouseWheelMoveV" () (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res)
          ret-res))))
  (define SetMouseCursor
    (let ([f #f])
      (lambda (cursor)
        (unless f
          (set! f
            (foreign-procedure #f "SetMouseCursor" (integer-32) void)))
        (f cursor))))
  (define GetTouchX
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "GetTouchX" () integer-32)))
        (f))))
  (define GetTouchY
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "GetTouchY" () integer-32)))
        (f))))
  (define GetTouchPosition
    (let ([f #f])
      (lambda (index)
        (unless f
          (set! f
            (foreign-procedure #f "GetTouchPosition"
              (integer-32)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res index)
          ret-res))))
  (define GetTouchPointId
    (let ([f #f])
      (lambda (index)
        (unless f
          (set! f
            (foreign-procedure #f "GetTouchPointId"
              (integer-32)
              integer-32)))
        (f index))))
  (define GetTouchPointCount
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetTouchPointCount" () integer-32)))
        (f))))
  (define SetGesturesEnabled
    (let ([f #f])
      (lambda (flags)
        (unless f
          (set! f
            (foreign-procedure #f "SetGesturesEnabled"
              (unsigned-32)
              void)))
        (f flags))))
  (define IsGestureDetected
    (let ([f #f])
      (lambda (gesture)
        (unless f
          (set! f
            (foreign-procedure #f "IsGestureDetected"
              (unsigned-32)
              stdbool)))
        (f gesture))))
  (define GetGestureDetected
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetGestureDetected" () integer-32)))
        (f))))
  (define GetGestureHoldDuration
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetGestureHoldDuration"
              ()
              single-float)))
        (f))))
  (define GetGestureDragVector
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetGestureDragVector"
              ()
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res)
          ret-res))))
  (define GetGestureDragAngle
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetGestureDragAngle"
              ()
              single-float)))
        (f))))
  (define GetGesturePinchVector
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetGesturePinchVector"
              ()
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res)
          ret-res))))
  (define GetGesturePinchAngle
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetGesturePinchAngle"
              ()
              single-float)))
        (f))))
  (define UpdateCamera
    (let ([f #f])
      (lambda (camera mode)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateCamera"
              ((* Camera) integer-32)
              void)))
        (f camera mode))))
  (define UpdateCameraPro
    (let ([f #f])
      (lambda (camera movement rotation zoom)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateCameraPro"
              ((* Camera) (& Vector3) (& Vector3) single-float)
              void)))
        (f camera movement rotation zoom))))
  (define SetShapesTexture
    (let ([f #f])
      (lambda (texture rec)
        (unless f
          (set! f
            (foreign-procedure #f "SetShapesTexture"
              ((& Texture2D) (& Rectangle))
              void)))
        (f texture rec))))
  (define GetShapesTexture
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetShapesTexture" () (& Texture2D))))
        (let ([ret-res (make-ftype-pointer
                         Texture2D
                         (foreign-alloc (ftype-sizeof Texture2D)))])
          (f ret-res)
          ret-res))))
  (define GetShapesTextureRectangle
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetShapesTextureRectangle"
              ()
              (& Rectangle))))
        (let ([ret-res (make-ftype-pointer
                         Rectangle
                         (foreign-alloc (ftype-sizeof Rectangle)))])
          (f ret-res)
          ret-res))))
  (define DrawPixel
    (let ([f #f])
      (lambda (posX posY color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawPixel"
              (integer-32 integer-32 (& Color))
              void)))
        (f posX posY color))))
  (define DrawPixelV
    (let ([f #f])
      (lambda (position color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawPixelV"
              ((& Vector2) (& Color))
              void)))
        (f position color))))
  (define DrawLine
    (let ([f #f])
      (lambda (startPosX startPosY endPosX endPosY color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawLine"
              (integer-32 integer-32 integer-32 integer-32 (& Color))
              void)))
        (f startPosX startPosY endPosX endPosY color))))
  (define DrawLineV
    (let ([f #f])
      (lambda (startPos endPos color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawLineV"
              ((& Vector2) (& Vector2) (& Color))
              void)))
        (f startPos endPos color))))
  (define DrawLineEx
    (let ([f #f])
      (lambda (startPos endPos thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawLineEx"
              ((& Vector2) (& Vector2) single-float (& Color))
              void)))
        (f startPos endPos thick color))))
  (define DrawLineStrip
    (let ([f #f])
      (lambda (points pointCount color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawLineStrip"
              ((* Vector2) integer-32 (& Color))
              void)))
        (f points pointCount color))))
  (define DrawLineBezier
    (let ([f #f])
      (lambda (startPos endPos thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawLineBezier"
              ((& Vector2) (& Vector2) single-float (& Color))
              void)))
        (f startPos endPos thick color))))
  (define DrawLineDashed
    (let ([f #f])
      (lambda (startPos endPos dashSize spaceSize color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawLineDashed"
              ((& Vector2) (& Vector2) integer-32 integer-32 (& Color))
              void)))
        (f startPos endPos dashSize spaceSize color))))
  (define DrawTriangle
    (let ([f #f])
      (lambda (v1 v2 v3 color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangle"
              ((& Vector2) (& Vector2) (& Vector2) (& Color))
              void)))
        (f v1 v2 v3 color))))
  (define DrawTriangleGradient
    (let ([f #f])
      (lambda (v1 v2 v3 c1 c2 c3)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangleGradient"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Color)
               (& Color)
               (& Color))
              void)))
        (f v1 v2 v3 c1 c2 c3))))
  (define DrawTriangleLines
    (let ([f #f])
      (lambda (v1 v2 v3 color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangleLines"
              ((& Vector2) (& Vector2) (& Vector2) (& Color))
              void)))
        (f v1 v2 v3 color))))
  (define DrawTriangleLinesEx
    (let ([f #f])
      (lambda (v1 v2 v3 thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangleLinesEx"
              ((& Vector2) (& Vector2) (& Vector2) single-float (& Color))
              void)))
        (f v1 v2 v3 thick color))))
  (define DrawTriangleFan
    (let ([f #f])
      (lambda (points pointCount color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangleFan"
              ((* Vector2) integer-32 (& Color))
              void)))
        (f points pointCount color))))
  (define DrawTriangleStrip
    (let ([f #f])
      (lambda (points pointCount color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangleStrip"
              ((* Vector2) integer-32 (& Color))
              void)))
        (f points pointCount color))))
  (define DrawRectangle
    (let ([f #f])
      (lambda (posX posY width height color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangle"
              (integer-32 integer-32 integer-32 integer-32 (& Color))
              void)))
        (f posX posY width height color))))
  (define DrawRectangleV
    (let ([f #f])
      (lambda (position size color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleV"
              ((& Vector2) (& Vector2) (& Color))
              void)))
        (f position size color))))
  (define DrawRectangleRec
    (let ([f #f])
      (lambda (rec color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleRec"
              ((& Rectangle) (& Color))
              void)))
        (f rec color))))
  (define DrawRectanglePro
    (let ([f #f])
      (lambda (rec origin rotation color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectanglePro"
              ((& Rectangle) (& Vector2) single-float (& Color))
              void)))
        (f rec origin rotation color))))
  (define DrawRectangleGradientV
    (let ([f #f])
      (lambda (posX posY width height top bottom)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleGradientV"
              (integer-32
               integer-32
               integer-32
               integer-32
               (& Color)
               (& Color))
              void)))
        (f posX posY width height top bottom))))
  (define DrawRectangleGradientH
    (let ([f #f])
      (lambda (posX posY width height left right)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleGradientH"
              (integer-32
               integer-32
               integer-32
               integer-32
               (& Color)
               (& Color))
              void)))
        (f posX posY width height left right))))
  (define DrawRectangleGradientEx
    (let ([f #f])
      (lambda (rec col1 col2 col3 col4)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleGradientEx"
              ((& Rectangle) (& Color) (& Color) (& Color) (& Color))
              void)))
        (f rec col1 col2 col3 col4))))
  (define DrawRectangleLines
    (let ([f #f])
      (lambda (posX posY width height color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleLines"
              (integer-32 integer-32 integer-32 integer-32 (& Color))
              void)))
        (f posX posY width height color))))
  (define DrawRectangleLinesEx
    (let ([f #f])
      (lambda (rec thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleLinesEx"
              ((& Rectangle) single-float (& Color))
              void)))
        (f rec thick color))))
  (define DrawRectangleRounded
    (let ([f #f])
      (lambda (rec roundness segments color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleRounded"
              ((& Rectangle) single-float integer-32 (& Color))
              void)))
        (f rec roundness segments color))))
  (define DrawRectangleRoundedLines
    (let ([f #f])
      (lambda (rec roundness segments color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleRoundedLines"
              ((& Rectangle) single-float integer-32 (& Color))
              void)))
        (f rec roundness segments color))))
  (define DrawRectangleRoundedLinesEx
    (let ([f #f])
      (lambda (rec roundness segments thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRectangleRoundedLinesEx"
              ((& Rectangle)
               single-float
               integer-32
               single-float
               (& Color))
              void)))
        (f rec roundness segments thick color))))
  (define DrawPoly
    (let ([f #f])
      (lambda (center sides radius rotation color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawPoly"
              ((& Vector2) integer-32 single-float single-float (& Color))
              void)))
        (f center sides radius rotation color))))
  (define DrawPolyLines
    (let ([f #f])
      (lambda (center sides radius rotation color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawPolyLines"
              ((& Vector2) integer-32 single-float single-float (& Color))
              void)))
        (f center sides radius rotation color))))
  (define DrawPolyLinesEx
    (let ([f #f])
      (lambda (center sides radius rotation thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawPolyLinesEx"
              ((& Vector2)
               integer-32
               single-float
               single-float
               single-float
               (& Color))
              void)))
        (f center sides radius rotation thick color))))
  (define DrawCircle
    (let ([f #f])
      (lambda (centerX centerY radius color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircle"
              (integer-32 integer-32 single-float (& Color))
              void)))
        (f centerX centerY radius color))))
  (define DrawCircleV
    (let ([f #f])
      (lambda (center radius color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleV"
              ((& Vector2) single-float (& Color))
              void)))
        (f center radius color))))
  (define DrawCircleGradient
    (let ([f #f])
      (lambda (center radius inner outer)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleGradient"
              ((& Vector2) single-float (& Color) (& Color))
              void)))
        (f center radius inner outer))))
  (define DrawCircleSector
    (let ([f #f])
      (lambda (center radius startAngle endAngle segments color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleSector"
              ((& Vector2)
               single-float
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f center radius startAngle endAngle segments color))))
  (define DrawCircleSectorLines
    (let ([f #f])
      (lambda (center radius startAngle endAngle segments color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleSectorLines"
              ((& Vector2)
               single-float
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f center radius startAngle endAngle segments color))))
  (define DrawCircleSectorLinesEx
    (let ([f #f])
      (lambda (center radius startAngle endAngle segments thick
               color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleSectorLinesEx"
              ((& Vector2)
               single-float
               single-float
               single-float
               integer-32
               single-float
               (& Color))
              void)))
        (f center radius startAngle endAngle segments thick
           color))))
  (define DrawCircleLines
    (let ([f #f])
      (lambda (centerX centerY radius color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleLines"
              (integer-32 integer-32 single-float (& Color))
              void)))
        (f centerX centerY radius color))))
  (define DrawCircleLinesV
    (let ([f #f])
      (lambda (center radius color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleLinesV"
              ((& Vector2) single-float (& Color))
              void)))
        (f center radius color))))
  (define DrawCircleLinesEx
    (let ([f #f])
      (lambda (center radius thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircleLinesEx"
              ((& Vector2) single-float single-float (& Color))
              void)))
        (f center radius thick color))))
  (define DrawEllipse
    (let ([f #f])
      (lambda (centerX centerY radiusH radiusV color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawEllipse"
              (integer-32 integer-32 single-float single-float (& Color))
              void)))
        (f centerX centerY radiusH radiusV color))))
  (define DrawEllipseV
    (let ([f #f])
      (lambda (center radiusH radiusV color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawEllipseV"
              ((& Vector2) single-float single-float (& Color))
              void)))
        (f center radiusH radiusV color))))
  (define DrawEllipseLines
    (let ([f #f])
      (lambda (centerX centerY radiusH radiusV color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawEllipseLines"
              (integer-32 integer-32 single-float single-float (& Color))
              void)))
        (f centerX centerY radiusH radiusV color))))
  (define DrawEllipseLinesV
    (let ([f #f])
      (lambda (center radiusH radiusV color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawEllipseLinesV"
              ((& Vector2) single-float single-float (& Color))
              void)))
        (f center radiusH radiusV color))))
  (define DrawEllipseLinesEx
    (let ([f #f])
      (lambda (center radiusH radiusV thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawEllipseLinesEx"
              ((& Vector2)
               single-float
               single-float
               single-float
               (& Color))
              void)))
        (f center radiusH radiusV thick color))))
  (define DrawRing
    (let ([f #f])
      (lambda (center innerRadius outerRadius startAngle endAngle
               segments color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRing"
              ((& Vector2)
               single-float
               single-float
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f center innerRadius outerRadius startAngle endAngle
           segments color))))
  (define DrawRingLines
    (let ([f #f])
      (lambda (center innerRadius outerRadius startAngle endAngle
               segments color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRingLines"
              ((& Vector2)
               single-float
               single-float
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f center innerRadius outerRadius startAngle endAngle
           segments color))))
  (define DrawRingLinesEx
    (let ([f #f])
      (lambda (center innerRadius outerRadius startAngle endAngle
               segments thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRingLinesEx"
              ((& Vector2)
               single-float
               single-float
               single-float
               single-float
               integer-32
               single-float
               (& Color))
              void)))
        (f center innerRadius outerRadius startAngle endAngle
           segments thick color))))
  (define DrawSplineLinear
    (let ([f #f])
      (lambda (points pointCount thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineLinear"
              ((* Vector2) integer-32 single-float (& Color))
              void)))
        (f points pointCount thick color))))
  (define DrawSplineBasis
    (let ([f #f])
      (lambda (points pointCount thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineBasis"
              ((* Vector2) integer-32 single-float (& Color))
              void)))
        (f points pointCount thick color))))
  (define DrawSplineCatmullRom
    (let ([f #f])
      (lambda (points pointCount thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineCatmullRom"
              ((* Vector2) integer-32 single-float (& Color))
              void)))
        (f points pointCount thick color))))
  (define DrawSplineBezierQuadratic
    (let ([f #f])
      (lambda (points pointCount thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineBezierQuadratic"
              ((* Vector2) integer-32 single-float (& Color))
              void)))
        (f points pointCount thick color))))
  (define DrawSplineBezierCubic
    (let ([f #f])
      (lambda (points pointCount thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineBezierCubic"
              ((* Vector2) integer-32 single-float (& Color))
              void)))
        (f points pointCount thick color))))
  (define DrawSplineSegmentLinear
    (let ([f #f])
      (lambda (p1 p2 thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineSegmentLinear"
              ((& Vector2) (& Vector2) single-float (& Color))
              void)))
        (f p1 p2 thick color))))
  (define DrawSplineSegmentBasis
    (let ([f #f])
      (lambda (p1 p2 p3 p4 thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineSegmentBasis"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               single-float
               (& Color))
              void)))
        (f p1 p2 p3 p4 thick color))))
  (define DrawSplineSegmentCatmullRom
    (let ([f #f])
      (lambda (p1 p2 p3 p4 thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineSegmentCatmullRom"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               single-float
               (& Color))
              void)))
        (f p1 p2 p3 p4 thick color))))
  (define DrawSplineSegmentBezierQuadratic
    (let ([f #f])
      (lambda (p1 c2 p3 thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineSegmentBezierQuadratic"
              ((& Vector2) (& Vector2) (& Vector2) single-float (& Color))
              void)))
        (f p1 c2 p3 thick color))))
  (define DrawSplineSegmentBezierCubic
    (let ([f #f])
      (lambda (p1 c2 c3 p4 thick color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSplineSegmentBezierCubic"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               single-float
               (& Color))
              void)))
        (f p1 c2 c3 p4 thick color))))
  (define GetSplinePointLinear
    (let ([f #f])
      (lambda (startPos endPos t)
        (unless f
          (set! f
            (foreign-procedure #f "GetSplinePointLinear"
              ((& Vector2) (& Vector2) single-float)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res startPos endPos t)
          ret-res))))
  (define GetSplinePointBasis
    (let ([f #f])
      (lambda (p1 p2 p3 p4 t)
        (unless f
          (set! f
            (foreign-procedure #f "GetSplinePointBasis"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               single-float)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res p1 p2 p3 p4 t)
          ret-res))))
  (define GetSplinePointCatmullRom
    (let ([f #f])
      (lambda (p1 p2 p3 p4 t)
        (unless f
          (set! f
            (foreign-procedure #f "GetSplinePointCatmullRom"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               single-float)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res p1 p2 p3 p4 t)
          ret-res))))
  (define GetSplinePointBezierQuadratic
    (let ([f #f])
      (lambda (p1 c2 p3 t)
        (unless f
          (set! f
            (foreign-procedure #f "GetSplinePointBezierQuadratic"
              ((& Vector2) (& Vector2) (& Vector2) single-float)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res p1 c2 p3 t)
          ret-res))))
  (define GetSplinePointBezierCubic
    (let ([f #f])
      (lambda (p1 c2 c3 p4 t)
        (unless f
          (set! f
            (foreign-procedure #f "GetSplinePointBezierCubic"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               single-float)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res p1 c2 c3 p4 t)
          ret-res))))
  (define CheckCollisionRecs
    (let ([f #f])
      (lambda (rec1 rec2)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionRecs"
              ((& Rectangle) (& Rectangle))
              stdbool)))
        (f rec1 rec2))))
  (define CheckCollisionCircles
    (let ([f #f])
      (lambda (center1 radius1 center2 radius2)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionCircles"
              ((& Vector2) single-float (& Vector2) single-float)
              stdbool)))
        (f center1 radius1 center2 radius2))))
  (define CheckCollisionCircleRec
    (let ([f #f])
      (lambda (center radius rec)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionCircleRec"
              ((& Vector2) single-float (& Rectangle))
              stdbool)))
        (f center radius rec))))
  (define CheckCollisionCircleLine
    (let ([f #f])
      (lambda (center radius p1 p2)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionCircleLine"
              ((& Vector2) single-float (& Vector2) (& Vector2))
              stdbool)))
        (f center radius p1 p2))))
  (define CheckCollisionPointRec
    (let ([f #f])
      (lambda (point rec)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionPointRec"
              ((& Vector2) (& Rectangle))
              stdbool)))
        (f point rec))))
  (define CheckCollisionPointCircle
    (let ([f #f])
      (lambda (point center radius)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionPointCircle"
              ((& Vector2) (& Vector2) single-float)
              stdbool)))
        (f point center radius))))
  (define CheckCollisionPointTriangle
    (let ([f #f])
      (lambda (point p1 p2 p3)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionPointTriangle"
              ((& Vector2) (& Vector2) (& Vector2) (& Vector2))
              stdbool)))
        (f point p1 p2 p3))))
  (define CheckCollisionPointLine
    (let ([f #f])
      (lambda (point p1 p2 threshold)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionPointLine"
              ((& Vector2) (& Vector2) (& Vector2) integer-32)
              stdbool)))
        (f point p1 p2 threshold))))
  (define CheckCollisionPointPoly
    (let ([f #f])
      (lambda (point points pointCount)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionPointPoly"
              ((& Vector2) (* Vector2) integer-32)
              stdbool)))
        (f point points pointCount))))
  (define CheckCollisionLines
    (let ([f #f])
      (lambda (startPos1 endPos1 startPos2 endPos2 collisionPoint)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionLines"
              ((& Vector2)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               (* Vector2))
              stdbool)))
        (f startPos1 endPos1 startPos2 endPos2 collisionPoint))))
  (define GetCollisionRec
    (let ([f #f])
      (lambda (rec1 rec2)
        (unless f
          (set! f
            (foreign-procedure #f "GetCollisionRec"
              ((& Rectangle) (& Rectangle))
              (& Rectangle))))
        (let ([ret-res (make-ftype-pointer
                         Rectangle
                         (foreign-alloc (ftype-sizeof Rectangle)))])
          (f ret-res rec1 rec2)
          ret-res))))
  (define LoadImage
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImage" (string) (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res fileName)
          ret-res))))
  (define LoadImageRaw
    (let ([f #f])
      (lambda (fileName width height format headerSize)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImageRaw"
              (string integer-32 integer-32 integer-32 integer-32)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res fileName width height format headerSize)
          ret-res))))
  (define LoadImageAnim
    (let ([f #f])
      (lambda (fileName frames)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImageAnim"
              (string (* integer-32))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res fileName frames)
          ret-res))))
  (define LoadImageAnimFromMemory
    (let ([f #f])
      (lambda (fileType fileData dataSize frames)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImageAnimFromMemory"
              (string (* unsigned-8) integer-32 (* integer-32))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res fileType fileData dataSize frames)
          ret-res))))
  (define LoadImageFromMemory
    (let ([f #f])
      (lambda (fileType fileData dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImageFromMemory"
              (string (* unsigned-8) integer-32)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res fileType fileData dataSize)
          ret-res))))
  (define LoadImageFromTexture
    (let ([f #f])
      (lambda (texture)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImageFromTexture"
              ((& Texture2D))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res texture)
          ret-res))))
  (define LoadImageFromScreen
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "LoadImageFromScreen" () (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res)
          ret-res))))
  (define IsImageValid
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "IsImageValid" ((& Image)) stdbool)))
        (f image))))
  (define UnloadImage
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadImage" ((& Image)) void)))
        (f image))))
  (define ExportImage
    (let ([f #f])
      (lambda (image fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportImage"
              ((& Image) string)
              stdbool)))
        (f image fileName))))
  (define ExportImageToMemory
    (let ([f #f])
      (lambda (image fileType fileSize)
        (unless f
          (set! f
            (foreign-procedure #f "ExportImageToMemory"
              ((& Image) string (* integer-32))
              (* unsigned-8))))
        (f image fileType fileSize))))
  (define ExportImageAsCode
    (let ([f #f])
      (lambda (image fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportImageAsCode"
              ((& Image) string)
              stdbool)))
        (f image fileName))))
  (define GenImageColor
    (let ([f #f])
      (lambda (width height color)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageColor"
              (integer-32 integer-32 (& Color))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height color)
          ret-res))))
  (define GenImageGradientLinear
    (let ([f #f])
      (lambda (width height direction start end)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageGradientLinear"
              (integer-32 integer-32 integer-32 (& Color) (& Color))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height direction start end)
          ret-res))))
  (define GenImageGradientRadial
    (let ([f #f])
      (lambda (width height density inner outer)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageGradientRadial"
              (integer-32 integer-32 single-float (& Color) (& Color))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height density inner outer)
          ret-res))))
  (define GenImageGradientSquare
    (let ([f #f])
      (lambda (width height density inner outer)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageGradientSquare"
              (integer-32 integer-32 single-float (& Color) (& Color))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height density inner outer)
          ret-res))))
  (define GenImageChecked
    (let ([f #f])
      (lambda (width height checksX checksY col1 col2)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageChecked"
              (integer-32
               integer-32
               integer-32
               integer-32
               (& Color)
               (& Color))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height checksX checksY col1 col2)
          ret-res))))
  (define GenImageWhiteNoise
    (let ([f #f])
      (lambda (width height factor)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageWhiteNoise"
              (integer-32 integer-32 single-float)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height factor)
          ret-res))))
  (define GenImagePerlinNoise
    (let ([f #f])
      (lambda (width height offsetX offsetY scale)
        (unless f
          (set! f
            (foreign-procedure #f "GenImagePerlinNoise"
              (integer-32 integer-32 integer-32 integer-32 single-float)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height offsetX offsetY scale)
          ret-res))))
  (define GenImageCellular
    (let ([f #f])
      (lambda (width height tileSize)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageCellular"
              (integer-32 integer-32 integer-32)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height tileSize)
          ret-res))))
  (define GenImageText
    (let ([f #f])
      (lambda (width height text)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageText"
              (integer-32 integer-32 string)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res width height text)
          ret-res))))
  (define ImageCopy
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageCopy" ((& Image)) (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res image)
          ret-res))))
  (define ImageFromImage
    (let ([f #f])
      (lambda (image rec)
        (unless f
          (set! f
            (foreign-procedure #f "ImageFromImage"
              ((& Image) (& Rectangle))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res image rec)
          ret-res))))
  (define ImageFromChannel
    (let ([f #f])
      (lambda (image selectedChannel)
        (unless f
          (set! f
            (foreign-procedure #f "ImageFromChannel"
              ((& Image) integer-32)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res image selectedChannel)
          ret-res))))
  (define ImageText
    (let ([f #f])
      (lambda (text fontSize color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageText"
              (string integer-32 (& Color))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res text fontSize color)
          ret-res))))
  (define ImageTextEx
    (let ([f #f])
      (lambda (font text fontSize spacing tint)
        (unless f
          (set! f
            (foreign-procedure #f "ImageTextEx"
              ((& Font) string single-float single-float (& Color))
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res font text fontSize spacing tint)
          ret-res))))
  (define ImageFormat
    (let ([f #f])
      (lambda (image newFormat)
        (unless f
          (set! f
            (foreign-procedure #f "ImageFormat"
              ((* Image) integer-32)
              void)))
        (f image newFormat))))
  (define ImageToPOT
    (let ([f #f])
      (lambda (image fill)
        (unless f
          (set! f
            (foreign-procedure #f "ImageToPOT"
              ((* Image) (& Color))
              void)))
        (f image fill))))
  (define ImageCrop
    (let ([f #f])
      (lambda (image crop)
        (unless f
          (set! f
            (foreign-procedure #f "ImageCrop"
              ((* Image) (& Rectangle))
              void)))
        (f image crop))))
  (define ImageAlphaCrop
    (let ([f #f])
      (lambda (image threshold)
        (unless f
          (set! f
            (foreign-procedure #f "ImageAlphaCrop"
              ((* Image) single-float)
              void)))
        (f image threshold))))
  (define ImageAlphaClear
    (let ([f #f])
      (lambda (image color threshold)
        (unless f
          (set! f
            (foreign-procedure #f "ImageAlphaClear"
              ((* Image) (& Color) single-float)
              void)))
        (f image color threshold))))
  (define ImageAlphaMask
    (let ([f #f])
      (lambda (image alphaMask)
        (unless f
          (set! f
            (foreign-procedure #f "ImageAlphaMask"
              ((* Image) (& Image))
              void)))
        (f image alphaMask))))
  (define ImageAlphaPremultiply
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageAlphaPremultiply"
              ((* Image))
              void)))
        (f image))))
  (define ImageBlurGaussian
    (let ([f #f])
      (lambda (image blurSize)
        (unless f
          (set! f
            (foreign-procedure #f "ImageBlurGaussian"
              ((* Image) integer-32)
              void)))
        (f image blurSize))))
  (define ImageKernelConvolution
    (let ([f #f])
      (lambda (image kernel kernelSize)
        (unless f
          (set! f
            (foreign-procedure #f "ImageKernelConvolution"
              ((* Image) (* single-float) integer-32)
              void)))
        (f image kernel kernelSize))))
  (define ImageResize
    (let ([f #f])
      (lambda (image newWidth newHeight)
        (unless f
          (set! f
            (foreign-procedure #f "ImageResize"
              ((* Image) integer-32 integer-32)
              void)))
        (f image newWidth newHeight))))
  (define ImageResizeNN
    (let ([f #f])
      (lambda (image newWidth newHeight)
        (unless f
          (set! f
            (foreign-procedure #f "ImageResizeNN"
              ((* Image) integer-32 integer-32)
              void)))
        (f image newWidth newHeight))))
  (define ImageResizeCanvas
    (let ([f #f])
      (lambda (image newWidth newHeight offsetX offsetY fill)
        (unless f
          (set! f
            (foreign-procedure #f "ImageResizeCanvas"
              ((* Image)
               integer-32
               integer-32
               integer-32
               integer-32
               (& Color))
              void)))
        (f image newWidth newHeight offsetX offsetY fill))))
  (define ImageMipmaps
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageMipmaps" ((* Image)) void)))
        (f image))))
  (define ImageDither
    (let ([f #f])
      (lambda (image rBpp gBpp bBpp aBpp)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDither"
              ((* Image) integer-32 integer-32 integer-32 integer-32)
              void)))
        (f image rBpp gBpp bBpp aBpp))))
  (define ImageFlipVertical
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageFlipVertical"
              ((* Image))
              void)))
        (f image))))
  (define ImageFlipHorizontal
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageFlipHorizontal"
              ((* Image))
              void)))
        (f image))))
  (define ImageRotate
    (let ([f #f])
      (lambda (image degrees)
        (unless f
          (set! f
            (foreign-procedure #f "ImageRotate"
              ((* Image) integer-32)
              void)))
        (f image degrees))))
  (define ImageRotateCW
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageRotateCW" ((* Image)) void)))
        (f image))))
  (define ImageRotateCCW
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageRotateCCW" ((* Image)) void)))
        (f image))))
  (define ImageColorTint
    (let ([f #f])
      (lambda (image color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageColorTint"
              ((* Image) (& Color))
              void)))
        (f image color))))
  (define ImageColorInvert
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageColorInvert" ((* Image)) void)))
        (f image))))
  (define ImageColorGrayscale
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "ImageColorGrayscale"
              ((* Image))
              void)))
        (f image))))
  (define ImageColorContrast
    (let ([f #f])
      (lambda (image contrast)
        (unless f
          (set! f
            (foreign-procedure #f "ImageColorContrast"
              ((* Image) integer-32)
              void)))
        (f image contrast))))
  (define ImageColorBrightness
    (let ([f #f])
      (lambda (image brightness)
        (unless f
          (set! f
            (foreign-procedure #f "ImageColorBrightness"
              ((* Image) integer-32)
              void)))
        (f image brightness))))
  (define ImageColorReplace
    (let ([f #f])
      (lambda (image color replace)
        (unless f
          (set! f
            (foreign-procedure #f "ImageColorReplace"
              ((* Image) (& Color) (& Color))
              void)))
        (f image color replace))))
  (define LoadImageColors
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImageColors"
              ((& Image))
              (* Color))))
        (f image))))
  (define LoadImagePalette
    (let ([f #f])
      (lambda (image maxPaletteSize colorCount)
        (unless f
          (set! f
            (foreign-procedure #f "LoadImagePalette"
              ((& Image) integer-32 (* integer-32))
              (* Color))))
        (f image maxPaletteSize colorCount))))
  (define UnloadImageColors
    (let ([f #f])
      (lambda (colors)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadImageColors"
              ((* Color))
              void)))
        (f colors))))
  (define UnloadImagePalette
    (let ([f #f])
      (lambda (colors)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadImagePalette"
              ((* Color))
              void)))
        (f colors))))
  (define GetImageAlphaBorder
    (let ([f #f])
      (lambda (image threshold)
        (unless f
          (set! f
            (foreign-procedure #f "GetImageAlphaBorder"
              ((& Image) single-float)
              (& Rectangle))))
        (let ([ret-res (make-ftype-pointer
                         Rectangle
                         (foreign-alloc (ftype-sizeof Rectangle)))])
          (f ret-res image threshold)
          ret-res))))
  (define GetImageColor
    (let ([f #f])
      (lambda (image x y)
        (unless f
          (set! f
            (foreign-procedure #f "GetImageColor"
              ((& Image) integer-32 integer-32)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res image x y)
          ret-res))))
  (define ImageClearBackground
    (let ([f #f])
      (lambda (dst color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageClearBackground"
              ((* Image) (& Color))
              void)))
        (f dst color))))
  (define ImageDrawPixel
    (let ([f #f])
      (lambda (dst posX posY color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawPixel"
              ((* Image) integer-32 integer-32 (& Color))
              void)))
        (f dst posX posY color))))
  (define ImageDrawPixelV
    (let ([f #f])
      (lambda (dst position color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawPixelV"
              ((* Image) (& Vector2) (& Color))
              void)))
        (f dst position color))))
  (define ImageDrawLine
    (let ([f #f])
      (lambda (dst startPosX startPosY endPosX endPosY color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawLine"
              ((* Image)
               integer-32
               integer-32
               integer-32
               integer-32
               (& Color))
              void)))
        (f dst startPosX startPosY endPosX endPosY color))))
  (define ImageDrawLineV
    (let ([f #f])
      (lambda (dst start end color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawLineV"
              ((* Image) (& Vector2) (& Vector2) (& Color))
              void)))
        (f dst start end color))))
  (define ImageDrawLineEx
    (let ([f #f])
      (lambda (dst start end thick color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawLineEx"
              ((* Image) (& Vector2) (& Vector2) integer-32 (& Color))
              void)))
        (f dst start end thick color))))
  (define ImageDrawLineStrip
    (let ([f #f])
      (lambda (dst points pointCount color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawLineStrip"
              ((* Image) (* Vector2) integer-32 (& Color))
              void)))
        (f dst points pointCount color))))
  (define ImageDrawTriangle
    (let ([f #f])
      (lambda (dst v1 v2 v3 color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawTriangle"
              ((* Image) (& Vector2) (& Vector2) (& Vector2) (& Color))
              void)))
        (f dst v1 v2 v3 color))))
  (define ImageDrawTriangleGradient
    (let ([f #f])
      (lambda (dst v1 v2 v3 c1 c2 c3)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawTriangleGradient"
              ((* Image)
               (& Vector2)
               (& Vector2)
               (& Vector2)
               (& Color)
               (& Color)
               (& Color))
              void)))
        (f dst v1 v2 v3 c1 c2 c3))))
  (define ImageDrawTriangleLines
    (let ([f #f])
      (lambda (dst v1 v2 v3 color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawTriangleLines"
              ((* Image) (& Vector2) (& Vector2) (& Vector2) (& Color))
              void)))
        (f dst v1 v2 v3 color))))
  (define ImageDrawTriangleFan
    (let ([f #f])
      (lambda (dst points pointCount color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawTriangleFan"
              ((* Image) (* Vector2) integer-32 (& Color))
              void)))
        (f dst points pointCount color))))
  (define ImageDrawTriangleStrip
    (let ([f #f])
      (lambda (dst points pointCount color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawTriangleStrip"
              ((* Image) (* Vector2) integer-32 (& Color))
              void)))
        (f dst points pointCount color))))
  (define ImageDrawRectangle
    (let ([f #f])
      (lambda (dst posX posY width height color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawRectangle"
              ((* Image)
               integer-32
               integer-32
               integer-32
               integer-32
               (& Color))
              void)))
        (f dst posX posY width height color))))
  (define ImageDrawRectangleV
    (let ([f #f])
      (lambda (dst position size color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawRectangleV"
              ((* Image) (& Vector2) (& Vector2) (& Color))
              void)))
        (f dst position size color))))
  (define ImageDrawRectangleRec
    (let ([f #f])
      (lambda (dst rec color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawRectangleRec"
              ((* Image) (& Rectangle) (& Color))
              void)))
        (f dst rec color))))
  (define ImageDrawRectanglePro
    (let ([f #f])
      (lambda (dst rec origin rotation color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawRectanglePro"
              ((* Image) (& Rectangle) (& Vector2) single-float (& Color))
              void)))
        (f dst rec origin rotation color))))
  (define ImageDrawRectangleLines
    (let ([f #f])
      (lambda (dst posX posY width height color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawRectangleLines"
              ((* Image)
               integer-32
               integer-32
               integer-32
               integer-32
               (& Color))
              void)))
        (f dst posX posY width height color))))
  (define ImageDrawRectangleLinesEx
    (let ([f #f])
      (lambda (dst rec thick color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawRectangleLinesEx"
              ((* Image) (& Rectangle) integer-32 (& Color))
              void)))
        (f dst rec thick color))))
  (define ImageDrawRectangleGradientEx
    (let ([f #f])
      (lambda (dst rec col1 col2 col3 col4)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawRectangleGradientEx"
              ((* Image)
               (& Rectangle)
               (& Color)
               (& Color)
               (& Color)
               (& Color))
              void)))
        (f dst rec col1 col2 col3 col4))))
  (define ImageDrawCircle
    (let ([f #f])
      (lambda (dst centerX centerY radius color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawCircle"
              ((* Image) integer-32 integer-32 integer-32 (& Color))
              void)))
        (f dst centerX centerY radius color))))
  (define ImageDrawCircleV
    (let ([f #f])
      (lambda (dst center radius color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawCircleV"
              ((* Image) (& Vector2) integer-32 (& Color))
              void)))
        (f dst center radius color))))
  (define ImageDrawCircleLines
    (let ([f #f])
      (lambda (dst centerX centerY radius color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawCircleLines"
              ((* Image) integer-32 integer-32 integer-32 (& Color))
              void)))
        (f dst centerX centerY radius color))))
  (define ImageDrawCircleLinesV
    (let ([f #f])
      (lambda (dst center radius color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawCircleLinesV"
              ((* Image) (& Vector2) integer-32 (& Color))
              void)))
        (f dst center radius color))))
  (define ImageDrawCircleGradient
    (let ([f #f])
      (lambda (dst center radius inner outer)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawCircleGradient"
              ((* Image) (& Vector2) single-float (& Color) (& Color))
              void)))
        (f dst center radius inner outer))))
  (define ImageDrawImage
    (let ([f #f])
      (lambda (dst src posX posY tint)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawImage"
              ((* Image) (& Image) integer-32 integer-32 (& Color))
              void)))
        (f dst src posX posY tint))))
  (define ImageDrawImageEx
    (let ([f #f])
      (lambda (dst src position rotation scale tint)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawImageEx"
              ((* Image)
               (& Image)
               (& Vector2)
               single-float
               single-float
               (& Color))
              void)))
        (f dst src position rotation scale tint))))
  (define ImageDrawImageRec
    (let ([f #f])
      (lambda (dst src srcRec position tint)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawImageRec"
              ((* Image) (& Image) (& Rectangle) (& Vector2) (& Color))
              void)))
        (f dst src srcRec position tint))))
  (define ImageDrawImagePro
    (let ([f #f])
      (lambda (dst src srcRec dstRec origin rotation tint)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawImagePro"
              ((* Image)
               (& Image)
               (& Rectangle)
               (& Rectangle)
               (& Vector2)
               single-float
               (& Color))
              void)))
        (f dst src srcRec dstRec origin rotation tint))))
  (define ImageDrawText
    (let ([f #f])
      (lambda (dst text posX posY fontSize color)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawText"
              ((* Image)
               string
               integer-32
               integer-32
               integer-32
               (& Color))
              void)))
        (f dst text posX posY fontSize color))))
  (define ImageDrawTextEx
    (let ([f #f])
      (lambda (dst font text position fontSize spacing tint)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawTextEx"
              ((* Image)
               (& Font)
               string
               (& Vector2)
               single-float
               single-float
               (& Color))
              void)))
        (f dst font text position fontSize spacing tint))))
  (define ImageDrawTextPro
    (let ([f #f])
      (lambda (dst font text position origin rotation fontSize
               spacing tint)
        (unless f
          (set! f
            (foreign-procedure #f "ImageDrawTextPro"
              ((* Image)
               (& Font)
               string
               (& Vector2)
               (& Vector2)
               single-float
               single-float
               single-float
               (& Color))
              void)))
        (f dst font text position origin rotation fontSize spacing
           tint))))
  (define LoadTexture
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadTexture"
              (string)
              (& Texture2D))))
        (let ([ret-res (make-ftype-pointer
                         Texture2D
                         (foreign-alloc (ftype-sizeof Texture2D)))])
          (f ret-res fileName)
          ret-res))))
  (define LoadTextureFromImage
    (let ([f #f])
      (lambda (image)
        (unless f
          (set! f
            (foreign-procedure #f "LoadTextureFromImage"
              ((& Image))
              (& Texture2D))))
        (let ([ret-res (make-ftype-pointer
                         Texture2D
                         (foreign-alloc (ftype-sizeof Texture2D)))])
          (f ret-res image)
          ret-res))))
  (define LoadTextureCubemap
    (let ([f #f])
      (lambda (image layout)
        (unless f
          (set! f
            (foreign-procedure #f "LoadTextureCubemap"
              ((& Image) integer-32)
              (& TextureCubemap))))
        (let ([ret-res (make-ftype-pointer
                         TextureCubemap
                         (foreign-alloc (ftype-sizeof TextureCubemap)))])
          (f ret-res image layout)
          ret-res))))
  (define LoadRenderTexture
    (let ([f #f])
      (lambda (width height)
        (unless f
          (set! f
            (foreign-procedure #f "LoadRenderTexture"
              (integer-32 integer-32)
              (& RenderTexture2D))))
        (let ([ret-res (make-ftype-pointer
                         RenderTexture2D
                         (foreign-alloc (ftype-sizeof RenderTexture2D)))])
          (f ret-res width height)
          ret-res))))
  (define LoadRenderTextureEx
    (let ([f #f])
      (lambda (width height format)
        (unless f
          (set! f
            (foreign-procedure #f "LoadRenderTextureEx"
              (integer-32 integer-32 integer-32)
              (& RenderTexture2D))))
        (let ([ret-res (make-ftype-pointer
                         RenderTexture2D
                         (foreign-alloc (ftype-sizeof RenderTexture2D)))])
          (f ret-res width height format)
          ret-res))))
  (define IsTextureValid
    (let ([f #f])
      (lambda (texture)
        (unless f
          (set! f
            (foreign-procedure #f "IsTextureValid"
              ((& Texture2D))
              stdbool)))
        (f texture))))
  (define UnloadTexture
    (let ([f #f])
      (lambda (texture)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadTexture"
              ((& Texture2D))
              void)))
        (f texture))))
  (define IsRenderTextureValid
    (let ([f #f])
      (lambda (target)
        (unless f
          (set! f
            (foreign-procedure #f "IsRenderTextureValid"
              ((& RenderTexture2D))
              stdbool)))
        (f target))))
  (define UnloadRenderTexture
    (let ([f #f])
      (lambda (target)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadRenderTexture"
              ((& RenderTexture2D))
              void)))
        (f target))))
  (define UpdateTexture
    (let ([f #f])
      (lambda (texture pixels)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateTexture"
              ((& Texture2D) void*)
              void)))
        (f texture pixels))))
  (define UpdateTextureRec
    (let ([f #f])
      (lambda (texture rec pixels)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateTextureRec"
              ((& Texture2D) (& Rectangle) void*)
              void)))
        (f texture rec pixels))))
  (define GenTextureMipmaps
    (let ([f #f])
      (lambda (texture)
        (unless f
          (set! f
            (foreign-procedure #f "GenTextureMipmaps"
              ((* Texture2D))
              void)))
        (f texture))))
  (define SetTextureFilter
    (let ([f #f])
      (lambda (texture filter)
        (unless f
          (set! f
            (foreign-procedure #f "SetTextureFilter"
              ((& Texture2D) integer-32)
              void)))
        (f texture filter))))
  (define SetTextureWrap
    (let ([f #f])
      (lambda (texture wrap)
        (unless f
          (set! f
            (foreign-procedure #f "SetTextureWrap"
              ((& Texture2D) integer-32)
              void)))
        (f texture wrap))))
  (define DrawTexture
    (let ([f #f])
      (lambda (texture posX posY tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTexture"
              ((& Texture2D) integer-32 integer-32 (& Color))
              void)))
        (f texture posX posY tint))))
  (define DrawTextureV
    (let ([f #f])
      (lambda (texture position tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextureV"
              ((& Texture2D) (& Vector2) (& Color))
              void)))
        (f texture position tint))))
  (define DrawTextureEx
    (let ([f #f])
      (lambda (texture position rotation scale tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextureEx"
              ((& Texture2D)
               (& Vector2)
               single-float
               single-float
               (& Color))
              void)))
        (f texture position rotation scale tint))))
  (define DrawTextureRec
    (let ([f #f])
      (lambda (texture rec position tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextureRec"
              ((& Texture2D) (& Rectangle) (& Vector2) (& Color))
              void)))
        (f texture rec position tint))))
  (define DrawTexturePro
    (let ([f #f])
      (lambda (texture srcrec dstrec origin rotation tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTexturePro"
              ((& Texture2D)
               (& Rectangle)
               (& Rectangle)
               (& Vector2)
               single-float
               (& Color))
              void)))
        (f texture srcrec dstrec origin rotation tint))))
  (define DrawTextureNPatch
    (let ([f #f])
      (lambda (texture nPatchInfo dstrec origin rotation tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextureNPatch"
              ((& Texture2D)
               (& NPatchInfo)
               (& Rectangle)
               (& Vector2)
               single-float
               (& Color))
              void)))
        (f texture nPatchInfo dstrec origin rotation tint))))
  (define ColorIsEqual
    (let ([f #f])
      (lambda (col1 col2)
        (unless f
          (set! f
            (foreign-procedure #f "ColorIsEqual"
              ((& Color) (& Color))
              stdbool)))
        (f col1 col2))))
  (define Fade
    (let ([f #f])
      (lambda (color alpha)
        (unless f
          (set! f
            (foreign-procedure #f "Fade"
              ((& Color) single-float)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res color alpha)
          ret-res))))
  (define ColorToInt
    (let ([f #f])
      (lambda (color)
        (unless f
          (set! f
            (foreign-procedure #f "ColorToInt" ((& Color)) integer-32)))
        (f color))))
  (define ColorNormalize
    (let ([f #f])
      (lambda (color)
        (unless f
          (set! f
            (foreign-procedure #f "ColorNormalize"
              ((& Color))
              (& Vector4))))
        (let ([ret-res (make-ftype-pointer
                         Vector4
                         (foreign-alloc (ftype-sizeof Vector4)))])
          (f ret-res color)
          ret-res))))
  (define ColorFromNormalized
    (let ([f #f])
      (lambda (normalized)
        (unless f
          (set! f
            (foreign-procedure #f "ColorFromNormalized"
              ((& Vector4))
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res normalized)
          ret-res))))
  (define ColorToHSV
    (let ([f #f])
      (lambda (color)
        (unless f
          (set! f
            (foreign-procedure #f "ColorToHSV"
              ((& Color))
              (& Vector3))))
        (let ([ret-res (make-ftype-pointer
                         Vector3
                         (foreign-alloc (ftype-sizeof Vector3)))])
          (f ret-res color)
          ret-res))))
  (define ColorFromHSV
    (let ([f #f])
      (lambda (hue saturation value)
        (unless f
          (set! f
            (foreign-procedure #f "ColorFromHSV"
              (single-float single-float single-float)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res hue saturation value)
          ret-res))))
  (define ColorTint
    (let ([f #f])
      (lambda (color tint)
        (unless f
          (set! f
            (foreign-procedure #f "ColorTint"
              ((& Color) (& Color))
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res color tint)
          ret-res))))
  (define ColorBrightness
    (let ([f #f])
      (lambda (color factor)
        (unless f
          (set! f
            (foreign-procedure #f "ColorBrightness"
              ((& Color) single-float)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res color factor)
          ret-res))))
  (define ColorContrast
    (let ([f #f])
      (lambda (color contrast)
        (unless f
          (set! f
            (foreign-procedure #f "ColorContrast"
              ((& Color) single-float)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res color contrast)
          ret-res))))
  (define ColorAlpha
    (let ([f #f])
      (lambda (color alpha)
        (unless f
          (set! f
            (foreign-procedure #f "ColorAlpha"
              ((& Color) single-float)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res color alpha)
          ret-res))))
  (define ColorAlphaBlend
    (let ([f #f])
      (lambda (dst src tint)
        (unless f
          (set! f
            (foreign-procedure #f "ColorAlphaBlend"
              ((& Color) (& Color) (& Color))
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res dst src tint)
          ret-res))))
  (define ColorLerp
    (let ([f #f])
      (lambda (color1 color2 factor)
        (unless f
          (set! f
            (foreign-procedure #f "ColorLerp"
              ((& Color) (& Color) single-float)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res color1 color2 factor)
          ret-res))))
  (define GetColor
    (let ([f #f])
      (lambda (hexValue)
        (unless f
          (set! f
            (foreign-procedure #f "GetColor" (unsigned-32) (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res hexValue)
          ret-res))))
  (define GetPixelColor
    (let ([f #f])
      (lambda (srcPtr format)
        (unless f
          (set! f
            (foreign-procedure #f "GetPixelColor"
              (void* integer-32)
              (& Color))))
        (let ([ret-res (make-ftype-pointer
                         Color
                         (foreign-alloc (ftype-sizeof Color)))])
          (f ret-res srcPtr format)
          ret-res))))
  (define SetPixelColor
    (let ([f #f])
      (lambda (dstPtr color format)
        (unless f
          (set! f
            (foreign-procedure #f "SetPixelColor"
              (void* (& Color) integer-32)
              void)))
        (f dstPtr color format))))
  (define GetPixelDataSize
    (let ([f #f])
      (lambda (width height format)
        (unless f
          (set! f
            (foreign-procedure #f "GetPixelDataSize"
              (integer-32 integer-32 integer-32)
              integer-32)))
        (f width height format))))
  (define GetFontDefault
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetFontDefault" () (& Font))))
        (let ([ret-res (make-ftype-pointer
                         Font
                         (foreign-alloc (ftype-sizeof Font)))])
          (f ret-res)
          ret-res))))
  (define LoadFont
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadFont" (string) (& Font))))
        (let ([ret-res (make-ftype-pointer
                         Font
                         (foreign-alloc (ftype-sizeof Font)))])
          (f ret-res fileName)
          ret-res))))
  (define LoadFontEx
    (let ([f #f])
      (lambda (fileName fontSize codepoints codepointCount)
        (unless f
          (set! f
            (foreign-procedure #f "LoadFontEx"
              (string integer-32 (* integer-32) integer-32)
              (& Font))))
        (let ([ret-res (make-ftype-pointer
                         Font
                         (foreign-alloc (ftype-sizeof Font)))])
          (f ret-res fileName fontSize codepoints codepointCount)
          ret-res))))
  (define LoadFontFromImage
    (let ([f #f])
      (lambda (image key firstChar)
        (unless f
          (set! f
            (foreign-procedure #f "LoadFontFromImage"
              ((& Image) (& Color) integer-32)
              (& Font))))
        (let ([ret-res (make-ftype-pointer
                         Font
                         (foreign-alloc (ftype-sizeof Font)))])
          (f ret-res image key firstChar)
          ret-res))))
  (define LoadFontFromMemory
    (let ([f #f])
      (lambda (fileType fileData dataSize fontSize codepoints
               codepointCount)
        (unless f
          (set! f
            (foreign-procedure #f "LoadFontFromMemory"
              (string
               (* unsigned-8)
               integer-32
               integer-32
               (* integer-32)
               integer-32)
              (& Font))))
        (let ([ret-res (make-ftype-pointer
                         Font
                         (foreign-alloc (ftype-sizeof Font)))])
          (f ret-res fileType fileData dataSize fontSize codepoints
             codepointCount)
          ret-res))))
  (define IsFontValid
    (let ([f #f])
      (lambda (font)
        (unless f
          (set! f
            (foreign-procedure #f "IsFontValid" ((& Font)) stdbool)))
        (f font))))
  (define LoadFontData
    (let ([f #f])
      (lambda (fileData dataSize fontSize codepoints
               codepointCount type glyphCount)
        (unless f
          (set! f
            (foreign-procedure #f "LoadFontData"
              ((* unsigned-8)
               integer-32
               integer-32
               (* integer-32)
               integer-32
               integer-32
               (* integer-32))
              (* GlyphInfo))))
        (f fileData dataSize fontSize codepoints codepointCount type
           glyphCount))))
  (define GenImageFontAtlas
    (let ([f #f])
      (lambda (glyphs glyphRecs glyphCount fontSize padding
               packMethod)
        (unless f
          (set! f
            (foreign-procedure #f "GenImageFontAtlas"
              ((* GlyphInfo)
               (* *Rectangle)
               integer-32
               integer-32
               integer-32
               integer-32)
              (& Image))))
        (let ([ret-res (make-ftype-pointer
                         Image
                         (foreign-alloc (ftype-sizeof Image)))])
          (f ret-res glyphs glyphRecs glyphCount fontSize padding
             packMethod)
          ret-res))))
  (define UnloadFontData
    (let ([f #f])
      (lambda (glyphs glyphCount)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadFontData"
              ((* GlyphInfo) integer-32)
              void)))
        (f glyphs glyphCount))))
  (define UnloadFont
    (let ([f #f])
      (lambda (font)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadFont" ((& Font)) void)))
        (f font))))
  (define ExportFontAsCode
    (let ([f #f])
      (lambda (font fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportFontAsCode"
              ((& Font) string)
              stdbool)))
        (f font fileName))))
  (define DrawFPS
    (let ([f #f])
      (lambda (posX posY)
        (unless f
          (set! f
            (foreign-procedure #f "DrawFPS"
              (integer-32 integer-32)
              void)))
        (f posX posY))))
  (define DrawText
    (let ([f #f])
      (lambda (text posX posY fontSize color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawText"
              (string integer-32 integer-32 integer-32 (& Color))
              void)))
        (f text posX posY fontSize color))))
  (define DrawTextEx
    (let ([f #f])
      (lambda (font text position fontSize spacing tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextEx"
              ((& Font)
               string
               (& Vector2)
               single-float
               single-float
               (& Color))
              void)))
        (f font text position fontSize spacing tint))))
  (define DrawTextPro
    (let ([f #f])
      (lambda (font text position origin rotation fontSize spacing
               tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextPro"
              ((& Font)
               string
               (& Vector2)
               (& Vector2)
               single-float
               single-float
               single-float
               (& Color))
              void)))
        (f font text position origin rotation fontSize spacing
           tint))))
  (define DrawTextCodepoint
    (let ([f #f])
      (lambda (font codepoint position fontSize tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextCodepoint"
              ((& Font) integer-32 (& Vector2) single-float (& Color))
              void)))
        (f font codepoint position fontSize tint))))
  (define DrawTextCodepoints
    (let ([f #f])
      (lambda (font codepoints codepointCount position fontSize
               spacing tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTextCodepoints"
              ((& Font)
               (* integer-32)
               integer-32
               (& Vector2)
               single-float
               single-float
               (& Color))
              void)))
        (f font codepoints codepointCount position fontSize spacing
           tint))))
  (define SetTextLineSpacing
    (let ([f #f])
      (lambda (spacing)
        (unless f
          (set! f
            (foreign-procedure #f "SetTextLineSpacing"
              (integer-32)
              void)))
        (f spacing))))
  (define MeasureText
    (let ([f #f])
      (lambda (text fontSize)
        (unless f
          (set! f
            (foreign-procedure #f "MeasureText"
              (string integer-32)
              integer-32)))
        (f text fontSize))))
  (define MeasureTextEx
    (let ([f #f])
      (lambda (font text fontSize spacing)
        (unless f
          (set! f
            (foreign-procedure #f "MeasureTextEx"
              ((& Font) string single-float single-float)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res font text fontSize spacing)
          ret-res))))
  (define MeasureTextCodepoints
    (let ([f #f])
      (lambda (font codepoints length fontSize spacing)
        (unless f
          (set! f
            (foreign-procedure #f "MeasureTextCodepoints"
              ((& Font)
               (* integer-32)
               integer-32
               single-float
               single-float)
              (& Vector2))))
        (let ([ret-res (make-ftype-pointer
                         Vector2
                         (foreign-alloc (ftype-sizeof Vector2)))])
          (f ret-res font codepoints length fontSize spacing)
          ret-res))))
  (define GetGlyphIndex
    (let ([f #f])
      (lambda (font codepoint)
        (unless f
          (set! f
            (foreign-procedure #f "GetGlyphIndex"
              ((& Font) integer-32)
              integer-32)))
        (f font codepoint))))
  (define GetGlyphInfo
    (let ([f #f])
      (lambda (font codepoint)
        (unless f
          (set! f
            (foreign-procedure #f "GetGlyphInfo"
              ((& Font) integer-32)
              (& GlyphInfo))))
        (let ([ret-res (make-ftype-pointer
                         GlyphInfo
                         (foreign-alloc (ftype-sizeof GlyphInfo)))])
          (f ret-res font codepoint)
          ret-res))))
  (define GetGlyphAtlasRec
    (let ([f #f])
      (lambda (font codepoint)
        (unless f
          (set! f
            (foreign-procedure #f "GetGlyphAtlasRec"
              ((& Font) integer-32)
              (& Rectangle))))
        (let ([ret-res (make-ftype-pointer
                         Rectangle
                         (foreign-alloc (ftype-sizeof Rectangle)))])
          (f ret-res font codepoint)
          ret-res))))
  (define LoadUTF8
    (let ([f #f])
      (lambda (codepoints length)
        (unless f
          (set! f
            (foreign-procedure #f "LoadUTF8"
              ((* integer-32) integer-32)
              string)))
        (f codepoints length))))
  (define UnloadUTF8
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f (foreign-procedure #f "UnloadUTF8" (string) void)))
        (f text))))
  (define LoadCodepoints
    (let ([f #f])
      (lambda (text count)
        (unless f
          (set! f
            (foreign-procedure #f "LoadCodepoints"
              (string (* integer-32))
              (* integer-32))))
        (f text count))))
  (define UnloadCodepoints
    (let ([f #f])
      (lambda (codepoints)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadCodepoints"
              ((* integer-32))
              void)))
        (f codepoints))))
  (define GetCodepointCount
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "GetCodepointCount"
              (string)
              integer-32)))
        (f text))))
  (define GetCodepoint
    (let ([f #f])
      (lambda (text codepointSize)
        (unless f
          (set! f
            (foreign-procedure #f "GetCodepoint"
              (string (* integer-32))
              integer-32)))
        (f text codepointSize))))
  (define GetCodepointNext
    (let ([f #f])
      (lambda (text codepointSize)
        (unless f
          (set! f
            (foreign-procedure #f "GetCodepointNext"
              (string (* integer-32))
              integer-32)))
        (f text codepointSize))))
  (define GetCodepointPrevious
    (let ([f #f])
      (lambda (text codepointSize)
        (unless f
          (set! f
            (foreign-procedure #f "GetCodepointPrevious"
              (string (* integer-32))
              integer-32)))
        (f text codepointSize))))
  (define CodepointToUTF8
    (let ([f #f])
      (lambda (codepoint utf8Size)
        (unless f
          (set! f
            (foreign-procedure #f "CodepointToUTF8"
              (integer-32 (* integer-32))
              string)))
        (f codepoint utf8Size))))
  (define LoadTextLines
    (let ([f #f])
      (lambda (text count)
        (unless f
          (set! f
            (foreign-procedure #f "LoadTextLines"
              (string (* integer-32))
              (* *char))))
        (f text count))))
  (define UnloadTextLines
    (let ([f #f])
      (lambda (text lineCount)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadTextLines"
              ((* *char) integer-32)
              void)))
        (f text lineCount))))
  (define TextCopy
    (let ([f #f])
      (lambda (dst src)
        (unless f
          (set! f
            (foreign-procedure #f "TextCopy"
              (string string)
              integer-32)))
        (f dst src))))
  (define TextIsEqual
    (let ([f #f])
      (lambda (text1 text2)
        (unless f
          (set! f
            (foreign-procedure #f "TextIsEqual"
              (string string)
              stdbool)))
        (f text1 text2))))
  (define TextLength
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextLength" (string) unsigned-32)))
        (f text))))
  (define TextFormat
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextFormat" (string) string)))
        (f text))))
  (define TextSubtext
    (let ([f #f])
      (lambda (text position length)
        (unless f
          (set! f
            (foreign-procedure #f "TextSubtext"
              (string integer-32 integer-32)
              string)))
        (f text position length))))
  (define TextRemoveSpaces
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextRemoveSpaces" (string) string)))
        (f text))))
  (define GetTextBetween
    (let ([f #f])
      (lambda (text begin end)
        (unless f
          (set! f
            (foreign-procedure #f "GetTextBetween"
              (string string string)
              string)))
        (f text begin end))))
  (define TextReplace
    (let ([f #f])
      (lambda (text search replacement)
        (unless f
          (set! f
            (foreign-procedure #f "TextReplace"
              (string string string)
              string)))
        (f text search replacement))))
  (define TextReplaceAlloc
    (let ([f #f])
      (lambda (text search replacement)
        (unless f
          (set! f
            (foreign-procedure #f "TextReplaceAlloc"
              (string string string)
              string)))
        (f text search replacement))))
  (define TextReplaceBetween
    (let ([f #f])
      (lambda (text begin end replacement)
        (unless f
          (set! f
            (foreign-procedure #f "TextReplaceBetween"
              (string string string string)
              string)))
        (f text begin end replacement))))
  (define TextReplaceBetweenAlloc
    (let ([f #f])
      (lambda (text begin end replacement)
        (unless f
          (set! f
            (foreign-procedure #f "TextReplaceBetweenAlloc"
              (string string string string)
              string)))
        (f text begin end replacement))))
  (define TextInsert
    (let ([f #f])
      (lambda (text insert position)
        (unless f
          (set! f
            (foreign-procedure #f "TextInsert"
              (string string integer-32)
              string)))
        (f text insert position))))
  (define TextInsertAlloc
    (let ([f #f])
      (lambda (text insert position)
        (unless f
          (set! f
            (foreign-procedure #f "TextInsertAlloc"
              (string string integer-32)
              string)))
        (f text insert position))))
  (define TextJoin
    (let ([f #f])
      (lambda (textList count delimiter)
        (unless f
          (set! f
            (foreign-procedure #f "TextJoin"
              ((* *char) integer-32 string)
              string)))
        (f textList count delimiter))))
  (define TextSplit
    (let ([f #f])
      (lambda (text delimiter count)
        (unless f
          (set! f
            (foreign-procedure #f "TextSplit"
              (string char (* integer-32))
              (* *char))))
        (f text delimiter count))))
  (define TextAppend
    (let ([f #f])
      (lambda (text append position)
        (unless f
          (set! f
            (foreign-procedure #f "TextAppend"
              (string string (* integer-32))
              void)))
        (f text append position))))
  (define TextFindIndex
    (let ([f #f])
      (lambda (text search)
        (unless f
          (set! f
            (foreign-procedure #f "TextFindIndex"
              (string string)
              integer-32)))
        (f text search))))
  (define TextToUpper
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextToUpper" (string) string)))
        (f text))))
  (define TextToLower
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextToLower" (string) string)))
        (f text))))
  (define TextToPascal
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextToPascal" (string) string)))
        (f text))))
  (define TextToSnake
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextToSnake" (string) string)))
        (f text))))
  (define TextToCamel
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextToCamel" (string) string)))
        (f text))))
  (define TextToInteger
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextToInteger" (string) integer-32)))
        (f text))))
  (define TextToFloat
    (let ([f #f])
      (lambda (text)
        (unless f
          (set! f
            (foreign-procedure #f "TextToFloat" (string) single-float)))
        (f text))))
  (define DrawLine3D
    (let ([f #f])
      (lambda (startPos endPos color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawLine3D"
              ((& Vector3) (& Vector3) (& Color))
              void)))
        (f startPos endPos color))))
  (define DrawPoint3D
    (let ([f #f])
      (lambda (position color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawPoint3D"
              ((& Vector3) (& Color))
              void)))
        (f position color))))
  (define DrawCircle3D
    (let ([f #f])
      (lambda (center radius rotationAxis rotationAngle color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCircle3D"
              ((& Vector3)
               single-float
               (& Vector3)
               single-float
               (& Color))
              void)))
        (f center radius rotationAxis rotationAngle color))))
  (define DrawTriangle3D
    (let ([f #f])
      (lambda (v1 v2 v3 color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangle3D"
              ((& Vector3) (& Vector3) (& Vector3) (& Color))
              void)))
        (f v1 v2 v3 color))))
  (define DrawTriangleStrip3D
    (let ([f #f])
      (lambda (points pointCount color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawTriangleStrip3D"
              ((* Vector3) integer-32 (& Color))
              void)))
        (f points pointCount color))))
  (define DrawCube
    (let ([f #f])
      (lambda (position width height length color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCube"
              ((& Vector3)
               single-float
               single-float
               single-float
               (& Color))
              void)))
        (f position width height length color))))
  (define DrawCubeV
    (let ([f #f])
      (lambda (position size color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCubeV"
              ((& Vector3) (& Vector3) (& Color))
              void)))
        (f position size color))))
  (define DrawCubeWires
    (let ([f #f])
      (lambda (position width height length color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCubeWires"
              ((& Vector3)
               single-float
               single-float
               single-float
               (& Color))
              void)))
        (f position width height length color))))
  (define DrawCubeWiresV
    (let ([f #f])
      (lambda (position size color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCubeWiresV"
              ((& Vector3) (& Vector3) (& Color))
              void)))
        (f position size color))))
  (define DrawSphere
    (let ([f #f])
      (lambda (centerPos radius color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSphere"
              ((& Vector3) single-float (& Color))
              void)))
        (f centerPos radius color))))
  (define DrawSphereEx
    (let ([f #f])
      (lambda (centerPos radius rings slices color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSphereEx"
              ((& Vector3) single-float integer-32 integer-32 (& Color))
              void)))
        (f centerPos radius rings slices color))))
  (define DrawSphereWires
    (let ([f #f])
      (lambda (centerPos radius rings slices color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawSphereWires"
              ((& Vector3) single-float integer-32 integer-32 (& Color))
              void)))
        (f centerPos radius rings slices color))))
  (define DrawCylinder
    (let ([f #f])
      (lambda (position radiusTop radiusBottom height sides color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCylinder"
              ((& Vector3)
               single-float
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f position radiusTop radiusBottom height sides color))))
  (define DrawCylinderEx
    (let ([f #f])
      (lambda (startPos endPos startRadius endRadius sides color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCylinderEx"
              ((& Vector3)
               (& Vector3)
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f startPos endPos startRadius endRadius sides color))))
  (define DrawCylinderWires
    (let ([f #f])
      (lambda (position radiusTop radiusBottom height sides color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCylinderWires"
              ((& Vector3)
               single-float
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f position radiusTop radiusBottom height sides color))))
  (define DrawCylinderWiresEx
    (let ([f #f])
      (lambda (startPos endPos startRadius endRadius sides color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCylinderWiresEx"
              ((& Vector3)
               (& Vector3)
               single-float
               single-float
               integer-32
               (& Color))
              void)))
        (f startPos endPos startRadius endRadius sides color))))
  (define DrawCapsule
    (let ([f #f])
      (lambda (startPos endPos radius rings slices color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCapsule"
              ((& Vector3)
               (& Vector3)
               single-float
               integer-32
               integer-32
               (& Color))
              void)))
        (f startPos endPos radius rings slices color))))
  (define DrawCapsuleWires
    (let ([f #f])
      (lambda (startPos endPos radius rings slices color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawCapsuleWires"
              ((& Vector3)
               (& Vector3)
               single-float
               integer-32
               integer-32
               (& Color))
              void)))
        (f startPos endPos radius rings slices color))))
  (define DrawPlane
    (let ([f #f])
      (lambda (centerPos size color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawPlane"
              ((& Vector3) (& Vector2) (& Color))
              void)))
        (f centerPos size color))))
  (define DrawRay
    (let ([f #f])
      (lambda (ray color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawRay" ((& Ray) (& Color)) void)))
        (f ray color))))
  (define DrawGrid
    (let ([f #f])
      (lambda (slices spacing)
        (unless f
          (set! f
            (foreign-procedure #f "DrawGrid"
              (integer-32 single-float)
              void)))
        (f slices spacing))))
  (define LoadModel
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadModel" (string) (& Model))))
        (let ([ret-res (make-ftype-pointer
                         Model
                         (foreign-alloc (ftype-sizeof Model)))])
          (f ret-res fileName)
          ret-res))))
  (define LoadModelFromMesh
    (let ([f #f])
      (lambda (mesh)
        (unless f
          (set! f
            (foreign-procedure #f "LoadModelFromMesh"
              ((& Mesh))
              (& Model))))
        (let ([ret-res (make-ftype-pointer
                         Model
                         (foreign-alloc (ftype-sizeof Model)))])
          (f ret-res mesh)
          ret-res))))
  (define IsModelValid
    (let ([f #f])
      (lambda (model)
        (unless f
          (set! f
            (foreign-procedure #f "IsModelValid" ((& Model)) stdbool)))
        (f model))))
  (define UnloadModel
    (let ([f #f])
      (lambda (model)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadModel" ((& Model)) void)))
        (f model))))
  (define GetModelBoundingBox
    (let ([f #f])
      (lambda (model)
        (unless f
          (set! f
            (foreign-procedure #f "GetModelBoundingBox"
              ((& Model))
              (& BoundingBox))))
        (let ([ret-res (make-ftype-pointer
                         BoundingBox
                         (foreign-alloc (ftype-sizeof BoundingBox)))])
          (f ret-res model)
          ret-res))))
  (define DrawModel
    (let ([f #f])
      (lambda (model position scale tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawModel"
              ((& Model) (& Vector3) single-float (& Color))
              void)))
        (f model position scale tint))))
  (define DrawModelEx
    (let ([f #f])
      (lambda (model position rotationAxis rotationAngle scale
               tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawModelEx"
              ((& Model)
               (& Vector3)
               (& Vector3)
               single-float
               (& Vector3)
               (& Color))
              void)))
        (f model position rotationAxis rotationAngle scale tint))))
  (define DrawModelWires
    (let ([f #f])
      (lambda (model position scale tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawModelWires"
              ((& Model) (& Vector3) single-float (& Color))
              void)))
        (f model position scale tint))))
  (define DrawModelWiresEx
    (let ([f #f])
      (lambda (model position rotationAxis rotationAngle scale
               tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawModelWiresEx"
              ((& Model)
               (& Vector3)
               (& Vector3)
               single-float
               (& Vector3)
               (& Color))
              void)))
        (f model position rotationAxis rotationAngle scale tint))))
  (define DrawBoundingBox
    (let ([f #f])
      (lambda (box color)
        (unless f
          (set! f
            (foreign-procedure #f "DrawBoundingBox"
              ((& BoundingBox) (& Color))
              void)))
        (f box color))))
  (define DrawBillboard
    (let ([f #f])
      (lambda (camera texture position scale tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawBillboard"
              ((& Camera)
               (& Texture2D)
               (& Vector3)
               single-float
               (& Color))
              void)))
        (f camera texture position scale tint))))
  (define DrawBillboardRec
    (let ([f #f])
      (lambda (camera texture rec position size tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawBillboardRec"
              ((& Camera)
               (& Texture2D)
               (& Rectangle)
               (& Vector3)
               (& Vector2)
               (& Color))
              void)))
        (f camera texture rec position size tint))))
  (define DrawBillboardPro
    (let ([f #f])
      (lambda (camera texture rec position up size origin rotation
               tint)
        (unless f
          (set! f
            (foreign-procedure #f "DrawBillboardPro"
              ((& Camera)
               (& Texture2D)
               (& Rectangle)
               (& Vector3)
               (& Vector3)
               (& Vector2)
               (& Vector2)
               single-float
               (& Color))
              void)))
        (f camera texture rec position up size origin rotation
           tint))))
  (define UploadMesh
    (let ([f #f])
      (lambda (mesh dynamic)
        (unless f
          (set! f
            (foreign-procedure #f "UploadMesh"
              ((* Mesh) stdbool)
              void)))
        (f mesh dynamic))))
  (define UpdateMeshBuffer
    (let ([f #f])
      (lambda (mesh index data dataSize offset)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateMeshBuffer"
              ((& Mesh) integer-32 void* integer-32 integer-32)
              void)))
        (f mesh index data dataSize offset))))
  (define UnloadMesh
    (let ([f #f])
      (lambda (mesh)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadMesh" ((& Mesh)) void)))
        (f mesh))))
  (define DrawMesh
    (let ([f #f])
      (lambda (mesh material transform)
        (unless f
          (set! f
            (foreign-procedure #f "DrawMesh"
              ((& Mesh) (& Material) (& Matrix))
              void)))
        (f mesh material transform))))
  (define DrawMeshInstanced
    (let ([f #f])
      (lambda (mesh material transforms instances)
        (unless f
          (set! f
            (foreign-procedure #f "DrawMeshInstanced"
              ((& Mesh) (& Material) (* Matrix) integer-32)
              void)))
        (f mesh material transforms instances))))
  (define GetMeshBoundingBox
    (let ([f #f])
      (lambda (mesh)
        (unless f
          (set! f
            (foreign-procedure #f "GetMeshBoundingBox"
              ((& Mesh))
              (& BoundingBox))))
        (let ([ret-res (make-ftype-pointer
                         BoundingBox
                         (foreign-alloc (ftype-sizeof BoundingBox)))])
          (f ret-res mesh)
          ret-res))))
  (define GenMeshTangents
    (let ([f #f])
      (lambda (mesh)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshTangents" ((* Mesh)) void)))
        (f mesh))))
  (define ExportMesh
    (let ([f #f])
      (lambda (mesh fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportMesh"
              ((& Mesh) string)
              stdbool)))
        (f mesh fileName))))
  (define ExportMeshAsCode
    (let ([f #f])
      (lambda (mesh fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportMeshAsCode"
              ((& Mesh) string)
              stdbool)))
        (f mesh fileName))))
  (define GenMeshPoly
    (let ([f #f])
      (lambda (sides radius)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshPoly"
              (integer-32 single-float)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res sides radius)
          ret-res))))
  (define GenMeshPlane
    (let ([f #f])
      (lambda (width length resX resZ)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshPlane"
              (single-float single-float integer-32 integer-32)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res width length resX resZ)
          ret-res))))
  (define GenMeshCube
    (let ([f #f])
      (lambda (width height length)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshCube"
              (single-float single-float single-float)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res width height length)
          ret-res))))
  (define GenMeshSphere
    (let ([f #f])
      (lambda (radius rings slices)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshSphere"
              (single-float integer-32 integer-32)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res radius rings slices)
          ret-res))))
  (define GenMeshHemiSphere
    (let ([f #f])
      (lambda (radius rings slices)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshHemiSphere"
              (single-float integer-32 integer-32)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res radius rings slices)
          ret-res))))
  (define GenMeshCylinder
    (let ([f #f])
      (lambda (radius height slices)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshCylinder"
              (single-float single-float integer-32)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res radius height slices)
          ret-res))))
  (define GenMeshCone
    (let ([f #f])
      (lambda (radius height slices)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshCone"
              (single-float single-float integer-32)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res radius height slices)
          ret-res))))
  (define GenMeshTorus
    (let ([f #f])
      (lambda (radius size radSeg sides)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshTorus"
              (single-float single-float integer-32 integer-32)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res radius size radSeg sides)
          ret-res))))
  (define GenMeshKnot
    (let ([f #f])
      (lambda (radius size radSeg sides)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshKnot"
              (single-float single-float integer-32 integer-32)
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res radius size radSeg sides)
          ret-res))))
  (define GenMeshHeightmap
    (let ([f #f])
      (lambda (heightmap size)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshHeightmap"
              ((& Image) (& Vector3))
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res heightmap size)
          ret-res))))
  (define GenMeshCubicmap
    (let ([f #f])
      (lambda (cubicmap cubeSize)
        (unless f
          (set! f
            (foreign-procedure #f "GenMeshCubicmap"
              ((& Image) (& Vector3))
              (& Mesh))))
        (let ([ret-res (make-ftype-pointer
                         Mesh
                         (foreign-alloc (ftype-sizeof Mesh)))])
          (f ret-res cubicmap cubeSize)
          ret-res))))
  (define LoadMaterials
    (let ([f #f])
      (lambda (fileName materialCount)
        (unless f
          (set! f
            (foreign-procedure #f "LoadMaterials"
              (string (* integer-32))
              (* Material))))
        (f fileName materialCount))))
  (define LoadMaterialDefault
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "LoadMaterialDefault"
              ()
              (& Material))))
        (let ([ret-res (make-ftype-pointer
                         Material
                         (foreign-alloc (ftype-sizeof Material)))])
          (f ret-res)
          ret-res))))
  (define IsMaterialValid
    (let ([f #f])
      (lambda (material)
        (unless f
          (set! f
            (foreign-procedure #f "IsMaterialValid"
              ((& Material))
              stdbool)))
        (f material))))
  (define UnloadMaterial
    (let ([f #f])
      (lambda (material)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadMaterial"
              ((& Material))
              void)))
        (f material))))
  (define SetMaterialTexture
    (let ([f #f])
      (lambda (material mapType texture)
        (unless f
          (set! f
            (foreign-procedure #f "SetMaterialTexture"
              ((* Material) integer-32 (& Texture2D))
              void)))
        (f material mapType texture))))
  (define SetModelMeshMaterial
    (let ([f #f])
      (lambda (model meshId materialId)
        (unless f
          (set! f
            (foreign-procedure #f "SetModelMeshMaterial"
              ((* Model) integer-32 integer-32)
              void)))
        (f model meshId materialId))))
  (define LoadModelAnimations
    (let ([f #f])
      (lambda (fileName animCount)
        (unless f
          (set! f
            (foreign-procedure #f "LoadModelAnimations"
              (string (* integer-32))
              (* ModelAnimation))))
        (f fileName animCount))))
  (define UpdateModelAnimation
    (let ([f #f])
      (lambda (model anim frame)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateModelAnimation"
              ((& Model) (& ModelAnimation) single-float)
              void)))
        (f model anim frame))))
  (define UpdateModelAnimationEx
    (let ([f #f])
      (lambda (model animA frameA animB frameB blend)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateModelAnimationEx"
              ((& Model)
               (& ModelAnimation)
               single-float
               (& ModelAnimation)
               single-float
               single-float)
              void)))
        (f model animA frameA animB frameB blend))))
  (define UnloadModelAnimations
    (let ([f #f])
      (lambda (animations animCount)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadModelAnimations"
              ((* ModelAnimation) integer-32)
              void)))
        (f animations animCount))))
  (define IsModelAnimationValid
    (let ([f #f])
      (lambda (model anim)
        (unless f
          (set! f
            (foreign-procedure #f "IsModelAnimationValid"
              ((& Model) (& ModelAnimation))
              stdbool)))
        (f model anim))))
  (define CheckCollisionSpheres
    (let ([f #f])
      (lambda (center1 radius1 center2 radius2)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionSpheres"
              ((& Vector3) single-float (& Vector3) single-float)
              stdbool)))
        (f center1 radius1 center2 radius2))))
  (define CheckCollisionBoxes
    (let ([f #f])
      (lambda (box1 box2)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionBoxes"
              ((& BoundingBox) (& BoundingBox))
              stdbool)))
        (f box1 box2))))
  (define CheckCollisionBoxSphere
    (let ([f #f])
      (lambda (box center radius)
        (unless f
          (set! f
            (foreign-procedure #f "CheckCollisionBoxSphere"
              ((& BoundingBox) (& Vector3) single-float)
              stdbool)))
        (f box center radius))))
  (define GetRayCollisionSphere
    (let ([f #f])
      (lambda (ray center radius)
        (unless f
          (set! f
            (foreign-procedure #f "GetRayCollisionSphere"
              ((& Ray) (& Vector3) single-float)
              (& RayCollision))))
        (let ([ret-res (make-ftype-pointer
                         RayCollision
                         (foreign-alloc (ftype-sizeof RayCollision)))])
          (f ret-res ray center radius)
          ret-res))))
  (define GetRayCollisionBox
    (let ([f #f])
      (lambda (ray box)
        (unless f
          (set! f
            (foreign-procedure #f "GetRayCollisionBox"
              ((& Ray) (& BoundingBox))
              (& RayCollision))))
        (let ([ret-res (make-ftype-pointer
                         RayCollision
                         (foreign-alloc (ftype-sizeof RayCollision)))])
          (f ret-res ray box)
          ret-res))))
  (define GetRayCollisionMesh
    (let ([f #f])
      (lambda (ray mesh transform)
        (unless f
          (set! f
            (foreign-procedure #f "GetRayCollisionMesh"
              ((& Ray) (& Mesh) (& Matrix))
              (& RayCollision))))
        (let ([ret-res (make-ftype-pointer
                         RayCollision
                         (foreign-alloc (ftype-sizeof RayCollision)))])
          (f ret-res ray mesh transform)
          ret-res))))
  (define GetRayCollisionTriangle
    (let ([f #f])
      (lambda (ray p1 p2 p3)
        (unless f
          (set! f
            (foreign-procedure #f "GetRayCollisionTriangle"
              ((& Ray) (& Vector3) (& Vector3) (& Vector3))
              (& RayCollision))))
        (let ([ret-res (make-ftype-pointer
                         RayCollision
                         (foreign-alloc (ftype-sizeof RayCollision)))])
          (f ret-res ray p1 p2 p3)
          ret-res))))
  (define GetRayCollisionQuad
    (let ([f #f])
      (lambda (ray p1 p2 p3 p4)
        (unless f
          (set! f
            (foreign-procedure #f "GetRayCollisionQuad"
              ((& Ray) (& Vector3) (& Vector3) (& Vector3) (& Vector3))
              (& RayCollision))))
        (let ([ret-res (make-ftype-pointer
                         RayCollision
                         (foreign-alloc (ftype-sizeof RayCollision)))])
          (f ret-res ray p1 p2 p3 p4)
          ret-res))))
  (define InitAudioDevice
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "InitAudioDevice" () void)))
        (f))))
  (define CloseAudioDevice
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f (foreign-procedure #f "CloseAudioDevice" () void)))
        (f))))
  (define IsAudioDeviceReady
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "IsAudioDeviceReady" () stdbool)))
        (f))))
  (define SetMasterVolume
    (let ([f #f])
      (lambda (volume)
        (unless f
          (set! f
            (foreign-procedure #f "SetMasterVolume"
              (single-float)
              void)))
        (f volume))))
  (define GetMasterVolume
    (let ([f #f])
      (lambda ()
        (unless f
          (set! f
            (foreign-procedure #f "GetMasterVolume" () single-float)))
        (f))))
  (define LoadWave
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadWave" (string) (& Wave))))
        (let ([ret-res (make-ftype-pointer
                         Wave
                         (foreign-alloc (ftype-sizeof Wave)))])
          (f ret-res fileName)
          ret-res))))
  (define LoadWaveFromMemory
    (let ([f #f])
      (lambda (fileType fileData dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "LoadWaveFromMemory"
              (string (* unsigned-8) integer-32)
              (& Wave))))
        (let ([ret-res (make-ftype-pointer
                         Wave
                         (foreign-alloc (ftype-sizeof Wave)))])
          (f ret-res fileType fileData dataSize)
          ret-res))))
  (define IsWaveValid
    (let ([f #f])
      (lambda (wave)
        (unless f
          (set! f
            (foreign-procedure #f "IsWaveValid" ((& Wave)) stdbool)))
        (f wave))))
  (define LoadSound
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadSound" (string) (& Sound))))
        (let ([ret-res (make-ftype-pointer
                         Sound
                         (foreign-alloc (ftype-sizeof Sound)))])
          (f ret-res fileName)
          ret-res))))
  (define LoadSoundFromWave
    (let ([f #f])
      (lambda (wave)
        (unless f
          (set! f
            (foreign-procedure #f "LoadSoundFromWave"
              ((& Wave))
              (& Sound))))
        (let ([ret-res (make-ftype-pointer
                         Sound
                         (foreign-alloc (ftype-sizeof Sound)))])
          (f ret-res wave)
          ret-res))))
  (define LoadSoundAlias
    (let ([f #f])
      (lambda (source)
        (unless f
          (set! f
            (foreign-procedure #f "LoadSoundAlias"
              ((& Sound))
              (& Sound))))
        (let ([ret-res (make-ftype-pointer
                         Sound
                         (foreign-alloc (ftype-sizeof Sound)))])
          (f ret-res source)
          ret-res))))
  (define IsSoundValid
    (let ([f #f])
      (lambda (sound)
        (unless f
          (set! f
            (foreign-procedure #f "IsSoundValid" ((& Sound)) stdbool)))
        (f sound))))
  (define UpdateSound
    (let ([f #f])
      (lambda (sound data frameCount)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateSound"
              ((& Sound) void* integer-32)
              void)))
        (f sound data frameCount))))
  (define UnloadWave
    (let ([f #f])
      (lambda (wave)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadWave" ((& Wave)) void)))
        (f wave))))
  (define UnloadSound
    (let ([f #f])
      (lambda (sound)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadSound" ((& Sound)) void)))
        (f sound))))
  (define UnloadSoundAlias
    (let ([f #f])
      (lambda (alias)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadSoundAlias" ((& Sound)) void)))
        (f alias))))
  (define ExportWave
    (let ([f #f])
      (lambda (wave fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportWave"
              ((& Wave) string)
              stdbool)))
        (f wave fileName))))
  (define ExportWaveAsCode
    (let ([f #f])
      (lambda (wave fileName)
        (unless f
          (set! f
            (foreign-procedure #f "ExportWaveAsCode"
              ((& Wave) string)
              stdbool)))
        (f wave fileName))))
  (define PlaySound
    (let ([f #f])
      (lambda (sound)
        (unless f
          (set! f
            (foreign-procedure #f "PlaySound" ((& Sound)) void)))
        (f sound))))
  (define StopSound
    (let ([f #f])
      (lambda (sound)
        (unless f
          (set! f
            (foreign-procedure #f "StopSound" ((& Sound)) void)))
        (f sound))))
  (define PauseSound
    (let ([f #f])
      (lambda (sound)
        (unless f
          (set! f
            (foreign-procedure #f "PauseSound" ((& Sound)) void)))
        (f sound))))
  (define ResumeSound
    (let ([f #f])
      (lambda (sound)
        (unless f
          (set! f
            (foreign-procedure #f "ResumeSound" ((& Sound)) void)))
        (f sound))))
  (define IsSoundPlaying
    (let ([f #f])
      (lambda (sound)
        (unless f
          (set! f
            (foreign-procedure #f "IsSoundPlaying"
              ((& Sound))
              stdbool)))
        (f sound))))
  (define SetSoundVolume
    (let ([f #f])
      (lambda (sound volume)
        (unless f
          (set! f
            (foreign-procedure #f "SetSoundVolume"
              ((& Sound) single-float)
              void)))
        (f sound volume))))
  (define SetSoundPitch
    (let ([f #f])
      (lambda (sound pitch)
        (unless f
          (set! f
            (foreign-procedure #f "SetSoundPitch"
              ((& Sound) single-float)
              void)))
        (f sound pitch))))
  (define SetSoundPan
    (let ([f #f])
      (lambda (sound pan)
        (unless f
          (set! f
            (foreign-procedure #f "SetSoundPan"
              ((& Sound) single-float)
              void)))
        (f sound pan))))
  (define WaveCopy
    (let ([f #f])
      (lambda (wave)
        (unless f
          (set! f
            (foreign-procedure #f "WaveCopy" ((& Wave)) (& Wave))))
        (let ([ret-res (make-ftype-pointer
                         Wave
                         (foreign-alloc (ftype-sizeof Wave)))])
          (f ret-res wave)
          ret-res))))
  (define WaveCrop
    (let ([f #f])
      (lambda (wave initFrame finalFrame)
        (unless f
          (set! f
            (foreign-procedure #f "WaveCrop"
              ((* Wave) integer-32 integer-32)
              void)))
        (f wave initFrame finalFrame))))
  (define WaveFormat
    (let ([f #f])
      (lambda (wave sampleRate sampleSize channels)
        (unless f
          (set! f
            (foreign-procedure #f "WaveFormat"
              ((* Wave) integer-32 integer-32 integer-32)
              void)))
        (f wave sampleRate sampleSize channels))))
  (define LoadWaveSamples
    (let ([f #f])
      (lambda (wave)
        (unless f
          (set! f
            (foreign-procedure #f "LoadWaveSamples"
              ((& Wave))
              (* single-float))))
        (f wave))))
  (define UnloadWaveSamples
    (let ([f #f])
      (lambda (samples)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadWaveSamples"
              ((* single-float))
              void)))
        (f samples))))
  (define LoadMusicStream
    (let ([f #f])
      (lambda (fileName)
        (unless f
          (set! f
            (foreign-procedure #f "LoadMusicStream"
              (string)
              (& Music))))
        (let ([ret-res (make-ftype-pointer
                         Music
                         (foreign-alloc (ftype-sizeof Music)))])
          (f ret-res fileName)
          ret-res))))
  (define LoadMusicStreamFromMemory
    (let ([f #f])
      (lambda (fileType data dataSize)
        (unless f
          (set! f
            (foreign-procedure #f "LoadMusicStreamFromMemory"
              (string (* unsigned-8) integer-32)
              (& Music))))
        (let ([ret-res (make-ftype-pointer
                         Music
                         (foreign-alloc (ftype-sizeof Music)))])
          (f ret-res fileType data dataSize)
          ret-res))))
  (define IsMusicValid
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "IsMusicValid" ((& Music)) stdbool)))
        (f music))))
  (define UnloadMusicStream
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadMusicStream"
              ((& Music))
              void)))
        (f music))))
  (define PlayMusicStream
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "PlayMusicStream" ((& Music)) void)))
        (f music))))
  (define IsMusicStreamPlaying
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "IsMusicStreamPlaying"
              ((& Music))
              stdbool)))
        (f music))))
  (define UpdateMusicStream
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateMusicStream"
              ((& Music))
              void)))
        (f music))))
  (define StopMusicStream
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "StopMusicStream" ((& Music)) void)))
        (f music))))
  (define PauseMusicStream
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "PauseMusicStream" ((& Music)) void)))
        (f music))))
  (define ResumeMusicStream
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "ResumeMusicStream"
              ((& Music))
              void)))
        (f music))))
  (define SeekMusicStream
    (let ([f #f])
      (lambda (music position)
        (unless f
          (set! f
            (foreign-procedure #f "SeekMusicStream"
              ((& Music) single-float)
              void)))
        (f music position))))
  (define SetMusicVolume
    (let ([f #f])
      (lambda (music volume)
        (unless f
          (set! f
            (foreign-procedure #f "SetMusicVolume"
              ((& Music) single-float)
              void)))
        (f music volume))))
  (define SetMusicPitch
    (let ([f #f])
      (lambda (music pitch)
        (unless f
          (set! f
            (foreign-procedure #f "SetMusicPitch"
              ((& Music) single-float)
              void)))
        (f music pitch))))
  (define SetMusicPan
    (let ([f #f])
      (lambda (music pan)
        (unless f
          (set! f
            (foreign-procedure #f "SetMusicPan"
              ((& Music) single-float)
              void)))
        (f music pan))))
  (define GetMusicTimeLength
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "GetMusicTimeLength"
              ((& Music))
              single-float)))
        (f music))))
  (define GetMusicTimePlayed
    (let ([f #f])
      (lambda (music)
        (unless f
          (set! f
            (foreign-procedure #f "GetMusicTimePlayed"
              ((& Music))
              single-float)))
        (f music))))
  (define LoadAudioStream
    (let ([f #f])
      (lambda (sampleRate sampleSize channels)
        (unless f
          (set! f
            (foreign-procedure #f "LoadAudioStream"
              (unsigned-32 unsigned-32 unsigned-32)
              (& AudioStream))))
        (let ([ret-res (make-ftype-pointer
                         AudioStream
                         (foreign-alloc (ftype-sizeof AudioStream)))])
          (f ret-res sampleRate sampleSize channels)
          ret-res))))
  (define IsAudioStreamValid
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "IsAudioStreamValid"
              ((& AudioStream))
              stdbool)))
        (f stream))))
  (define UnloadAudioStream
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "UnloadAudioStream"
              ((& AudioStream))
              void)))
        (f stream))))
  (define UpdateAudioStream
    (let ([f #f])
      (lambda (stream data frameCount)
        (unless f
          (set! f
            (foreign-procedure #f "UpdateAudioStream"
              ((& AudioStream) void* integer-32)
              void)))
        (f stream data frameCount))))
  (define IsAudioStreamProcessed
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "IsAudioStreamProcessed"
              ((& AudioStream))
              stdbool)))
        (f stream))))
  (define PlayAudioStream
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "PlayAudioStream"
              ((& AudioStream))
              void)))
        (f stream))))
  (define PauseAudioStream
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "PauseAudioStream"
              ((& AudioStream))
              void)))
        (f stream))))
  (define ResumeAudioStream
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "ResumeAudioStream"
              ((& AudioStream))
              void)))
        (f stream))))
  (define IsAudioStreamPlaying
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "IsAudioStreamPlaying"
              ((& AudioStream))
              stdbool)))
        (f stream))))
  (define StopAudioStream
    (let ([f #f])
      (lambda (stream)
        (unless f
          (set! f
            (foreign-procedure #f "StopAudioStream"
              ((& AudioStream))
              void)))
        (f stream))))
  (define SetAudioStreamVolume
    (let ([f #f])
      (lambda (stream volume)
        (unless f
          (set! f
            (foreign-procedure #f "SetAudioStreamVolume"
              ((& AudioStream) single-float)
              void)))
        (f stream volume))))
  (define SetAudioStreamPitch
    (let ([f #f])
      (lambda (stream pitch)
        (unless f
          (set! f
            (foreign-procedure #f "SetAudioStreamPitch"
              ((& AudioStream) single-float)
              void)))
        (f stream pitch))))
  (define SetAudioStreamPan
    (let ([f #f])
      (lambda (stream pan)
        (unless f
          (set! f
            (foreign-procedure #f "SetAudioStreamPan"
              ((& AudioStream) single-float)
              void)))
        (f stream pan))))
  (define SetAudioStreamBufferSizeDefault
    (let ([f #f])
      (lambda (size)
        (unless f
          (set! f
            (foreign-procedure #f "SetAudioStreamBufferSizeDefault"
              (integer-32)
              void)))
        (f size))))
  (define SetAudioStreamCallback
    (let ([f #f])
      (lambda (stream callback)
        (unless f
          (set! f
            (foreign-procedure #f "SetAudioStreamCallback"
              ((& AudioStream) void*)
              void)))
        (f stream callback))))
  (define AttachAudioStreamProcessor
    (let ([f #f])
      (lambda (stream processor)
        (unless f
          (set! f
            (foreign-procedure #f "AttachAudioStreamProcessor"
              ((& AudioStream) void*)
              void)))
        (f stream processor))))
  (define DetachAudioStreamProcessor
    (let ([f #f])
      (lambda (stream processor)
        (unless f
          (set! f
            (foreign-procedure #f "DetachAudioStreamProcessor"
              ((& AudioStream) void*)
              void)))
        (f stream processor))))
  (define AttachAudioMixedProcessor
    (let ([f #f])
      (lambda (processor)
        (unless f
          (set! f
            (foreign-procedure #f "AttachAudioMixedProcessor"
              (void*)
              void)))
        (f processor))))
  (define DetachAudioMixedProcessor
    (let ([f #f])
      (lambda (processor)
        (unless f
          (set! f
            (foreign-procedure #f "DetachAudioMixedProcessor"
              (void*)
              void)))
        (f processor)))))
