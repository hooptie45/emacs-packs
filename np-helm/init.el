;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-add-pack-lib "helm")
(require 'helm-config)
(live-load-config-file "bindings.el")
(live-load-config-file "hooks.el")
(live-load-config-file "settings.el")
(helm-mode 1)
