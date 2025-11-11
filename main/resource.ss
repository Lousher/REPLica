(define *resources* (make-hashtable equal-hash equal?))
(define *resource-lifecycles* (make-hashtable symbol-hash symbol=?))

(define resource-lifecycle-loader
  (lambda (type)
    (let ([lifecycle (hashtable-ref *resource-lifecycles* type (lambda () (error 'resource-lifecycle-loader "No lifecycle defined" type)))])
      (car lifecycle))))
(define resource-lifecycle-unloader
  (lambda (type)
    (let ([lifecycle (hashtable-ref *resource-lifecycles* type (lambda () (error 'resource-lifecycle-loader "No lifecycle defined" type)))])
      (cadr lifecycle))))


(hashtable-set! *resource-lifecycles* 'background (list
						   (lambda (path)
						     (let ([img (LoadImage path)])
						       (ImageResize img (GetScreenWidth) (GetScreenHeight))
						       (let ([tex (LoadTextureFromImage img)])
							 (UnloadImage img)
							 tex)))
						   UnloadTexture))
(hashtable-set! *resource-lifecycles* 'character (list
						   LoadTexture
						   UnloadTexture))
(hashtable-set! *resource-lifecycles* 'sound (list LoadSound UnloadSound))
(hashtable-set! *resource-lifecycles* 'effect (list LoadShader UnloadShader))
