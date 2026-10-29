(import (ffi rini binding))
(load-shared-object "ffi/rini/librini.so")

(define data (rini_load "test/ffi/settings.ini"))

;; 先确认加载成功——count 为 0 表示文件打不开或没有有效行
(define count (ftype-ref rini_data (count) data))
(printf "loaded ~a entries\n" count)

(if (= count 0)
    (printf "WARNING: settings.ini not found or empty\n")
    (begin
      ;; int 值
      (printf "master volume : ~a\n" (rini_get_value data "config_volume_master"))
      (printf "bgm volume    : ~a\n" (rini_get_value data "config_volume_bgm"))
      (printf "text speed    : ~a\n" (rini_get_value data "config_text_speed"))
      (printf "fullscreen    : ~a\n" (rini_get_value data "config_fullscreen"))

      ;; 带 fallback：key 不存在或无效时返回默认值
      (printf "auto advance  : ~a\n" (rini_get_value_fallback data "config_auto_advance" 1))

      ;; 字符串值（自动去掉引号）
      (printf "window title  : ~s\n" (rini_get_value_text data "config_title"))
      (printf "player name   : ~s\n" (rini_get_value_text data "player_name"))

      ;; 字符串 fallback
      (printf "language      : ~s\n" (rini_get_value_text_fallback data "config_language" "zh-CN"))

      ;; 值后面的注释可以通过 description 接口读取
      (printf "master desc   : ~s\n" (rini_get_value_description data "config_volume_master"))))
