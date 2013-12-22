(eval-after-load 'windmove (lambda () (windmove-default-keybindings)))

(define-key-lazy global-map "H-s" 'fixup-whitespace 'simple)
(define-key-lazy global-map "M-z" 'dired-jump 'dired)
(define-key-lazy global-map "H-t" 'toggle-truncate-lines)
(define-key-lazy global-map "s-s" 'shell)
(define-key-lazy global-map "H-e" 'hippie-expand 'hippie-expand)
