;;; Package setup

;; Use
;; https://github.com/jwiegley/use-package

;; When debugging is necessary ...
;(setq debug-on-error t)
;(setq debug-on-quit t)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
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
(put 'dired-find-alternate-file 'disabled nil)
