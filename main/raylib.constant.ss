(define FLAG_FULLSCREEN_MODE #x00000002)
(define FLAG_WINDOW_RESIZABLE #x00000004)
(define FLAG_WINDOW_MINIMIZED #x00000200)
(define FLAG_WINDOW_MAXIMIZED #x00000400)
(define FLAG_MSAA_4X_HINT #x00000020)

(define BLACK (make-Color 0 0 0 255))
(define WHITE (make-Color 255 255 255 255))
(define RED (make-Color 255 0 0 255))

(define SHADER_UNIFORM_FLOAT 0)

(define LOG_ALL 0)
(define LOG_TRACE 1)
(define LOG_DEBUG 2)
(define LOG_INFO 3)
(define LOG_WARNING 4)
(define LOG_ERROR 5)
(define LOG_FATAL 6)
(define LOG_NONE 7)

(define TEXTURE_FILTER_POINT 0)
(define TEXTURE_FILTER_BILINEAR 1)
(define TEXTURE_FILTER_TRILINEAR 2    )
(define TEXTURE_FILTER_ANISOTROPIC_4X 3)
(define TEXTURE_FILTER_ANISOTROPIC_8X 4)
(define TEXTURE_FILTER_ANISOTROPIC_16X 5)

(define MOUSE_BUTTON_LEFT    0)  ; 鼠标左键
(define MOUSE_BUTTON_RIGHT   1)  ; 鼠标右键
(define MOUSE_BUTTON_MIDDLE  2)  ; 鼠标中键（按下滚轮）
(define MOUSE_BUTTON_SIDE    3)  ; 鼠标侧键（高级鼠标设备）
(define MOUSE_BUTTON_EXTRA   4)  ; 鼠标额外键（高级鼠标设备）
(define MOUSE_BUTTON_FORWARD 5)  ; 鼠标前进键（高级鼠标设备）
(define MOUSE_BUTTON_BACK    6)  ; 鼠标后退键（高级鼠标设备）

(define KEY_RIGHT 262)
(define KEY_LEFT 263)
(define KEY_DOWN 264)
(define KEY_UP 265)


