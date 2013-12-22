;;(add-auto-mode 'java-mode "\\.java" "\\.jsp")
;;;###autoload
(defun add-auto-mode (mode &rest patterns)
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

;;(add-hooks 'java-mode-hook '(lambda() (message "ffffff")))
;;(add-hooks '(java-mode-hook c++-mode-hook python-mode-hook) (lambda() (shell-command "notify-send ddd")))
;;;###autoload
(defun add-hooks (hooks function &optional append local)
  "Call `add-hook' on hook list HOOKS use arguments FUNCTION, APPEND, LOCAL.
HOOKS can be one list or just a hook.
将function绑到一个或多个hook上"
  (if (listp hooks)
      (mapc
       `(lambda (hook)
          (add-hook hook ',function append local))
       hooks)
    (if (symbolp hooks)
        (add-hook hooks function append local)
      (add-hook (quote hooks) function append local)
      )
    ))

;; (define-key-lazy python-mode-map [(meta return)] 'eval-print-last-sexp 'python)
;; (define-key-lazy ruby-mode-map [(meta return)] 'delete-char)
;; (define-key-lazy ruby-mode-map [(meta return)] 'eval-print-last-sexp 'ruby-mode)
;; (define-key-lazy java-mode-map "\C-o" 'delete-char "cc-mode")
;; (define-key-lazy java-mode-map "\C-o" 'forward-char 'cc-mode)
;; (define-key-lazy emacs-lisp-mode-map [(meta return)] 'eval-print-last-sexp 'lisp-mode)
;; (define-key-lazy global-map "\C-o" 'delete-backward-char)
;; (print (macroexpand ' (define-key-lazy emacs-lisp-mode-map [(meta return)] 'eval-print-last-sexp 'lisp-mode)))
;;;###autoload
(defmacro define-key-lazy (mode-map key cmd  &optional feature)
  "define-key in `eval-after-load' block. `feature' is the file name where defined `mode-map'"
  (let* ((k (kbd key)))
    (if (string-match "-mode-map$" (symbol-name mode-map))
        (let* ((mode-map-name (symbol-name mode-map)) ;perl-mode-map
               ;;(mode-map-hook (or mode-hook (intern   (concat (substring mode-map-name 0  (- (length mode-map-name) 4 )) "-hook")))) ;perl-mode-hook symbol
               (mode-map-name-without-map-suffix (substring mode-map-name 0  (- (length mode-map-name) 4 ))) ;perl-mode str
               (mode-map-name-without-mode-map-suffix (substring mode-map-name 0  (- (length mode-map-name) 9 ))) ;perl str
               )
          (if feature
              (cond ((stringp feature)
                     `(eval-after-load ,feature '(define-key ,mode-map ,k ,cmd)))
                    (t
                     `(eval-after-load (symbol-name  ,feature) '(define-key ,mode-map ,k ,cmd))))
            `(progn
               ;;(add-hook (quote ,mode-map-hook) (function (lambda () (define-key ,mode-map ,key ,cmd))))
               (eval-after-load  ,mode-map-name-without-mode-map-suffix  '(define-key ,mode-map ,k ,cmd))
               (eval-after-load   ,mode-map-name-without-map-suffix  '(define-key ,mode-map ,k ,cmd)))))
      `(define-key ,mode-map ,k ,cmd)
      )))

(defun hello-world ()
  (interactive)
  (with-easy-repeat
    (insert "Hello, World!\n")))
(global-set-key (kbd "C-c x y z") 'hello-world)

;;比如这个例子
;; `C-cxyz'插入"hello-world"
;; `C-cxyzz'插入两个"hello-world"
;; `C-cxyzzz'插入三个"hello-world"
;; http://stackoverflow.com/questions/7560094/two-key-shortcut-in-emacs-without-repressing-the-first-key
(defmacro with-easy-repeat (&rest body)
  "Execute BODY and repeat while the user presses the last key."
  (declare (indent 0))
  `(let* ((repeat-key (and (> (length (this-single-command-keys)) 1)
                           last-input-event))
          (repeat-key-str (format-kbd-macro (vector repeat-key) nil)))
     ,@body
     (while repeat-key
       (message "(Type %s to repeat)" repeat-key-str)
       (let ((event (read-event)))
         (clear-this-command-keys t)
         (if (equal event repeat-key)
             (progn ,@body
                    (setq last-input-event nil))
           (setq repeat-key nil)
           (push last-input-event unread-command-events))))))
(provide 'lazy-keys)
