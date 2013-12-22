(add-auto-mode 'ruby-mode "||.rb" "Gemfile" "Guardfile" "||.thor" "Thorfile" "Rakefile" "||.rake")

(add-hooks '(ruby-mode emacs-lisp-mode clojure-mode) 'paredit-mode)
