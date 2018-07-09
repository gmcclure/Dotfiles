;;; Package setup

;; Use
;; https://github.com/jwiegley/use-package
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq custom-file "~/.emacs.d/gmacs-custom.el")
(load custom-file)

(org-babel-load-file (expand-file-name "~/.emacs.d/org-init.org"))
(put 'downcase-region 'disabled nil)
