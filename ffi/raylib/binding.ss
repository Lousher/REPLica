(library (ffi raylib binding)
  (export
   RAYLIB_VERSION_MAJOR RAYLIB_VERSION_MINOR
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
   Vector2 Vector3 Vector4 Matrix Color Rectangle *Rectangle Image Texture
   RenderTexture NPatchInfo GlyphInfo Font Camera3D Camera2D
   Mesh Shader MaterialMap Material Transform BoneInfo
   ModelSkeleton Model ModelAnimation Ray RayCollision
   BoundingBox Wave AudioStream Sound Music VrDeviceInfo
   VrStereoConfig FilePathList AutomationEvent
   AutomationEventList Quaternion Texture2D TextureCubemap
   RenderTexture2D Camera ModelAnimPose TraceLogCallback
   LoadFileDataCallback SaveFileDataCallback
   LoadFileTextCallback SaveFileTextCallback AudioCallback
   InitWindow CloseWindow WindowShouldClose IsWindowReady
   IsWindowFullscreen IsWindowHidden IsWindowMinimized
   IsWindowMaximized IsWindowFocused IsWindowResized
   IsWindowState SetWindowState ClearWindowState
   ToggleFullscreen ToggleBorderlessWindowed MaximizeWindow
   MinimizeWindow RestoreWindow SetWindowIcon SetWindowIcons
   SetWindowTitle SetWindowPosition SetWindowMonitor
   SetWindowMinSize SetWindowMaxSize SetWindowSize
   SetWindowOpacity SetWindowFocused GetWindowHandle
   GetScreenWidth GetScreenHeight GetRenderWidth
   GetRenderHeight GetMonitorCount GetCurrentMonitor
   GetMonitorPosition GetMonitorWidth GetMonitorHeight
   GetMonitorPhysicalWidth GetMonitorPhysicalHeight
   GetMonitorRefreshRate GetWindowPosition GetWindowScaleDPI
   GetMonitorName SetClipboardText GetClipboardText
   GetClipboardImage EnableEventWaiting DisableEventWaiting
   ShowCursor HideCursor IsCursorHidden EnableCursor
   DisableCursor IsCursorOnScreen ClearBackground BeginDrawing
   EndDrawing BeginMode2D EndMode2D BeginMode3D EndMode3D
   BeginTextureMode EndTextureMode BeginShaderMode
   EndShaderMode BeginBlendMode EndBlendMode BeginScissorMode
   EndScissorMode BeginVrStereoMode EndVrStereoMode
   LoadVrStereoConfig UnloadVrStereoConfig LoadShader
   LoadShaderFromMemory IsShaderValid GetShaderLocation
   GetShaderLocationAttrib SetShaderValue SetShaderValueV
   SetShaderValueMatrix SetShaderValueTexture UnloadShader
   GetScreenToWorldRay GetScreenToWorldRayEx GetWorldToScreen
   GetWorldToScreenEx GetWorldToScreen2D GetScreenToWorld2D
   GetCameraMatrix GetCameraMatrix2D SetTargetFPS GetFrameTime
   GetTime GetFPS SwapScreenBuffer PollInputEvents WaitTime
   SetRandomSeed GetRandomValue LoadRandomSequence
   UnloadRandomSequence TakeScreenshot SetConfigFlags OpenURL
   SetTraceLogLevel TraceLog SetTraceLogCallback MemAlloc
   MemRealloc MemFree LoadFileData UnloadFileData SaveFileData
   ExportDataAsCode LoadFileText UnloadFileText SaveFileText
   SetLoadFileDataCallback SetSaveFileDataCallback
   SetLoadFileTextCallback SetSaveFileTextCallback FileRename
   FileRemove FileCopy FileMove FileTextReplace
   FileTextFindIndex FileExists DirectoryExists IsFileExtension
   GetFileLength GetFileModTime GetFileExtension GetFileName
   GetFileNameWithoutExt GetDirectoryPath GetPrevDirectoryPath
   GetWorkingDirectory GetApplicationDirectory MakeDirectory
   ChangeDirectory IsPathFile IsFileNameValid
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
   DrawLineDashed DrawCircle DrawCircleV DrawCircleGradient
   DrawCircleSector DrawCircleSectorLines DrawCircleLines
   DrawCircleLinesV DrawEllipse DrawEllipseV DrawEllipseLines
   DrawEllipseLinesV DrawRing DrawRingLines DrawRectangle
   DrawRectangleV DrawRectangleRec DrawRectanglePro
   DrawRectangleGradientV DrawRectangleGradientH
   DrawRectangleGradientEx DrawRectangleLines
   DrawRectangleLinesEx DrawRectangleRounded
   DrawRectangleRoundedLines DrawRectangleRoundedLinesEx
   DrawTriangle DrawTriangleLines DrawTriangleFan
   DrawTriangleStrip DrawPoly DrawPolyLines DrawPolyLinesEx
   DrawSplineLinear DrawSplineBasis DrawSplineCatmullRom
   DrawSplineBezierQuadratic DrawSplineBezierCubic
   DrawSplineSegmentLinear DrawSplineSegmentBasis
   DrawSplineSegmentCatmullRom DrawSplineSegmentBezierQuadratic
   DrawSplineSegmentBezierCubic GetSplinePointLinear
   GetSplinePointBasis GetSplinePointCatmullRom
   GetSplinePointBezierCubic CheckCollisionRecs
   CheckCollisionCircles CheckCollisionCircleRec
   CheckCollisionCircleLine CheckCollisionPointRec
   CheckCollisionPointCircle CheckCollisionPointTriangle
   CheckCollisionPointLine CheckCollisionPointPoly
   CheckCollisionLines GetCollisionRec LoadImage LoadImageRaw
   LoadImageAnim LoadImageAnimFromMemory LoadImageFromMemory
   LoadImageFromTexture LoadImageFromScreen IsImageValid
   UnloadImage ExportImage ExportImageToMemory
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
   ImageDrawLine ImageDrawLineV ImageDrawLineEx ImageDrawCircle
   ImageDrawCircleV ImageDrawCircleLines ImageDrawCircleLinesV
   ImageDrawRectangle ImageDrawRectangleV ImageDrawRectangleRec
   ImageDrawRectangleLines ImageDrawTriangle
   ImageDrawTriangleLines ImageDrawTriangleFan
   ImageDrawTriangleStrip ImageDraw ImageDrawText
   ImageDrawTextEx LoadTexture LoadTextureFromImage
   LoadTextureCubemap LoadRenderTexture IsTextureValid
   UnloadTexture IsRenderTextureValid UnloadRenderTexture
   UpdateTexture UpdateTextureRec GenTextureMipmaps
   SetTextureFilter SetTextureWrap DrawTexture DrawTextureV
   DrawTextureEx DrawTextureRec DrawTexturePro
   DrawTextureNPatch ColorIsEqual Fade ColorToInt
   ColorNormalize ColorFromNormalized ColorToHSV ColorFromHSV
   ColorTint ColorBrightness ColorContrast ColorAlpha
   ColorAlphaBlend ColorLerp GetColor GetPixelColor
   SetPixelColor GetPixelDataSize GetFontDefault LoadFont
   LoadFontEx LoadFontFromImage LoadFontFromMemory IsFontValid
   LoadFontData GenImageFontAtlas UnloadFontData UnloadFont
   ExportFontAsCode DrawFPS DrawText DrawTextEx DrawTextPro
   DrawTextCodepoint DrawTextCodepoints SetTextLineSpacing
   MeasureText MeasureTextEx MeasureTextCodepoints
   GetGlyphIndex GetGlyphInfo GetGlyphAtlasRec LoadUTF8
   UnloadUTF8 LoadCodepoints UnloadCodepoints GetCodepointCount
   GetCodepoint GetCodepointNext GetCodepointPrevious
   CodepointToUTF8 LoadTextLines UnloadTextLines TextCopy
   TextIsEqual TextLength TextFormat TextSubtext
   TextRemoveSpaces GetTextBetween TextReplace TextReplaceAlloc
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
  (define RAYLIB_VERSION_MINOR 1)
  (define RAYLIB_VERSION_PATCH 0)
  (define RAYLIB_VERSION "6.1-dev")
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
  (define-ftype rAudioProcessor (struct))
  (define-ftype rAudioBuffer (struct))
  (define-ftype TraceLogCallback
    (function (integer-32 string void*) void))
  (define-ftype LoadFileDataCallback
    (function (string (* integer-32)) (* unsigned-8)))
  (define-ftype SaveFileDataCallback
    (function (string void* integer-32) boolean))
  (define-ftype LoadFileTextCallback
    (function (string) string))
  (define-ftype SaveFileTextCallback
    (function (string string) boolean))
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
  (define-ftype *Rectangle (* Rectangle))
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
      [boneCount integer-32]
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
      [boneCount integer-32]
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
  (define InitWindow
    (foreign-procedure #f "InitWindow"
		       (integer-32 integer-32 string)
		       void))
  (define CloseWindow
    (foreign-procedure #f "CloseWindow" () void))
  (define WindowShouldClose
    (foreign-procedure #f "WindowShouldClose" () boolean))
  (define IsWindowReady
    (foreign-procedure #f "IsWindowReady" () boolean))
  (define IsWindowFullscreen
    (foreign-procedure #f "IsWindowFullscreen" () boolean))
  (define IsWindowHidden
    (foreign-procedure #f "IsWindowHidden" () boolean))
  (define IsWindowMinimized
    (foreign-procedure #f "IsWindowMinimized" () boolean))
  (define IsWindowMaximized
    (foreign-procedure #f "IsWindowMaximized" () boolean))
  (define IsWindowFocused
    (foreign-procedure #f "IsWindowFocused" () boolean))
  (define IsWindowResized
    (foreign-procedure #f "IsWindowResized" () boolean))
  (define IsWindowState
    (foreign-procedure #f "IsWindowState"
		       (unsigned-32)
		       boolean))
  (define SetWindowState
    (foreign-procedure #f "SetWindowState" (unsigned-32) void))
  (define ClearWindowState
    (foreign-procedure #f "ClearWindowState"
		       (unsigned-32)
		       void))
  (define ToggleFullscreen
    (foreign-procedure #f "ToggleFullscreen" () void))
  (define ToggleBorderlessWindowed
    (foreign-procedure #f "ToggleBorderlessWindowed" () void))
  (define MaximizeWindow
    (foreign-procedure #f "MaximizeWindow" () void))
  (define MinimizeWindow
    (foreign-procedure #f "MinimizeWindow" () void))
  (define RestoreWindow
    (foreign-procedure #f "RestoreWindow" () void))
  (define SetWindowIcon
    (foreign-procedure #f "SetWindowIcon" ((& Image)) void))
  (define SetWindowIcons
    (foreign-procedure #f "SetWindowIcons"
		       ((* Image) integer-32)
		       void))
  (define SetWindowTitle
    (foreign-procedure #f "SetWindowTitle" (string) void))
  (define SetWindowPosition
    (foreign-procedure #f "SetWindowPosition"
		       (integer-32 integer-32)
		       void))
  (define SetWindowMonitor
    (foreign-procedure #f "SetWindowMonitor" (integer-32) void))
  (define SetWindowMinSize
    (foreign-procedure #f "SetWindowMinSize"
		       (integer-32 integer-32)
		       void))
  (define SetWindowMaxSize
    (foreign-procedure #f "SetWindowMaxSize"
		       (integer-32 integer-32)
		       void))
  (define SetWindowSize
    (foreign-procedure #f "SetWindowSize"
		       (integer-32 integer-32)
		       void))
  (define SetWindowOpacity
    (foreign-procedure #f "SetWindowOpacity"
		       (single-float)
		       void))
  (define SetWindowFocused
    (foreign-procedure #f "SetWindowFocused" () void))
  (define GetWindowHandle
    (foreign-procedure #f "GetWindowHandle" () void*))
  (define GetScreenWidth
    (foreign-procedure #f "GetScreenWidth" () integer-32))
  (define GetScreenHeight
    (foreign-procedure #f "GetScreenHeight" () integer-32))
  (define GetRenderWidth
    (foreign-procedure #f "GetRenderWidth" () integer-32))
  (define GetRenderHeight
    (foreign-procedure #f "GetRenderHeight" () integer-32))
  (define GetMonitorCount
    (foreign-procedure #f "GetMonitorCount" () integer-32))
  (define GetCurrentMonitor
    (foreign-procedure #f "GetCurrentMonitor" () integer-32))
  (define GetMonitorPosition
    (let ([proc (foreign-procedure #f "GetMonitorPosition"
				   (integer-32)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetMonitorWidth
    (foreign-procedure #f "GetMonitorWidth"
		       (integer-32)
		       integer-32))
  (define GetMonitorHeight
    (foreign-procedure #f "GetMonitorHeight"
		       (integer-32)
		       integer-32))
  (define GetMonitorPhysicalWidth
    (foreign-procedure #f "GetMonitorPhysicalWidth"
		       (integer-32)
		       integer-32))
  (define GetMonitorPhysicalHeight
    (foreign-procedure #f "GetMonitorPhysicalHeight"
		       (integer-32)
		       integer-32))
  (define GetMonitorRefreshRate
    (foreign-procedure #f "GetMonitorRefreshRate"
		       (integer-32)
		       integer-32))
  (define GetWindowPosition
    (let ([proc (foreign-procedure #f "GetWindowPosition"
				   ()
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetWindowScaleDPI
    (let ([proc (foreign-procedure #f "GetWindowScaleDPI"
				   ()
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetMonitorName
    (foreign-procedure #f "GetMonitorName" (integer-32) string))
  (define SetClipboardText
    (foreign-procedure #f "SetClipboardText" (string) void))
  (define GetClipboardText
    (foreign-procedure #f "GetClipboardText" () string))
  (define GetClipboardImage
    (let ([proc (foreign-procedure #f "GetClipboardImage"
				   ()
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define EnableEventWaiting
    (foreign-procedure #f "EnableEventWaiting" () void))
  (define DisableEventWaiting
    (foreign-procedure #f "DisableEventWaiting" () void))
  (define ShowCursor
    (foreign-procedure #f "ShowCursor" () void))
  (define HideCursor
    (foreign-procedure #f "HideCursor" () void))
  (define IsCursorHidden
    (foreign-procedure #f "IsCursorHidden" () boolean))
  (define EnableCursor
    (foreign-procedure #f "EnableCursor" () void))
  (define DisableCursor
    (foreign-procedure #f "DisableCursor" () void))
  (define IsCursorOnScreen
    (foreign-procedure #f "IsCursorOnScreen" () boolean))
  (define ClearBackground
    (foreign-procedure #f "ClearBackground" ((& Color)) void))
  (define BeginDrawing
    (foreign-procedure #f "BeginDrawing" () void))
  (define EndDrawing
    (foreign-procedure #f "EndDrawing" () void))
  (define BeginMode2D
    (foreign-procedure #f "BeginMode2D" ((& Camera2D)) void))
  (define EndMode2D
    (foreign-procedure #f "EndMode2D" () void))
  (define BeginMode3D
    (foreign-procedure #f "BeginMode3D" ((& Camera3D)) void))
  (define EndMode3D
    (foreign-procedure #f "EndMode3D" () void))
  (define BeginTextureMode
    (foreign-procedure #f "BeginTextureMode"
		       ((& RenderTexture2D))
		       void))
  (define EndTextureMode
    (foreign-procedure #f "EndTextureMode" () void))
  (define BeginShaderMode
    (foreign-procedure #f "BeginShaderMode" ((& Shader)) void))
  (define EndShaderMode
    (foreign-procedure #f "EndShaderMode" () void))
  (define BeginBlendMode
    (foreign-procedure #f "BeginBlendMode" (integer-32) void))
  (define EndBlendMode
    (foreign-procedure #f "EndBlendMode" () void))
  (define BeginScissorMode
    (foreign-procedure #f "BeginScissorMode"
		       (integer-32 integer-32 integer-32 integer-32)
		       void))
  (define EndScissorMode
    (foreign-procedure #f "EndScissorMode" () void))
  (define BeginVrStereoMode
    (foreign-procedure #f "BeginVrStereoMode"
		       ((& VrStereoConfig))
		       void))
  (define EndVrStereoMode
    (foreign-procedure #f "EndVrStereoMode" () void))
  (define LoadVrStereoConfig
    (let ([proc (foreign-procedure #f "LoadVrStereoConfig"
				   ((& VrDeviceInfo))
				   (& VrStereoConfig))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        VrStereoConfig
                        (foreign-alloc (ftype-sizeof VrStereoConfig)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define UnloadVrStereoConfig
    (foreign-procedure #f "UnloadVrStereoConfig"
		       ((& VrStereoConfig))
		       void))
  (define LoadShader
    (let ([proc (foreign-procedure #f "LoadShader"
				   (string string)
				   (& Shader))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Shader
                        (foreign-alloc (ftype-sizeof Shader)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadShaderFromMemory
    (let ([proc (foreign-procedure #f "LoadShaderFromMemory"
				   (string string)
				   (& Shader))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Shader
                        (foreign-alloc (ftype-sizeof Shader)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsShaderValid
    (foreign-procedure #f "IsShaderValid" ((& Shader)) boolean))
  (define GetShaderLocation
    (foreign-procedure #f "GetShaderLocation"
		       ((& Shader) string)
		       integer-32))
  (define GetShaderLocationAttrib
    (foreign-procedure #f "GetShaderLocationAttrib"
		       ((& Shader) string)
		       integer-32))
  (define SetShaderValue
    (foreign-procedure #f "SetShaderValue"
		       ((& Shader) integer-32 void* integer-32)
		       void))
  (define SetShaderValueV
    (foreign-procedure #f "SetShaderValueV"
		       ((& Shader) integer-32 void* integer-32 integer-32)
		       void))
  (define SetShaderValueMatrix
    (foreign-procedure #f "SetShaderValueMatrix"
		       ((& Shader) integer-32 (& Matrix))
		       void))
  (define SetShaderValueTexture
    (foreign-procedure #f "SetShaderValueTexture"
		       ((& Shader) integer-32 (& Texture2D))
		       void))
  (define UnloadShader
    (foreign-procedure #f "UnloadShader" ((& Shader)) void))
  (define GetScreenToWorldRay
    (let ([proc (foreign-procedure #f "GetScreenToWorldRay"
				   ((& Vector2) (& Camera))
				   (& Ray))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Ray
                        (foreign-alloc (ftype-sizeof Ray)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetScreenToWorldRayEx
    (let ([proc (foreign-procedure #f "GetScreenToWorldRayEx"
				   ((& Vector2) (& Camera) integer-32 integer-32)
				   (& Ray))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Ray
                        (foreign-alloc (ftype-sizeof Ray)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetWorldToScreen
    (let ([proc (foreign-procedure #f "GetWorldToScreen"
				   ((& Vector3) (& Camera))
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetWorldToScreenEx
    (let ([proc (foreign-procedure #f "GetWorldToScreenEx"
				   ((& Vector3) (& Camera) integer-32 integer-32)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetWorldToScreen2D
    (let ([proc (foreign-procedure #f "GetWorldToScreen2D"
				   ((& Vector2) (& Camera2D))
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetScreenToWorld2D
    (let ([proc (foreign-procedure #f "GetScreenToWorld2D"
				   ((& Vector2) (& Camera2D))
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetCameraMatrix
    (let ([proc (foreign-procedure #f "GetCameraMatrix"
				   ((& Camera))
				   (& Matrix))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Matrix
                        (foreign-alloc (ftype-sizeof Matrix)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetCameraMatrix2D
    (let ([proc (foreign-procedure #f "GetCameraMatrix2D"
				   ((& Camera2D))
				   (& Matrix))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Matrix
                        (foreign-alloc (ftype-sizeof Matrix)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define SetTargetFPS
    (foreign-procedure #f "SetTargetFPS" (integer-32) void))
  (define GetFrameTime
    (foreign-procedure #f "GetFrameTime" () single-float))
  (define GetTime
    (foreign-procedure #f "GetTime" () double-float))
  (define GetFPS
    (foreign-procedure #f "GetFPS" () integer-32))
  (define SwapScreenBuffer
    (foreign-procedure #f "SwapScreenBuffer" () void))
  (define PollInputEvents
    (foreign-procedure #f "PollInputEvents" () void))
  (define WaitTime
    (foreign-procedure #f "WaitTime" (double-float) void))
  (define SetRandomSeed
    (foreign-procedure #f "SetRandomSeed" (unsigned-32) void))
  (define GetRandomValue
    (foreign-procedure #f "GetRandomValue"
		       (integer-32 integer-32)
		       integer-32))
  (define LoadRandomSequence
    (foreign-procedure #f "LoadRandomSequence"
		       (unsigned-32 integer-32 integer-32)
		       (* integer-32)))
  (define UnloadRandomSequence
    (foreign-procedure #f "UnloadRandomSequence"
		       ((* integer-32))
		       void))
  (define TakeScreenshot
    (foreign-procedure #f "TakeScreenshot" (string) void))
  (define SetConfigFlags
    (foreign-procedure #f "SetConfigFlags" (unsigned-32) void))
  (define OpenURL
    (foreign-procedure #f "OpenURL" (string) void))
  (define SetTraceLogLevel
    (foreign-procedure #f "SetTraceLogLevel" (integer-32) void))
  (define TraceLog
    (foreign-procedure #f "TraceLog" (integer-32 string) void))
  (define SetTraceLogCallback
    (foreign-procedure #f "SetTraceLogCallback"
		       ((* TraceLogCallback))
		       void))
  (define MemAlloc
    (foreign-procedure #f "MemAlloc" (unsigned-32) void*))
  (define MemRealloc
    (foreign-procedure #f "MemRealloc"
		       (void* unsigned-32)
		       void*))
  (define MemFree
    (foreign-procedure #f "MemFree" (void*) void))
  (define LoadFileData
    (foreign-procedure #f "LoadFileData"
		       (string (* integer-32))
		       (* unsigned-8)))
  (define UnloadFileData
    (foreign-procedure #f "UnloadFileData"
		       ((* unsigned-8))
		       void))
  (define SaveFileData
    (foreign-procedure #f "SaveFileData"
		       (string void* integer-32)
		       boolean))
  (define ExportDataAsCode
    (foreign-procedure #f "ExportDataAsCode"
		       ((* unsigned-8) integer-32 string)
		       boolean))
  (define LoadFileText
    (foreign-procedure #f "LoadFileText" (string) string))
  (define UnloadFileText
    (foreign-procedure #f "UnloadFileText" (string) void))
  (define SaveFileText
    (foreign-procedure #f "SaveFileText"
		       (string string)
		       boolean))
  (define SetLoadFileDataCallback
    (foreign-procedure #f "SetLoadFileDataCallback"
		       ((* LoadFileDataCallback))
		       void))
  (define SetSaveFileDataCallback
    (foreign-procedure #f "SetSaveFileDataCallback"
		       ((* SaveFileDataCallback))
		       void))
  (define SetLoadFileTextCallback
    (foreign-procedure #f "SetLoadFileTextCallback"
		       ((* LoadFileTextCallback))
		       void))
  (define SetSaveFileTextCallback
    (foreign-procedure #f "SetSaveFileTextCallback"
		       ((* SaveFileTextCallback))
		       void))
  (define FileRename
    (foreign-procedure #f "FileRename"
		       (string string)
		       integer-32))
  (define FileRemove
    (foreign-procedure #f "FileRemove" (string) integer-32))
  (define FileCopy
    (foreign-procedure #f "FileCopy"
		       (string string)
		       integer-32))
  (define FileMove
    (foreign-procedure #f "FileMove"
		       (string string)
		       integer-32))
  (define FileTextReplace
    (foreign-procedure #f "FileTextReplace"
		       (string string string)
		       integer-32))
  (define FileTextFindIndex
    (foreign-procedure #f "FileTextFindIndex"
		       (string string)
		       integer-32))
  (define FileExists
    (foreign-procedure #f "FileExists" (string) boolean))
  (define DirectoryExists
    (foreign-procedure #f "DirectoryExists" (string) boolean))
  (define IsFileExtension
    (foreign-procedure #f "IsFileExtension"
		       (string string)
		       boolean))
  (define GetFileLength
    (foreign-procedure #f "GetFileLength" (string) integer-32))
  (define GetFileModTime
    (foreign-procedure #f "GetFileModTime" (string) long))
  (define GetFileExtension
    (foreign-procedure #f "GetFileExtension" (string) string))
  (define GetFileName
    (foreign-procedure #f "GetFileName" (string) string))
  (define GetFileNameWithoutExt
    (foreign-procedure #f "GetFileNameWithoutExt"
		       (string)
		       string))
  (define GetDirectoryPath
    (foreign-procedure #f "GetDirectoryPath" (string) string))
  (define GetPrevDirectoryPath
    (foreign-procedure #f "GetPrevDirectoryPath"
		       (string)
		       string))
  (define GetWorkingDirectory
    (foreign-procedure #f "GetWorkingDirectory" () string))
  (define GetApplicationDirectory
    (foreign-procedure #f "GetApplicationDirectory" () string))
  (define MakeDirectory
    (foreign-procedure #f "MakeDirectory" (string) integer-32))
  (define ChangeDirectory
    (foreign-procedure #f "ChangeDirectory" (string) boolean))
  (define IsPathFile
    (foreign-procedure #f "IsPathFile" (string) boolean))
  (define IsFileNameValid
    (foreign-procedure #f "IsFileNameValid" (string) boolean))
  (define LoadDirectoryFiles
    (let ([proc (foreign-procedure #f "LoadDirectoryFiles"
				   (string)
				   (& FilePathList))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        FilePathList
                        (foreign-alloc (ftype-sizeof FilePathList)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadDirectoryFilesEx
    (let ([proc (foreign-procedure #f "LoadDirectoryFilesEx"
				   (string string boolean)
				   (& FilePathList))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        FilePathList
                        (foreign-alloc (ftype-sizeof FilePathList)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define UnloadDirectoryFiles
    (foreign-procedure #f "UnloadDirectoryFiles"
		       ((& FilePathList))
		       void))
  (define IsFileDropped
    (foreign-procedure #f "IsFileDropped" () boolean))
  (define LoadDroppedFiles
    (let ([proc (foreign-procedure #f "LoadDroppedFiles"
				   ()
				   (& FilePathList))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        FilePathList
                        (foreign-alloc (ftype-sizeof FilePathList)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define UnloadDroppedFiles
    (foreign-procedure #f "UnloadDroppedFiles"
		       ((& FilePathList))
		       void))
  (define GetDirectoryFileCount
    (foreign-procedure #f "GetDirectoryFileCount"
		       (string)
		       unsigned-32))
  (define GetDirectoryFileCountEx
    (foreign-procedure #f "GetDirectoryFileCountEx"
		       (string string boolean)
		       unsigned-32))
  (define CompressData
    (foreign-procedure #f "CompressData"
		       ((* unsigned-8) integer-32 (* integer-32))
		       (* unsigned-8)))
  (define DecompressData
    (foreign-procedure #f "DecompressData"
		       ((* unsigned-8) integer-32 (* integer-32))
		       (* unsigned-8)))
  (define EncodeDataBase64
    (foreign-procedure #f "EncodeDataBase64"
		       ((* unsigned-8) integer-32 (* integer-32))
		       string))
  (define DecodeDataBase64
    (foreign-procedure #f "DecodeDataBase64"
		       (string (* integer-32))
		       (* unsigned-8)))
  (define ComputeCRC32
    (foreign-procedure #f "ComputeCRC32"
		       ((* unsigned-8) integer-32)
		       unsigned-32))
  (define ComputeMD5
    (foreign-procedure #f "ComputeMD5"
		       ((* unsigned-8) integer-32)
		       (* unsigned-32)))
  (define ComputeSHA1
    (foreign-procedure #f "ComputeSHA1"
		       ((* unsigned-8) integer-32)
		       (* unsigned-32)))
  (define ComputeSHA256
    (foreign-procedure #f "ComputeSHA256"
		       ((* unsigned-8) integer-32)
		       (* unsigned-32)))
  (define LoadAutomationEventList
    (let ([proc (foreign-procedure #f "LoadAutomationEventList"
				   (string)
				   (& AutomationEventList))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        AutomationEventList
                        (foreign-alloc
                         (ftype-sizeof AutomationEventList)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define UnloadAutomationEventList
    (foreign-procedure #f "UnloadAutomationEventList"
		       ((& AutomationEventList))
		       void))
  (define ExportAutomationEventList
    (foreign-procedure #f "ExportAutomationEventList"
		       ((& AutomationEventList) string)
		       boolean))
  (define SetAutomationEventList
    (foreign-procedure #f "SetAutomationEventList"
		       ((* AutomationEventList))
		       void))
  (define SetAutomationEventBaseFrame
    (foreign-procedure #f "SetAutomationEventBaseFrame"
		       (integer-32)
		       void))
  (define StartAutomationEventRecording
    (foreign-procedure #f "StartAutomationEventRecording"
		       ()
		       void))
  (define StopAutomationEventRecording
    (foreign-procedure #f "StopAutomationEventRecording"
		       ()
		       void))
  (define PlayAutomationEvent
    (foreign-procedure #f "PlayAutomationEvent"
		       ((& AutomationEvent))
		       void))
  (define IsKeyPressed
    (foreign-procedure #f "IsKeyPressed" (integer-32) boolean))
  (define IsKeyPressedRepeat
    (foreign-procedure #f "IsKeyPressedRepeat"
		       (integer-32)
		       boolean))
  (define IsKeyDown
    (foreign-procedure #f "IsKeyDown" (integer-32) boolean))
  (define IsKeyReleased
    (foreign-procedure #f "IsKeyReleased" (integer-32) boolean))
  (define IsKeyUp
    (foreign-procedure #f "IsKeyUp" (integer-32) boolean))
  (define GetKeyPressed
    (foreign-procedure #f "GetKeyPressed" () integer-32))
  (define GetCharPressed
    (foreign-procedure #f "GetCharPressed" () integer-32))
  (define GetKeyName
    (foreign-procedure #f "GetKeyName" (integer-32) string))
  (define SetExitKey
    (foreign-procedure #f "SetExitKey" (integer-32) void))
  (define IsGamepadAvailable
    (foreign-procedure #f "IsGamepadAvailable"
		       (integer-32)
		       boolean))
  (define GetGamepadName
    (foreign-procedure #f "GetGamepadName" (integer-32) string))
  (define IsGamepadButtonPressed
    (foreign-procedure #f "IsGamepadButtonPressed"
		       (integer-32 integer-32)
		       boolean))
  (define IsGamepadButtonDown
    (foreign-procedure #f "IsGamepadButtonDown"
		       (integer-32 integer-32)
		       boolean))
  (define IsGamepadButtonReleased
    (foreign-procedure #f "IsGamepadButtonReleased"
		       (integer-32 integer-32)
		       boolean))
  (define IsGamepadButtonUp
    (foreign-procedure #f "IsGamepadButtonUp"
		       (integer-32 integer-32)
		       boolean))
  (define GetGamepadButtonPressed
    (foreign-procedure #f "GetGamepadButtonPressed"
		       ()
		       integer-32))
  (define GetGamepadAxisCount
    (foreign-procedure #f "GetGamepadAxisCount"
		       (integer-32)
		       integer-32))
  (define GetGamepadAxisMovement
    (foreign-procedure #f "GetGamepadAxisMovement"
		       (integer-32 integer-32)
		       single-float))
  (define SetGamepadMappings
    (foreign-procedure #f "SetGamepadMappings"
		       (string)
		       integer-32))
  (define SetGamepadVibration
    (foreign-procedure #f "SetGamepadVibration"
		       (integer-32 single-float single-float single-float)
		       void))
  (define IsMouseButtonPressed
    (foreign-procedure #f "IsMouseButtonPressed"
		       (integer-32)
		       boolean))
  (define IsMouseButtonDown
    (foreign-procedure #f "IsMouseButtonDown"
		       (integer-32)
		       boolean))
  (define IsMouseButtonReleased
    (foreign-procedure #f "IsMouseButtonReleased"
		       (integer-32)
		       boolean))
  (define IsMouseButtonUp
    (foreign-procedure #f "IsMouseButtonUp"
		       (integer-32)
		       boolean))
  (define GetMouseX
    (foreign-procedure #f "GetMouseX" () integer-32))
  (define GetMouseY
    (foreign-procedure #f "GetMouseY" () integer-32))
  (define GetMousePosition
    (let ([proc (foreign-procedure #f "GetMousePosition"
				   ()
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetMouseDelta
    (let ([proc (foreign-procedure #f "GetMouseDelta"
				   ()
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define SetMousePosition
    (foreign-procedure #f "SetMousePosition"
		       (integer-32 integer-32)
		       void))
  (define SetMouseOffset
    (foreign-procedure #f "SetMouseOffset"
		       (integer-32 integer-32)
		       void))
  (define SetMouseScale
    (foreign-procedure #f "SetMouseScale"
		       (single-float single-float)
		       void))
  (define GetMouseWheelMove
    (foreign-procedure #f "GetMouseWheelMove" () single-float))
  (define GetMouseWheelMoveV
    (let ([proc (foreign-procedure #f "GetMouseWheelMoveV"
				   ()
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define SetMouseCursor
    (foreign-procedure #f "SetMouseCursor" (integer-32) void))
  (define GetTouchX
    (foreign-procedure #f "GetTouchX" () integer-32))
  (define GetTouchY
    (foreign-procedure #f "GetTouchY" () integer-32))
  (define GetTouchPosition
    (let ([proc (foreign-procedure #f "GetTouchPosition"
				   (integer-32)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetTouchPointId
    (foreign-procedure #f "GetTouchPointId"
		       (integer-32)
		       integer-32))
  (define GetTouchPointCount
    (foreign-procedure #f "GetTouchPointCount" () integer-32))
  (define SetGesturesEnabled
    (foreign-procedure #f "SetGesturesEnabled"
		       (unsigned-32)
		       void))
  (define IsGestureDetected
    (foreign-procedure #f "IsGestureDetected"
		       (unsigned-32)
		       boolean))
  (define GetGestureDetected
    (foreign-procedure #f "GetGestureDetected" () integer-32))
  (define GetGestureHoldDuration
    (foreign-procedure #f "GetGestureHoldDuration"
		       ()
		       single-float))
  (define GetGestureDragVector
    (let ([proc (foreign-procedure #f "GetGestureDragVector"
				   ()
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetGestureDragAngle
    (foreign-procedure #f "GetGestureDragAngle"
		       ()
		       single-float))
  (define GetGesturePinchVector
    (let ([proc (foreign-procedure #f "GetGesturePinchVector"
				   ()
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetGesturePinchAngle
    (foreign-procedure #f "GetGesturePinchAngle"
		       ()
		       single-float))
  (define UpdateCamera
    (foreign-procedure #f "UpdateCamera"
		       ((* Camera) integer-32)
		       void))
  (define UpdateCameraPro
    (foreign-procedure #f "UpdateCameraPro"
		       ((* Camera) (& Vector3) (& Vector3) single-float)
		       void))
  (define SetShapesTexture
    (foreign-procedure #f "SetShapesTexture"
		       ((& Texture2D) (& Rectangle))
		       void))
  (define GetShapesTexture
    (let ([proc (foreign-procedure #f "GetShapesTexture"
				   ()
				   (& Texture2D))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Texture2D
                        (foreign-alloc (ftype-sizeof Texture2D)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetShapesTextureRectangle
    (let ([proc (foreign-procedure #f "GetShapesTextureRectangle"
				   ()
				   (& Rectangle))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Rectangle
                        (foreign-alloc (ftype-sizeof Rectangle)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define DrawPixel
    (foreign-procedure #f "DrawPixel"
		       (integer-32 integer-32 (& Color))
		       void))
  (define DrawPixelV
    (foreign-procedure #f "DrawPixelV"
		       ((& Vector2) (& Color))
		       void))
  (define DrawLine
    (foreign-procedure #f "DrawLine"
		       (integer-32 integer-32 integer-32 integer-32 (& Color))
		       void))
  (define DrawLineV
    (foreign-procedure #f "DrawLineV"
		       ((& Vector2) (& Vector2) (& Color))
		       void))
  (define DrawLineEx
    (foreign-procedure #f "DrawLineEx"
		       ((& Vector2) (& Vector2) single-float (& Color))
		       void))
  (define DrawLineStrip
    (foreign-procedure #f "DrawLineStrip"
		       ((* Vector2) integer-32 (& Color))
		       void))
  (define DrawLineBezier
    (foreign-procedure #f "DrawLineBezier"
		       ((& Vector2) (& Vector2) single-float (& Color))
		       void))
  (define DrawLineDashed
    (foreign-procedure #f "DrawLineDashed"
		       ((& Vector2) (& Vector2) integer-32 integer-32 (& Color))
		       void))
  (define DrawCircle
    (foreign-procedure #f "DrawCircle"
		       (integer-32 integer-32 single-float (& Color))
		       void))
  (define DrawCircleV
    (foreign-procedure #f "DrawCircleV"
		       ((& Vector2) single-float (& Color))
		       void))
  (define DrawCircleGradient
    (foreign-procedure #f "DrawCircleGradient"
		       ((& Vector2) single-float (& Color) (& Color))
		       void))
  (define DrawCircleSector
    (foreign-procedure #f "DrawCircleSector"
		       ((& Vector2)
			single-float
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawCircleSectorLines
    (foreign-procedure #f "DrawCircleSectorLines"
		       ((& Vector2)
			single-float
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawCircleLines
    (foreign-procedure #f "DrawCircleLines"
		       (integer-32 integer-32 single-float (& Color))
		       void))
  (define DrawCircleLinesV
    (foreign-procedure #f "DrawCircleLinesV"
		       ((& Vector2) single-float (& Color))
		       void))
  (define DrawEllipse
    (foreign-procedure #f "DrawEllipse"
		       (integer-32 integer-32 single-float single-float (& Color))
		       void))
  (define DrawEllipseV
    (foreign-procedure #f "DrawEllipseV"
		       ((& Vector2) single-float single-float (& Color))
		       void))
  (define DrawEllipseLines
    (foreign-procedure #f "DrawEllipseLines"
		       (integer-32 integer-32 single-float single-float (& Color))
		       void))
  (define DrawEllipseLinesV
    (foreign-procedure #f "DrawEllipseLinesV"
		       ((& Vector2) single-float single-float (& Color))
		       void))
  (define DrawRing
    (foreign-procedure #f "DrawRing"
		       ((& Vector2)
			single-float
			single-float
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawRingLines
    (foreign-procedure #f "DrawRingLines"
		       ((& Vector2)
			single-float
			single-float
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawRectangle
    (foreign-procedure #f "DrawRectangle"
		       (integer-32 integer-32 integer-32 integer-32 (& Color))
		       void))
  (define DrawRectangleV
    (foreign-procedure #f "DrawRectangleV"
		       ((& Vector2) (& Vector2) (& Color))
		       void))
  (define DrawRectangleRec
    (foreign-procedure #f "DrawRectangleRec"
		       ((& Rectangle) (& Color))
		       void))
  (define DrawRectanglePro
    (foreign-procedure #f "DrawRectanglePro"
		       ((& Rectangle) (& Vector2) single-float (& Color))
		       void))
  (define DrawRectangleGradientV
    (foreign-procedure #f "DrawRectangleGradientV"
		       (integer-32
			integer-32
			integer-32
			integer-32
			(& Color)
			(& Color))
		       void))
  (define DrawRectangleGradientH
    (foreign-procedure #f "DrawRectangleGradientH"
		       (integer-32
			integer-32
			integer-32
			integer-32
			(& Color)
			(& Color))
		       void))
  (define DrawRectangleGradientEx
    (foreign-procedure #f "DrawRectangleGradientEx"
		       ((& Rectangle) (& Color) (& Color) (& Color) (& Color))
		       void))
  (define DrawRectangleLines
    (foreign-procedure #f "DrawRectangleLines"
		       (integer-32 integer-32 integer-32 integer-32 (& Color))
		       void))
  (define DrawRectangleLinesEx
    (foreign-procedure #f "DrawRectangleLinesEx"
		       ((& Rectangle) single-float (& Color))
		       void))
  (define DrawRectangleRounded
    (foreign-procedure #f "DrawRectangleRounded"
		       ((& Rectangle) single-float integer-32 (& Color))
		       void))
  (define DrawRectangleRoundedLines
    (foreign-procedure #f "DrawRectangleRoundedLines"
		       ((& Rectangle) single-float integer-32 (& Color))
		       void))
  (define DrawRectangleRoundedLinesEx
    (foreign-procedure #f "DrawRectangleRoundedLinesEx"
		       ((& Rectangle)
			single-float
			integer-32
			single-float
			(& Color))
		       void))
  (define DrawTriangle
    (foreign-procedure #f "DrawTriangle"
		       ((& Vector2) (& Vector2) (& Vector2) (& Color))
		       void))
  (define DrawTriangleLines
    (foreign-procedure #f "DrawTriangleLines"
		       ((& Vector2) (& Vector2) (& Vector2) (& Color))
		       void))
  (define DrawTriangleFan
    (foreign-procedure #f "DrawTriangleFan"
		       ((* Vector2) integer-32 (& Color))
		       void))
  (define DrawTriangleStrip
    (foreign-procedure #f "DrawTriangleStrip"
		       ((* Vector2) integer-32 (& Color))
		       void))
  (define DrawPoly
    (foreign-procedure #f "DrawPoly"
		       ((& Vector2) integer-32 single-float single-float (& Color))
		       void))
  (define DrawPolyLines
    (foreign-procedure #f "DrawPolyLines"
		       ((& Vector2) integer-32 single-float single-float (& Color))
		       void))
  (define DrawPolyLinesEx
    (foreign-procedure #f "DrawPolyLinesEx"
		       ((& Vector2)
			integer-32
			single-float
			single-float
			single-float
			(& Color))
		       void))
  (define DrawSplineLinear
    (foreign-procedure #f "DrawSplineLinear"
		       ((* Vector2) integer-32 single-float (& Color))
		       void))
  (define DrawSplineBasis
    (foreign-procedure #f "DrawSplineBasis"
		       ((* Vector2) integer-32 single-float (& Color))
		       void))
  (define DrawSplineCatmullRom
    (foreign-procedure #f "DrawSplineCatmullRom"
		       ((* Vector2) integer-32 single-float (& Color))
		       void))
  (define DrawSplineBezierQuadratic
    (foreign-procedure #f "DrawSplineBezierQuadratic"
		       ((* Vector2) integer-32 single-float (& Color))
		       void))
  (define DrawSplineBezierCubic
    (foreign-procedure #f "DrawSplineBezierCubic"
		       ((* Vector2) integer-32 single-float (& Color))
		       void))
  (define DrawSplineSegmentLinear
    (foreign-procedure #f "DrawSplineSegmentLinear"
		       ((& Vector2) (& Vector2) single-float (& Color))
		       void))
  (define DrawSplineSegmentBasis
    (foreign-procedure #f "DrawSplineSegmentBasis"
		       ((& Vector2)
			(& Vector2)
			(& Vector2)
			(& Vector2)
			single-float
			(& Color))
		       void))
  (define DrawSplineSegmentCatmullRom
    (foreign-procedure #f "DrawSplineSegmentCatmullRom"
		       ((& Vector2)
			(& Vector2)
			(& Vector2)
			(& Vector2)
			single-float
			(& Color))
		       void))
  (define DrawSplineSegmentBezierQuadratic
    (foreign-procedure #f "DrawSplineSegmentBezierQuadratic"
		       ((& Vector2) (& Vector2) (& Vector2) single-float (& Color))
		       void))
  (define DrawSplineSegmentBezierCubic
    (foreign-procedure #f "DrawSplineSegmentBezierCubic"
		       ((& Vector2)
			(& Vector2)
			(& Vector2)
			(& Vector2)
			single-float
			(& Color))
		       void))
  (define GetSplinePointLinear
    (let ([proc (foreign-procedure #f "GetSplinePointLinear"
				   ((& Vector2) (& Vector2) single-float)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetSplinePointBasis
    (let ([proc (foreign-procedure #f "GetSplinePointBasis"
				   ((& Vector2)
				    (& Vector2)
				    (& Vector2)
				    (& Vector2)
				    single-float)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetSplinePointCatmullRom
    (let ([proc (foreign-procedure #f "GetSplinePointCatmullRom"
				   ((& Vector2)
				    (& Vector2)
				    (& Vector2)
				    (& Vector2)
				    single-float)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetSplinePointBezierCubic
    (let ([proc (foreign-procedure #f "GetSplinePointBezierCubic"
				   ((& Vector2)
				    (& Vector2)
				    (& Vector2)
				    (& Vector2)
				    single-float)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define CheckCollisionRecs
    (foreign-procedure #f "CheckCollisionRecs"
		       ((& Rectangle) (& Rectangle))
		       boolean))
  (define CheckCollisionCircles
    (foreign-procedure #f "CheckCollisionCircles"
		       ((& Vector2) single-float (& Vector2) single-float)
		       boolean))
  (define CheckCollisionCircleRec
    (foreign-procedure #f "CheckCollisionCircleRec"
		       ((& Vector2) single-float (& Rectangle))
		       boolean))
  (define CheckCollisionCircleLine
    (foreign-procedure #f "CheckCollisionCircleLine"
		       ((& Vector2) single-float (& Vector2) (& Vector2))
		       boolean))
  (define CheckCollisionPointRec
    (foreign-procedure #f "CheckCollisionPointRec"
		       ((& Vector2) (& Rectangle))
		       boolean))
  (define CheckCollisionPointCircle
    (foreign-procedure #f "CheckCollisionPointCircle"
		       ((& Vector2) (& Vector2) single-float)
		       boolean))
  (define CheckCollisionPointTriangle
    (foreign-procedure #f "CheckCollisionPointTriangle"
		       ((& Vector2) (& Vector2) (& Vector2) (& Vector2))
		       boolean))
  (define CheckCollisionPointLine
    (foreign-procedure #f "CheckCollisionPointLine"
		       ((& Vector2) (& Vector2) (& Vector2) integer-32)
		       boolean))
  (define CheckCollisionPointPoly
    (foreign-procedure #f "CheckCollisionPointPoly"
		       ((& Vector2) (* Vector2) integer-32)
		       boolean))
  (define CheckCollisionLines
    (foreign-procedure #f "CheckCollisionLines"
		       ((& Vector2)
			(& Vector2)
			(& Vector2)
			(& Vector2)
			(* Vector2))
		       boolean))
  (define GetCollisionRec
    (let ([proc (foreign-procedure #f "GetCollisionRec"
				   ((& Rectangle) (& Rectangle))
				   (& Rectangle))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Rectangle
                        (foreign-alloc (ftype-sizeof Rectangle)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadImage
    (let ([proc (foreign-procedure #f "LoadImage"
				   (string)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadImageRaw
    (let ([proc (foreign-procedure #f "LoadImageRaw"
				   (string integer-32 integer-32 integer-32 integer-32)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadImageAnim
    (let ([proc (foreign-procedure #f "LoadImageAnim"
				   (string (* integer-32))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadImageAnimFromMemory
    (let ([proc (foreign-procedure #f "LoadImageAnimFromMemory"
				   (string (* unsigned-8) integer-32 (* integer-32))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadImageFromMemory
    (let ([proc (foreign-procedure #f "LoadImageFromMemory"
				   (string (* unsigned-8) integer-32)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadImageFromTexture
    (let ([proc (foreign-procedure #f "LoadImageFromTexture"
				   ((& Texture2D))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadImageFromScreen
    (let ([proc (foreign-procedure #f "LoadImageFromScreen"
				   ()
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsImageValid
    (foreign-procedure #f "IsImageValid" ((& Image)) boolean))
  (define UnloadImage
    (foreign-procedure #f "UnloadImage" ((& Image)) void))
  (define ExportImage
    (foreign-procedure #f "ExportImage"
		       ((& Image) string)
		       boolean))
  (define ExportImageToMemory
    (foreign-procedure #f "ExportImageToMemory"
		       ((& Image) string (* integer-32))
		       (* unsigned-8)))
  (define ExportImageAsCode
    (foreign-procedure #f "ExportImageAsCode"
		       ((& Image) string)
		       boolean))
  (define GenImageColor
    (let ([proc (foreign-procedure #f "GenImageColor"
				   (integer-32 integer-32 (& Color))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImageGradientLinear
    (let ([proc (foreign-procedure #f "GenImageGradientLinear"
				   (integer-32 integer-32 integer-32 (& Color) (& Color))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImageGradientRadial
    (let ([proc (foreign-procedure #f "GenImageGradientRadial"
				   (integer-32 integer-32 single-float (& Color) (& Color))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImageGradientSquare
    (let ([proc (foreign-procedure #f "GenImageGradientSquare"
				   (integer-32 integer-32 single-float (& Color) (& Color))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImageChecked
    (let ([proc (foreign-procedure #f "GenImageChecked"
				   (integer-32
				    integer-32
				    integer-32
				    integer-32
				    (& Color)
				    (& Color))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImageWhiteNoise
    (let ([proc (foreign-procedure #f "GenImageWhiteNoise"
				   (integer-32 integer-32 single-float)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImagePerlinNoise
    (let ([proc (foreign-procedure #f "GenImagePerlinNoise"
				   (integer-32
				    integer-32
				    integer-32
				    integer-32
				    single-float)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImageCellular
    (let ([proc (foreign-procedure #f "GenImageCellular"
				   (integer-32 integer-32 integer-32)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenImageText
    (let ([proc (foreign-procedure #f "GenImageText"
				   (integer-32 integer-32 string)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ImageCopy
    (let ([proc (foreign-procedure #f "ImageCopy"
				   ((& Image))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ImageFromImage
    (let ([proc (foreign-procedure #f "ImageFromImage"
				   ((& Image) (& Rectangle))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ImageFromChannel
    (let ([proc (foreign-procedure #f "ImageFromChannel"
				   ((& Image) integer-32)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ImageText
    (let ([proc (foreign-procedure #f "ImageText"
				   (string integer-32 (& Color))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ImageTextEx
    (let ([proc (foreign-procedure #f "ImageTextEx"
				   ((& Font) string single-float single-float (& Color))
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ImageFormat
    (foreign-procedure #f "ImageFormat"
		       ((* Image) integer-32)
		       void))
  (define ImageToPOT
    (foreign-procedure #f "ImageToPOT"
		       ((* Image) (& Color))
		       void))
  (define ImageCrop
    (foreign-procedure #f "ImageCrop"
		       ((* Image) (& Rectangle))
		       void))
  (define ImageAlphaCrop
    (foreign-procedure #f "ImageAlphaCrop"
		       ((* Image) single-float)
		       void))
  (define ImageAlphaClear
    (foreign-procedure #f "ImageAlphaClear"
		       ((* Image) (& Color) single-float)
		       void))
  (define ImageAlphaMask
    (foreign-procedure #f "ImageAlphaMask"
		       ((* Image) (& Image))
		       void))
  (define ImageAlphaPremultiply
    (foreign-procedure #f "ImageAlphaPremultiply"
		       ((* Image))
		       void))
  (define ImageBlurGaussian
    (foreign-procedure #f "ImageBlurGaussian"
		       ((* Image) integer-32)
		       void))
  (define ImageKernelConvolution
    (foreign-procedure #f "ImageKernelConvolution"
		       ((* Image) (* single-float) integer-32)
		       void))
  (define ImageResize
    (foreign-procedure #f "ImageResize"
		       ((* Image) integer-32 integer-32)
		       void))
  (define ImageResizeNN
    (foreign-procedure #f "ImageResizeNN"
		       ((* Image) integer-32 integer-32)
		       void))
  (define ImageResizeCanvas
    (foreign-procedure #f "ImageResizeCanvas"
		       ((* Image)
			integer-32
			integer-32
			integer-32
			integer-32
			(& Color))
		       void))
  (define ImageMipmaps
    (foreign-procedure #f "ImageMipmaps" ((* Image)) void))
  (define ImageDither
    (foreign-procedure #f "ImageDither"
		       ((* Image) integer-32 integer-32 integer-32 integer-32)
		       void))
  (define ImageFlipVertical
    (foreign-procedure #f "ImageFlipVertical" ((* Image)) void))
  (define ImageFlipHorizontal
    (foreign-procedure #f "ImageFlipHorizontal"
		       ((* Image))
		       void))
  (define ImageRotate
    (foreign-procedure #f "ImageRotate"
		       ((* Image) integer-32)
		       void))
  (define ImageRotateCW
    (foreign-procedure #f "ImageRotateCW" ((* Image)) void))
  (define ImageRotateCCW
    (foreign-procedure #f "ImageRotateCCW" ((* Image)) void))
  (define ImageColorTint
    (foreign-procedure #f "ImageColorTint"
		       ((* Image) (& Color))
		       void))
  (define ImageColorInvert
    (foreign-procedure #f "ImageColorInvert" ((* Image)) void))
  (define ImageColorGrayscale
    (foreign-procedure #f "ImageColorGrayscale"
		       ((* Image))
		       void))
  (define ImageColorContrast
    (foreign-procedure #f "ImageColorContrast"
		       ((* Image) integer-32)
		       void))
  (define ImageColorBrightness
    (foreign-procedure #f "ImageColorBrightness"
		       ((* Image) integer-32)
		       void))
  (define ImageColorReplace
    (foreign-procedure #f "ImageColorReplace"
		       ((* Image) (& Color) (& Color))
		       void))
  (define LoadImageColors
    (foreign-procedure #f "LoadImageColors"
		       ((& Image))
		       (* Color)))
  (define LoadImagePalette
    (foreign-procedure #f "LoadImagePalette"
		       ((& Image) integer-32 (* integer-32))
		       (* Color)))
  (define UnloadImageColors
    (foreign-procedure #f "UnloadImageColors" ((* Color)) void))
  (define UnloadImagePalette
    (foreign-procedure #f "UnloadImagePalette"
		       ((* Color))
		       void))
  (define GetImageAlphaBorder
    (let ([proc (foreign-procedure #f "GetImageAlphaBorder"
				   ((& Image) single-float)
				   (& Rectangle))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Rectangle
                        (foreign-alloc (ftype-sizeof Rectangle)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetImageColor
    (let ([proc (foreign-procedure #f "GetImageColor"
				   ((& Image) integer-32 integer-32)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ImageClearBackground
    (foreign-procedure #f "ImageClearBackground"
		       ((* Image) (& Color))
		       void))
  (define ImageDrawPixel
    (foreign-procedure #f "ImageDrawPixel"
		       ((* Image) integer-32 integer-32 (& Color))
		       void))
  (define ImageDrawPixelV
    (foreign-procedure #f "ImageDrawPixelV"
		       ((* Image) (& Vector2) (& Color))
		       void))
  (define ImageDrawLine
    (foreign-procedure #f "ImageDrawLine"
		       ((* Image)
			integer-32
			integer-32
			integer-32
			integer-32
			(& Color))
		       void))
  (define ImageDrawLineV
    (foreign-procedure #f "ImageDrawLineV"
		       ((* Image) (& Vector2) (& Vector2) (& Color))
		       void))
  (define ImageDrawLineEx
    (foreign-procedure #f "ImageDrawLineEx"
		       ((* Image) (& Vector2) (& Vector2) integer-32 (& Color))
		       void))
  (define ImageDrawCircle
    (foreign-procedure #f "ImageDrawCircle"
		       ((* Image) integer-32 integer-32 integer-32 (& Color))
		       void))
  (define ImageDrawCircleV
    (foreign-procedure #f "ImageDrawCircleV"
		       ((* Image) (& Vector2) integer-32 (& Color))
		       void))
  (define ImageDrawCircleLines
    (foreign-procedure #f "ImageDrawCircleLines"
		       ((* Image) integer-32 integer-32 integer-32 (& Color))
		       void))
  (define ImageDrawCircleLinesV
    (foreign-procedure #f "ImageDrawCircleLinesV"
		       ((* Image) (& Vector2) integer-32 (& Color))
		       void))
  (define ImageDrawRectangle
    (foreign-procedure #f "ImageDrawRectangle"
		       ((* Image)
			integer-32
			integer-32
			integer-32
			integer-32
			(& Color))
		       void))
  (define ImageDrawRectangleV
    (foreign-procedure #f "ImageDrawRectangleV"
		       ((* Image) (& Vector2) (& Vector2) (& Color))
		       void))
  (define ImageDrawRectangleRec
    (foreign-procedure #f "ImageDrawRectangleRec"
		       ((* Image) (& Rectangle) (& Color))
		       void))
  (define ImageDrawRectangleLines
    (foreign-procedure #f "ImageDrawRectangleLines"
		       ((* Image)
			integer-32
			integer-32
			integer-32
			integer-32
			(& Color))
		       void))
  (define ImageDrawTriangle
    (foreign-procedure #f "ImageDrawTriangle"
		       ((* Image) (& Vector2) (& Vector2) (& Vector2) (& Color))
		       void))
  (define ImageDrawTriangleLines
    (foreign-procedure #f "ImageDrawTriangleLines"
		       ((* Image) (& Vector2) (& Vector2) (& Vector2) (& Color))
		       void))
  (define ImageDrawTriangleFan
    (foreign-procedure #f "ImageDrawTriangleFan"
		       ((* Image) (* Vector2) integer-32 (& Color))
		       void))
  (define ImageDrawTriangleStrip
    (foreign-procedure #f "ImageDrawTriangleStrip"
		       ((* Image) (* Vector2) integer-32 (& Color))
		       void))
  (define ImageDraw
    (foreign-procedure #f "ImageDraw"
		       ((* Image) (& Image) (& Rectangle) (& Rectangle) (& Color))
		       void))
  (define ImageDrawText
    (foreign-procedure #f "ImageDrawText"
		       ((* Image)
			string
			integer-32
			integer-32
			integer-32
			(& Color))
		       void))
  (define ImageDrawTextEx
    (foreign-procedure #f "ImageDrawTextEx"
		       ((* Image)
			(& Font)
			string
			(& Vector2)
			single-float
			single-float
			(& Color))
		       void))
  (define LoadTexture
    (let ([proc (foreign-procedure #f "LoadTexture"
				   (string)
				   (& Texture2D))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Texture2D
                        (foreign-alloc (ftype-sizeof Texture2D)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadTextureFromImage
    (let ([proc (foreign-procedure #f "LoadTextureFromImage"
				   ((& Image))
				   (& Texture2D))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Texture2D
                        (foreign-alloc (ftype-sizeof Texture2D)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadTextureCubemap
    (let ([proc (foreign-procedure #f "LoadTextureCubemap"
				   ((& Image) integer-32)
				   (& TextureCubemap))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        TextureCubemap
                        (foreign-alloc (ftype-sizeof TextureCubemap)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadRenderTexture
    (let ([proc (foreign-procedure #f "LoadRenderTexture"
				   (integer-32 integer-32)
				   (& RenderTexture2D))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        RenderTexture2D
                        (foreign-alloc (ftype-sizeof RenderTexture2D)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsTextureValid
    (foreign-procedure #f "IsTextureValid"
		       ((& Texture2D))
		       boolean))
  (define UnloadTexture
    (foreign-procedure #f "UnloadTexture" ((& Texture2D)) void))
  (define IsRenderTextureValid
    (foreign-procedure #f "IsRenderTextureValid"
		       ((& RenderTexture2D))
		       boolean))
  (define UnloadRenderTexture
    (foreign-procedure #f "UnloadRenderTexture"
		       ((& RenderTexture2D))
		       void))
  (define UpdateTexture
    (foreign-procedure #f "UpdateTexture"
		       ((& Texture2D) void*)
		       void))
  (define UpdateTextureRec
    (foreign-procedure #f "UpdateTextureRec"
		       ((& Texture2D) (& Rectangle) void*)
		       void))
  (define GenTextureMipmaps
    (foreign-procedure #f "GenTextureMipmaps"
		       ((* Texture2D))
		       void))
  (define SetTextureFilter
    (foreign-procedure #f "SetTextureFilter"
		       ((& Texture2D) integer-32)
		       void))
  (define SetTextureWrap
    (foreign-procedure #f "SetTextureWrap"
		       ((& Texture2D) integer-32)
		       void))
  (define DrawTexture
    (foreign-procedure #f "DrawTexture"
		       ((& Texture2D) integer-32 integer-32 (& Color))
		       void))
  (define DrawTextureV
    (foreign-procedure #f "DrawTextureV"
		       ((& Texture2D) (& Vector2) (& Color))
		       void))
  (define DrawTextureEx
    (foreign-procedure #f "DrawTextureEx"
		       ((& Texture2D)
			(& Vector2)
			single-float
			single-float
			(& Color))
		       void))
  (define DrawTextureRec
    (foreign-procedure #f "DrawTextureRec"
		       ((& Texture2D) (& Rectangle) (& Vector2) (& Color))
		       void))
  (define DrawTexturePro
    (foreign-procedure #f "DrawTexturePro"
		       ((& Texture2D)
			(& Rectangle)
			(& Rectangle)
			(& Vector2)
			single-float
			(& Color))
		       void))
  (define DrawTextureNPatch
    (foreign-procedure #f "DrawTextureNPatch"
		       ((& Texture2D)
			(& NPatchInfo)
			(& Rectangle)
			(& Vector2)
			single-float
			(& Color))
		       void))
  (define ColorIsEqual
    (foreign-procedure #f "ColorIsEqual"
		       ((& Color) (& Color))
		       boolean))
  (define Fade
    (let ([proc (foreign-procedure #f "Fade"
				   ((& Color) single-float)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorToInt
    (foreign-procedure #f "ColorToInt" ((& Color)) integer-32))
  (define ColorNormalize
    (let ([proc (foreign-procedure #f "ColorNormalize"
				   ((& Color))
				   (& Vector4))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector4
                        (foreign-alloc (ftype-sizeof Vector4)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorFromNormalized
    (let ([proc (foreign-procedure #f "ColorFromNormalized"
				   ((& Vector4))
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorToHSV
    (let ([proc (foreign-procedure #f "ColorToHSV"
				   ((& Color))
				   (& Vector3))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector3
                        (foreign-alloc (ftype-sizeof Vector3)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorFromHSV
    (let ([proc (foreign-procedure #f "ColorFromHSV"
				   (single-float single-float single-float)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorTint
    (let ([proc (foreign-procedure #f "ColorTint"
				   ((& Color) (& Color))
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorBrightness
    (let ([proc (foreign-procedure #f "ColorBrightness"
				   ((& Color) single-float)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorContrast
    (let ([proc (foreign-procedure #f "ColorContrast"
				   ((& Color) single-float)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorAlpha
    (let ([proc (foreign-procedure #f "ColorAlpha"
				   ((& Color) single-float)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorAlphaBlend
    (let ([proc (foreign-procedure #f "ColorAlphaBlend"
				   ((& Color) (& Color) (& Color))
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define ColorLerp
    (let ([proc (foreign-procedure #f "ColorLerp"
				   ((& Color) (& Color) single-float)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetColor
    (let ([proc (foreign-procedure #f "GetColor"
				   (unsigned-32)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetPixelColor
    (let ([proc (foreign-procedure #f "GetPixelColor"
				   (void* integer-32)
				   (& Color))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Color
                        (foreign-alloc (ftype-sizeof Color)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define SetPixelColor
    (foreign-procedure #f "SetPixelColor"
		       (void* (& Color) integer-32)
		       void))
  (define GetPixelDataSize
    (foreign-procedure #f "GetPixelDataSize"
		       (integer-32 integer-32 integer-32)
		       integer-32))
  (define GetFontDefault
    (let ([proc (foreign-procedure #f "GetFontDefault"
				   ()
				   (& Font))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Font
                        (foreign-alloc (ftype-sizeof Font)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadFont
    (let ([proc (foreign-procedure #f "LoadFont"
				   (string)
				   (& Font))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Font
                        (foreign-alloc (ftype-sizeof Font)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadFontEx
    (let ([proc (foreign-procedure #f "LoadFontEx"
				   (string integer-32 (* integer-32) integer-32)
				   (& Font))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Font
                        (foreign-alloc (ftype-sizeof Font)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadFontFromImage
    (let ([proc (foreign-procedure #f "LoadFontFromImage"
				   ((& Image) (& Color) integer-32)
				   (& Font))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Font
                        (foreign-alloc (ftype-sizeof Font)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadFontFromMemory
    (let ([proc (foreign-procedure #f "LoadFontFromMemory"
				   (string
				    (* unsigned-8)
				    integer-32
				    integer-32
				    (* integer-32)
				    integer-32)
				   (& Font))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Font
                        (foreign-alloc (ftype-sizeof Font)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsFontValid
    (foreign-procedure #f "IsFontValid" ((& Font)) boolean))
  (define LoadFontData
    (foreign-procedure #f "LoadFontData"
		       (u8*
			integer-32
			integer-32
			u32*
			integer-32
			integer-32
			(* integer-32))
		       (* GlyphInfo)))
  (define GenImageFontAtlas
    (let ([proc (foreign-procedure #f "GenImageFontAtlas"
				   ((* GlyphInfo)
				    (* *Rectangle)
				    integer-32
				    integer-32
				    integer-32
				    integer-32)
				   (& Image))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Image
                        (foreign-alloc (ftype-sizeof Image)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define UnloadFontData
    (foreign-procedure #f "UnloadFontData"
		       ((* GlyphInfo) integer-32)
		       void))
  (define UnloadFont
    (foreign-procedure #f "UnloadFont" ((& Font)) void))
  (define ExportFontAsCode
    (foreign-procedure #f "ExportFontAsCode"
		       ((& Font) string)
		       boolean))
  (define DrawFPS
    (foreign-procedure #f "DrawFPS"
		       (integer-32 integer-32)
		       void))
  (define DrawText
    (foreign-procedure #f "DrawText"
		       (string integer-32 integer-32 integer-32 (& Color))
		       void))
  (define DrawTextEx
    (foreign-procedure #f "DrawTextEx"
		       ((& Font)
			string
			(& Vector2)
			single-float
			single-float
			(& Color))
		       void))
  (define DrawTextPro
    (foreign-procedure #f "DrawTextPro"
		       ((& Font)
			string
			(& Vector2)
			(& Vector2)
			single-float
			single-float
			single-float
			(& Color))
		       void))
  (define DrawTextCodepoint
    (foreign-procedure #f "DrawTextCodepoint"
		       ((& Font) integer-32 (& Vector2) single-float (& Color))
		       void))
  (define DrawTextCodepoints
    (foreign-procedure #f "DrawTextCodepoints"
		       ((& Font)
			(* integer-32)
			integer-32
			(& Vector2)
			single-float
			single-float
			(& Color))
		       void))
  (define SetTextLineSpacing
    (foreign-procedure #f "SetTextLineSpacing"
		       (integer-32)
		       void))
  (define MeasureText
    (foreign-procedure #f "MeasureText"
		       (string integer-32)
		       integer-32))
  (define MeasureTextEx
    (let ([proc (foreign-procedure #f "MeasureTextEx"
				   ((& Font) string single-float single-float)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define MeasureTextCodepoints
    (let ([proc (foreign-procedure #f "MeasureTextCodepoints"
				   ((& Font)
				    (* integer-32)
				    integer-32
				    single-float
				    single-float)
				   (& Vector2))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Vector2
                        (foreign-alloc (ftype-sizeof Vector2)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetGlyphIndex
    (foreign-procedure #f "GetGlyphIndex"
		       ((& Font) integer-32)
		       integer-32))
  (define GetGlyphInfo
    (let ([proc (foreign-procedure #f "GetGlyphInfo"
				   ((& Font) integer-32)
				   (& GlyphInfo))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        GlyphInfo
                        (foreign-alloc (ftype-sizeof GlyphInfo)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetGlyphAtlasRec
    (let ([proc (foreign-procedure #f "GetGlyphAtlasRec"
				   ((& Font) integer-32)
				   (& Rectangle))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Rectangle
                        (foreign-alloc (ftype-sizeof Rectangle)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadUTF8
    (foreign-procedure #f "LoadUTF8"
		       ((* integer-32) integer-32)
		       string))
  (define UnloadUTF8
    (foreign-procedure #f "UnloadUTF8" (string) void))
  (define LoadCodepoints
    (foreign-procedure #f "LoadCodepoints"
		       (string (* integer-32))
		       (* integer-32)))
  (define UnloadCodepoints
    (foreign-procedure #f "UnloadCodepoints"
		       ((* integer-32))
		       void))
  (define GetCodepointCount
    (foreign-procedure #f "GetCodepointCount"
		       (string)
		       integer-32))
  (define GetCodepoint
    (foreign-procedure #f "GetCodepoint"
		       (string (* integer-32))
		       integer-32))
  (define GetCodepointNext
    (foreign-procedure #f "GetCodepointNext"
		       (string (* integer-32))
		       integer-32))
  (define GetCodepointPrevious
    (foreign-procedure #f "GetCodepointPrevious"
		       (string (* integer-32))
		       integer-32))
  (define CodepointToUTF8
    (foreign-procedure #f "CodepointToUTF8"
		       (integer-32 (* integer-32))
		       string))
  (define LoadTextLines
    (foreign-procedure #f "LoadTextLines"
		       (string (* integer-32))
		       string))
  (define UnloadTextLines
    (foreign-procedure #f "UnloadTextLines"
		       (string integer-32)
		       void))
  (define TextCopy
    (foreign-procedure #f "TextCopy"
		       (string string)
		       integer-32))
  (define TextIsEqual
    (foreign-procedure #f "TextIsEqual"
		       (string string)
		       boolean))
  (define TextLength
    (foreign-procedure #f "TextLength" (string) unsigned-32))
  (define TextFormat
    (foreign-procedure #f "TextFormat" (string) string))
  (define TextSubtext
    (foreign-procedure #f "TextSubtext"
		       (string integer-32 integer-32)
		       string))
  (define TextRemoveSpaces
    (foreign-procedure #f "TextRemoveSpaces" (string) string))
  (define GetTextBetween
    (foreign-procedure #f "GetTextBetween"
		       (string string string)
		       string))
  (define TextReplace
    (foreign-procedure #f "TextReplace"
		       (string string string)
		       string))
  (define TextReplaceAlloc
    (foreign-procedure #f "TextReplaceAlloc"
		       (string string string)
		       string))
  (define TextReplaceBetween
    (foreign-procedure #f "TextReplaceBetween"
		       (string string string string)
		       string))
  (define TextReplaceBetweenAlloc
    (foreign-procedure #f "TextReplaceBetweenAlloc"
		       (string string string string)
		       string))
  (define TextInsert
    (foreign-procedure #f "TextInsert"
		       (string string integer-32)
		       string))
  (define TextInsertAlloc
    (foreign-procedure #f "TextInsertAlloc"
		       (string string integer-32)
		       string))
  (define TextJoin
    (foreign-procedure #f "TextJoin"
		       (string integer-32 string)
		       string))
  (define TextSplit
    (foreign-procedure #f "TextSplit"
		       (string char (* integer-32))
		       string))
  (define TextAppend
    (foreign-procedure #f "TextAppend"
		       (string string (* integer-32))
		       void))
  (define TextFindIndex
    (foreign-procedure #f "TextFindIndex"
		       (string string)
		       integer-32))
  (define TextToUpper
    (foreign-procedure #f "TextToUpper" (string) string))
  (define TextToLower
    (foreign-procedure #f "TextToLower" (string) string))
  (define TextToPascal
    (foreign-procedure #f "TextToPascal" (string) string))
  (define TextToSnake
    (foreign-procedure #f "TextToSnake" (string) string))
  (define TextToCamel
    (foreign-procedure #f "TextToCamel" (string) string))
  (define TextToInteger
    (foreign-procedure #f "TextToInteger" (string) integer-32))
  (define TextToFloat
    (foreign-procedure #f "TextToFloat" (string) single-float))
  (define DrawLine3D
    (foreign-procedure #f "DrawLine3D"
		       ((& Vector3) (& Vector3) (& Color))
		       void))
  (define DrawPoint3D
    (foreign-procedure #f "DrawPoint3D"
		       ((& Vector3) (& Color))
		       void))
  (define DrawCircle3D
    (foreign-procedure #f "DrawCircle3D"
		       ((& Vector3)
			single-float
			(& Vector3)
			single-float
			(& Color))
		       void))
  (define DrawTriangle3D
    (foreign-procedure #f "DrawTriangle3D"
		       ((& Vector3) (& Vector3) (& Vector3) (& Color))
		       void))
  (define DrawTriangleStrip3D
    (foreign-procedure #f "DrawTriangleStrip3D"
		       ((* Vector3) integer-32 (& Color))
		       void))
  (define DrawCube
    (foreign-procedure #f "DrawCube"
		       ((& Vector3)
			single-float
			single-float
			single-float
			(& Color))
		       void))
  (define DrawCubeV
    (foreign-procedure #f "DrawCubeV"
		       ((& Vector3) (& Vector3) (& Color))
		       void))
  (define DrawCubeWires
    (foreign-procedure #f "DrawCubeWires"
		       ((& Vector3)
			single-float
			single-float
			single-float
			(& Color))
		       void))
  (define DrawCubeWiresV
    (foreign-procedure #f "DrawCubeWiresV"
		       ((& Vector3) (& Vector3) (& Color))
		       void))
  (define DrawSphere
    (foreign-procedure #f "DrawSphere"
		       ((& Vector3) single-float (& Color))
		       void))
  (define DrawSphereEx
    (foreign-procedure #f "DrawSphereEx"
		       ((& Vector3) single-float integer-32 integer-32 (& Color))
		       void))
  (define DrawSphereWires
    (foreign-procedure #f "DrawSphereWires"
		       ((& Vector3) single-float integer-32 integer-32 (& Color))
		       void))
  (define DrawCylinder
    (foreign-procedure #f "DrawCylinder"
		       ((& Vector3)
			single-float
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawCylinderEx
    (foreign-procedure #f "DrawCylinderEx"
		       ((& Vector3)
			(& Vector3)
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawCylinderWires
    (foreign-procedure #f "DrawCylinderWires"
		       ((& Vector3)
			single-float
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawCylinderWiresEx
    (foreign-procedure #f "DrawCylinderWiresEx"
		       ((& Vector3)
			(& Vector3)
			single-float
			single-float
			integer-32
			(& Color))
		       void))
  (define DrawCapsule
    (foreign-procedure #f "DrawCapsule"
		       ((& Vector3)
			(& Vector3)
			single-float
			integer-32
			integer-32
			(& Color))
		       void))
  (define DrawCapsuleWires
    (foreign-procedure #f "DrawCapsuleWires"
		       ((& Vector3)
			(& Vector3)
			single-float
			integer-32
			integer-32
			(& Color))
		       void))
  (define DrawPlane
    (foreign-procedure #f "DrawPlane"
		       ((& Vector3) (& Vector2) (& Color))
		       void))
  (define DrawRay
    (foreign-procedure #f "DrawRay" ((& Ray) (& Color)) void))
  (define DrawGrid
    (foreign-procedure #f "DrawGrid"
		       (integer-32 single-float)
		       void))
  (define LoadModel
    (let ([proc (foreign-procedure #f "LoadModel"
				   (string)
				   (& Model))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Model
                        (foreign-alloc (ftype-sizeof Model)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadModelFromMesh
    (let ([proc (foreign-procedure #f "LoadModelFromMesh"
				   ((& Mesh))
				   (& Model))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Model
                        (foreign-alloc (ftype-sizeof Model)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsModelValid
    (foreign-procedure #f "IsModelValid" ((& Model)) boolean))
  (define UnloadModel
    (foreign-procedure #f "UnloadModel" ((& Model)) void))
  (define GetModelBoundingBox
    (let ([proc (foreign-procedure #f "GetModelBoundingBox"
				   ((& Model))
				   (& BoundingBox))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        BoundingBox
                        (foreign-alloc (ftype-sizeof BoundingBox)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define DrawModel
    (foreign-procedure #f "DrawModel"
		       ((& Model) (& Vector3) single-float (& Color))
		       void))
  (define DrawModelEx
    (foreign-procedure #f "DrawModelEx"
		       ((& Model)
			(& Vector3)
			(& Vector3)
			single-float
			(& Vector3)
			(& Color))
		       void))
  (define DrawModelWires
    (foreign-procedure #f "DrawModelWires"
		       ((& Model) (& Vector3) single-float (& Color))
		       void))
  (define DrawModelWiresEx
    (foreign-procedure #f "DrawModelWiresEx"
		       ((& Model)
			(& Vector3)
			(& Vector3)
			single-float
			(& Vector3)
			(& Color))
		       void))
  (define DrawBoundingBox
    (foreign-procedure #f "DrawBoundingBox"
		       ((& BoundingBox) (& Color))
		       void))
  (define DrawBillboard
    (foreign-procedure #f "DrawBillboard"
		       ((& Camera)
			(& Texture2D)
			(& Vector3)
			single-float
			(& Color))
		       void))
  (define DrawBillboardRec
    (foreign-procedure #f "DrawBillboardRec"
		       ((& Camera)
			(& Texture2D)
			(& Rectangle)
			(& Vector3)
			(& Vector2)
			(& Color))
		       void))
  (define DrawBillboardPro
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
		       void))
  (define UploadMesh
    (foreign-procedure #f "UploadMesh" ((* Mesh) boolean) void))
  (define UpdateMeshBuffer
    (foreign-procedure #f "UpdateMeshBuffer"
		       ((& Mesh) integer-32 void* integer-32 integer-32)
		       void))
  (define UnloadMesh
    (foreign-procedure #f "UnloadMesh" ((& Mesh)) void))
  (define DrawMesh
    (foreign-procedure #f "DrawMesh"
		       ((& Mesh) (& Material) (& Matrix))
		       void))
  (define DrawMeshInstanced
    (foreign-procedure #f "DrawMeshInstanced"
		       ((& Mesh) (& Material) (* Matrix) integer-32)
		       void))
  (define GetMeshBoundingBox
    (let ([proc (foreign-procedure #f "GetMeshBoundingBox"
				   ((& Mesh))
				   (& BoundingBox))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        BoundingBox
                        (foreign-alloc (ftype-sizeof BoundingBox)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshTangents
    (foreign-procedure #f "GenMeshTangents" ((* Mesh)) void))
  (define ExportMesh
    (foreign-procedure #f "ExportMesh"
		       ((& Mesh) string)
		       boolean))
  (define ExportMeshAsCode
    (foreign-procedure #f "ExportMeshAsCode"
		       ((& Mesh) string)
		       boolean))
  (define GenMeshPoly
    (let ([proc (foreign-procedure #f "GenMeshPoly"
				   (integer-32 single-float)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshPlane
    (let ([proc (foreign-procedure #f "GenMeshPlane"
				   (single-float single-float integer-32 integer-32)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshCube
    (let ([proc (foreign-procedure #f "GenMeshCube"
				   (single-float single-float single-float)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshSphere
    (let ([proc (foreign-procedure #f "GenMeshSphere"
				   (single-float integer-32 integer-32)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshHemiSphere
    (let ([proc (foreign-procedure #f "GenMeshHemiSphere"
				   (single-float integer-32 integer-32)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshCylinder
    (let ([proc (foreign-procedure #f "GenMeshCylinder"
				   (single-float single-float integer-32)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshCone
    (let ([proc (foreign-procedure #f "GenMeshCone"
				   (single-float single-float integer-32)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshTorus
    (let ([proc (foreign-procedure #f "GenMeshTorus"
				   (single-float single-float integer-32 integer-32)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshKnot
    (let ([proc (foreign-procedure #f "GenMeshKnot"
				   (single-float single-float integer-32 integer-32)
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshHeightmap
    (let ([proc (foreign-procedure #f "GenMeshHeightmap"
				   ((& Image) (& Vector3))
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GenMeshCubicmap
    (let ([proc (foreign-procedure #f "GenMeshCubicmap"
				   ((& Image) (& Vector3))
				   (& Mesh))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Mesh
                        (foreign-alloc (ftype-sizeof Mesh)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadMaterials
    (foreign-procedure #f "LoadMaterials"
		       (string (* integer-32))
		       (* Material)))
  (define LoadMaterialDefault
    (let ([proc (foreign-procedure #f "LoadMaterialDefault"
				   ()
				   (& Material))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Material
                        (foreign-alloc (ftype-sizeof Material)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsMaterialValid
    (foreign-procedure #f "IsMaterialValid"
		       ((& Material))
		       boolean))
  (define UnloadMaterial
    (foreign-procedure #f "UnloadMaterial" ((& Material)) void))
  (define SetMaterialTexture
    (foreign-procedure #f "SetMaterialTexture"
		       ((* Material) integer-32 (& Texture2D))
		       void))
  (define SetModelMeshMaterial
    (foreign-procedure #f "SetModelMeshMaterial"
		       ((* Model) integer-32 integer-32)
		       void))
  (define LoadModelAnimations
    (foreign-procedure #f "LoadModelAnimations"
		       (string (* integer-32))
		       (* ModelAnimation)))
  (define UpdateModelAnimation
    (foreign-procedure #f "UpdateModelAnimation"
		       ((& Model) (& ModelAnimation) single-float)
		       void))
  (define UpdateModelAnimationEx
    (foreign-procedure #f "UpdateModelAnimationEx"
		       ((& Model)
			(& ModelAnimation)
			single-float
			(& ModelAnimation)
			single-float
			single-float)
		       void))
  (define UnloadModelAnimations
    (foreign-procedure #f "UnloadModelAnimations"
		       ((* ModelAnimation) integer-32)
		       void))
  (define IsModelAnimationValid
    (foreign-procedure #f "IsModelAnimationValid"
		       ((& Model) (& ModelAnimation))
		       boolean))
  (define CheckCollisionSpheres
    (foreign-procedure #f "CheckCollisionSpheres"
		       ((& Vector3) single-float (& Vector3) single-float)
		       boolean))
  (define CheckCollisionBoxes
    (foreign-procedure #f "CheckCollisionBoxes"
		       ((& BoundingBox) (& BoundingBox))
		       boolean))
  (define CheckCollisionBoxSphere
    (foreign-procedure #f "CheckCollisionBoxSphere"
		       ((& BoundingBox) (& Vector3) single-float)
		       boolean))
  (define GetRayCollisionSphere
    (let ([proc (foreign-procedure #f "GetRayCollisionSphere"
				   ((& Ray) (& Vector3) single-float)
				   (& RayCollision))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        RayCollision
                        (foreign-alloc (ftype-sizeof RayCollision)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetRayCollisionBox
    (let ([proc (foreign-procedure #f "GetRayCollisionBox"
				   ((& Ray) (& BoundingBox))
				   (& RayCollision))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        RayCollision
                        (foreign-alloc (ftype-sizeof RayCollision)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetRayCollisionMesh
    (let ([proc (foreign-procedure #f "GetRayCollisionMesh"
				   ((& Ray) (& Mesh) (& Matrix))
				   (& RayCollision))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        RayCollision
                        (foreign-alloc (ftype-sizeof RayCollision)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetRayCollisionTriangle
    (let ([proc (foreign-procedure #f "GetRayCollisionTriangle"
				   ((& Ray) (& Vector3) (& Vector3) (& Vector3))
				   (& RayCollision))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        RayCollision
                        (foreign-alloc (ftype-sizeof RayCollision)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define GetRayCollisionQuad
    (let ([proc (foreign-procedure #f "GetRayCollisionQuad"
				   ((& Ray) (& Vector3) (& Vector3) (& Vector3) (& Vector3))
				   (& RayCollision))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        RayCollision
                        (foreign-alloc (ftype-sizeof RayCollision)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define InitAudioDevice
    (foreign-procedure #f "InitAudioDevice" () void))
  (define CloseAudioDevice
    (foreign-procedure #f "CloseAudioDevice" () void))
  (define IsAudioDeviceReady
    (foreign-procedure #f "IsAudioDeviceReady" () boolean))
  (define SetMasterVolume
    (foreign-procedure #f "SetMasterVolume"
		       (single-float)
		       void))
  (define GetMasterVolume
    (foreign-procedure #f "GetMasterVolume" () single-float))
  (define LoadWave
    (let ([proc (foreign-procedure #f "LoadWave"
				   (string)
				   (& Wave))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Wave
                        (foreign-alloc (ftype-sizeof Wave)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadWaveFromMemory
    (let ([proc (foreign-procedure #f "LoadWaveFromMemory"
				   (string (* unsigned-8) integer-32)
				   (& Wave))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Wave
                        (foreign-alloc (ftype-sizeof Wave)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsWaveValid
    (foreign-procedure #f "IsWaveValid" ((& Wave)) boolean))
  (define LoadSound
    (let ([proc (foreign-procedure #f "LoadSound"
				   (string)
				   (& Sound))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Sound
                        (foreign-alloc (ftype-sizeof Sound)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadSoundFromWave
    (let ([proc (foreign-procedure #f "LoadSoundFromWave"
				   ((& Wave))
				   (& Sound))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Sound
                        (foreign-alloc (ftype-sizeof Sound)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadSoundAlias
    (let ([proc (foreign-procedure #f "LoadSoundAlias"
				   ((& Sound))
				   (& Sound))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Sound
                        (foreign-alloc (ftype-sizeof Sound)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsSoundValid
    (foreign-procedure #f "IsSoundValid" ((& Sound)) boolean))
  (define UpdateSound
    (foreign-procedure #f "UpdateSound"
		       ((& Sound) void* integer-32)
		       void))
  (define UnloadWave
    (foreign-procedure #f "UnloadWave" ((& Wave)) void))
  (define UnloadSound
    (foreign-procedure #f "UnloadSound" ((& Sound)) void))
  (define UnloadSoundAlias
    (foreign-procedure #f "UnloadSoundAlias" ((& Sound)) void))
  (define ExportWave
    (foreign-procedure #f "ExportWave"
		       ((& Wave) string)
		       boolean))
  (define ExportWaveAsCode
    (foreign-procedure #f "ExportWaveAsCode"
		       ((& Wave) string)
		       boolean))
  (define PlaySound
    (foreign-procedure #f "PlaySound" ((& Sound)) void))
  (define StopSound
    (foreign-procedure #f "StopSound" ((& Sound)) void))
  (define PauseSound
    (foreign-procedure #f "PauseSound" ((& Sound)) void))
  (define ResumeSound
    (foreign-procedure #f "ResumeSound" ((& Sound)) void))
  (define IsSoundPlaying
    (foreign-procedure #f "IsSoundPlaying" ((& Sound)) boolean))
  (define SetSoundVolume
    (foreign-procedure #f "SetSoundVolume"
		       ((& Sound) single-float)
		       void))
  (define SetSoundPitch
    (foreign-procedure #f "SetSoundPitch"
		       ((& Sound) single-float)
		       void))
  (define SetSoundPan
    (foreign-procedure #f "SetSoundPan"
		       ((& Sound) single-float)
		       void))
  (define WaveCopy
    (let ([proc (foreign-procedure #f "WaveCopy"
				   ((& Wave))
				   (& Wave))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Wave
                        (foreign-alloc (ftype-sizeof Wave)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define WaveCrop
    (foreign-procedure #f "WaveCrop"
		       ((* Wave) integer-32 integer-32)
		       void))
  (define WaveFormat
    (foreign-procedure #f "WaveFormat"
		       ((* Wave) integer-32 integer-32 integer-32)
		       void))
  (define LoadWaveSamples
    (foreign-procedure #f "LoadWaveSamples"
		       ((& Wave))
		       (* single-float)))
  (define UnloadWaveSamples
    (foreign-procedure #f "UnloadWaveSamples"
		       ((* single-float))
		       void))
  (define LoadMusicStream
    (let ([proc (foreign-procedure #f "LoadMusicStream"
				   (string)
				   (& Music))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Music
                        (foreign-alloc (ftype-sizeof Music)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define LoadMusicStreamFromMemory
    (let ([proc (foreign-procedure #f "LoadMusicStreamFromMemory"
				   (string (* unsigned-8) integer-32)
				   (& Music))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        Music
                        (foreign-alloc (ftype-sizeof Music)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsMusicValid
    (foreign-procedure #f "IsMusicValid" ((& Music)) boolean))
  (define UnloadMusicStream
    (foreign-procedure #f "UnloadMusicStream" ((& Music)) void))
  (define PlayMusicStream
    (foreign-procedure #f "PlayMusicStream" ((& Music)) void))
  (define IsMusicStreamPlaying
    (foreign-procedure #f "IsMusicStreamPlaying"
		       ((& Music))
		       boolean))
  (define UpdateMusicStream
    (foreign-procedure #f "UpdateMusicStream" ((& Music)) void))
  (define StopMusicStream
    (foreign-procedure #f "StopMusicStream" ((& Music)) void))
  (define PauseMusicStream
    (foreign-procedure #f "PauseMusicStream" ((& Music)) void))
  (define ResumeMusicStream
    (foreign-procedure #f "ResumeMusicStream" ((& Music)) void))
  (define SeekMusicStream
    (foreign-procedure #f "SeekMusicStream"
		       ((& Music) single-float)
		       void))
  (define SetMusicVolume
    (foreign-procedure #f "SetMusicVolume"
		       ((& Music) single-float)
		       void))
  (define SetMusicPitch
    (foreign-procedure #f "SetMusicPitch"
		       ((& Music) single-float)
		       void))
  (define SetMusicPan
    (foreign-procedure #f "SetMusicPan"
		       ((& Music) single-float)
		       void))
  (define GetMusicTimeLength
    (foreign-procedure #f "GetMusicTimeLength"
		       ((& Music))
		       single-float))
  (define GetMusicTimePlayed
    (foreign-procedure #f "GetMusicTimePlayed"
		       ((& Music))
		       single-float))
  (define LoadAudioStream
    (let ([proc (foreign-procedure #f "LoadAudioStream"
				   (unsigned-32 unsigned-32 unsigned-32)
				   (& AudioStream))])
      (lambda xargs
        (let ([ret-res (make-ftype-pointer
                        AudioStream
                        (foreign-alloc (ftype-sizeof AudioStream)))])
          (apply proc ret-res xargs)
          ret-res))))
  (define IsAudioStreamValid
    (foreign-procedure #f "IsAudioStreamValid"
		       ((& AudioStream))
		       boolean))
  (define UnloadAudioStream
    (foreign-procedure #f "UnloadAudioStream"
		       ((& AudioStream))
		       void))
  (define UpdateAudioStream
    (foreign-procedure #f "UpdateAudioStream"
		       ((& AudioStream) void* integer-32)
		       void))
  (define IsAudioStreamProcessed
    (foreign-procedure #f "IsAudioStreamProcessed"
		       ((& AudioStream))
		       boolean))
  (define PlayAudioStream
    (foreign-procedure #f "PlayAudioStream"
		       ((& AudioStream))
		       void))
  (define PauseAudioStream
    (foreign-procedure #f "PauseAudioStream"
		       ((& AudioStream))
		       void))
  (define ResumeAudioStream
    (foreign-procedure #f "ResumeAudioStream"
		       ((& AudioStream))
		       void))
  (define IsAudioStreamPlaying
    (foreign-procedure #f "IsAudioStreamPlaying"
		       ((& AudioStream))
		       boolean))
  (define StopAudioStream
    (foreign-procedure #f "StopAudioStream"
		       ((& AudioStream))
		       void))
  (define SetAudioStreamVolume
    (foreign-procedure #f "SetAudioStreamVolume"
		       ((& AudioStream) single-float)
		       void))
  (define SetAudioStreamPitch
    (foreign-procedure #f "SetAudioStreamPitch"
		       ((& AudioStream) single-float)
		       void))
  (define SetAudioStreamPan
    (foreign-procedure #f "SetAudioStreamPan"
		       ((& AudioStream) single-float)
		       void))
  (define SetAudioStreamBufferSizeDefault
    (foreign-procedure #f "SetAudioStreamBufferSizeDefault"
		       (integer-32)
		       void))
  (define SetAudioStreamCallback
    (foreign-procedure #f "SetAudioStreamCallback"
		       ((& AudioStream) (* AudioCallback))
		       void))
  (define AttachAudioStreamProcessor
    (foreign-procedure #f "AttachAudioStreamProcessor"
		       ((& AudioStream) (* AudioCallback))
		       void))
  (define DetachAudioStreamProcessor
    (foreign-procedure #f "DetachAudioStreamProcessor"
		       ((& AudioStream) (* AudioCallback))
		       void))
  (define AttachAudioMixedProcessor
    (foreign-procedure #f "AttachAudioMixedProcessor"
		       ((* AudioCallback))
		       void))
  (define DetachAudioMixedProcessor
    (foreign-procedure #f "DetachAudioMixedProcessor"
		       ((* AudioCallback))
		       void)))
