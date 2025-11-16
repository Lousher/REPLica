(define extract-strings
  (lambda (scripts)
    (cond
     [(null? scripts) '()]
     [(string? scripts) (list scripts)]
     [(atom? scripts) '()]
     [(list? scripts)
      (append (extract-strings (car scripts))
	      (extract-strings (cdr scripts)))]
     [else '()])))
(define image-exporter
  (let ([count 0])
    (lambda (image)
      (ExportImage image (format "~a.png" count))
      (set! count (1+ count)))))
(define delv
  (lambda (key alist)
    (cond
     [(null? alist) '()]
     [(eqv? key (caar alist)) (delv key (cdr alist))]
     [else (cons (car alist) (delv key (cdr alist)))])))
(define :id? (lambda (id) (and (symbol? id) (char=? #\: (string-ref (symbol->string id) 0)))))
(define parse-params
  (lambda (params)
    (fold-left
     (lambda (acc next)
       (if (:id? next)
	   (append acc (list (list next)))
	   (let ([last (last-pair acc)])
	     (set-cdr! (car last) (append (cdar last) (list next)))
	     acc)))
     '()
     params)))
(define reads
  (lambda (port)
    (let ([content (read port)])
      (if (eof-object? content)
	  '()
	  (cons content (reads port))))))
(define format-green
  (lambda (fmt-str . rest)
    (apply format (format "\033[0;32m~a\033[0m" fmt-str) rest)))
(define load-texture-from-screen
  (lambda ()
    (let ([screen-img (LoadImageFromScreen)])
 ;     (image-exporter screen-img)
      (ImageResize screen-img (GetScreenWidth) (GetScreenHeight))
      (ImageFlipVertical screen-img)
      (let ([screen-tex (LoadTextureFromImage screen-img)])
	(UnloadImage screen-img)
	screen-tex))))
(define partition-by-index
  (lambda (li)
    (let ([len (length li)])
      (let collect ([even '()] [old '()] [index 0] [rest li])
	(cond
	 [(null? rest) (values (reverse even) (reverse old))]
	 [(even? index) (collect (cons (car rest)  even)
				 old (1+ index) (cdr rest))]
	 [(odd? index) (collect even (cons (car rest) old)
				(1+ index) (cdr rest))])))))
