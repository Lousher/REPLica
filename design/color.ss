(library (design color)
  (export
   lightgray gray darkgray yellow gold orange pink red maroon green lime darkgreen skyblue blue darkblue purple violet darkpurple beige brown drakbrwon white black blank magenta raywhite)
  (import
   (chezscheme)
   (only (core type) make-color))

  (define lightgray
    (make-color 200 200 200 255))
  (define gray
    (make-color 130 130 130 255))
  (define darkgray
    (make-color 80 80 80 255))
  (define yellow
    (make-color 253 249 0 255))
  (define gold
    (make-color 255 203 0 255))
  (define orange
    (make-color 255 161 0 255))
  (define pink
    (make-color 255 109 194 255))
  (define red
    (make-color 230 41 55 255))
  (define maroon
    (make-color 190 33 55 255))
  (define green
    (make-color 0 228 48 255))
  (define lime
    (make-color 0 158 47 255))
  (define darkgreen
    (make-color 0 117 44 255))
  (define skyblue
    (make-color 102 191 255 255))
  (define blue
    (make-color 0 121 241 255))
  (define darkblue
    (make-color 0 82 172 255))
  (define purple
    (make-color 200 122 255 255))
  (define violet
    (make-color 135 60 190 255))
  (define darkpurple
    (make-color 112 31 126 255))
  (define beige
    (make-color 211 176 131 255))
  (define brown
    (make-color 127 106 79 255))
  (define drakbrwon
    (make-color 76 63 47 255))
  (define white
    (make-color 255 255 255 255))
  (define black
    (make-color 0 0 0 255))
  (define blank
    (make-color 0 0 0 0))
  (define magenta
    (make-color 255 0 255 255))
  (define raywhite
    (make-color 245 245 245 255))

  )
