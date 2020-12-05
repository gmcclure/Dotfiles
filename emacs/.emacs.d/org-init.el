;(setq debug-on-error t)
;(setq debug-on-quit t)

(setq gc-cons-threshold 100000000)

(defvar better-gc-cons-threshold 67108864 ; 64mb
  "The default value to use for `gc-cons-threshold'.
  Freezing? Decrease this. Stuttering? Increase.")
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold better-gc-cons-threshold)))

(use-package diminish)

;; Necessary to set this for epdinfo rebuild
(setenv "PKG_CONFIG_PATH"
	"/usr/local/opt/libffi/lib/pkgconfig")
(setenv "WORKON_HOME"
	"/Users/gmcclure/Etc/Virtualenvs")

(setq user-full-name "Greg McClure")
(setq user-email-address "gmcclure@gmail.com")
(setq calendar-latitude 33.6510622)
(setq calendar-longitude -117.83008960000001)
(setq calendar-location-name "Irvine, CA")

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

;; Frame position
(add-to-list 'default-frame-alist '(width . 127))
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(set-frame-position (selected-frame) 1100 650)

(setq inhibit-splash-screen t)
(setq initial-scratch-message "")
(setq initial-major-mode 'org-mode)
(setq-default major-mode 'org-mode)


(blink-cursor-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(ns-appearance . dark))

;(load-theme 'doom-solarized-dark t)
(load-theme 'doom-gruvbox t)

(defun gmc:set-session-resolution ()
  (interactive)
  (if (<= (display-pixel-width) 1680)
	(set-frame-font "-*-APL385 Unicode-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
      (set-frame-font "-*-APL385 Unicode-normal-normal-*-22-*-*-*-m-0-iso10646-1")))

(when (eq system-type 'darwin)
  (gmc:set-session-resolution))

(set-face-attribute 'variable-pitch nil :family "Baskerville")

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

;;; Files & buffers
(ido-mode t)
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(set-default 'truncate-lines t)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 20
      kept-old-versions 5)

;; Makes C-k kill an entire line when cursor is at line beginning
(setq kill-whole-line t)

(defun gmc:reload-init-file ()
  "Reload init.el file"
  (interactive)
  (load user-init-file)
  (message "Reloaded init.el OK."))

(defun gmc:open-init-file ()
  (interactive)
  (find-file "~/.emacs.d/org-init.org"))

(use-package misc
  :commands forward-to-word
  :bind (("M-f" . forward-to-word)))

(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(global-set-key "\M-z" 'zap-up-to-char)
(global-set-key (kbd "C-(") 'scroll-up-line)
(global-set-key (kbd "C-)") 'scroll-down-line)
(global-set-key (kbd "C-c 0") 'eshell)
(global-set-key (kbd "C-c i") 'gmc:open-init-file)
(global-set-key (kbd "C-c o")
		(lambda () (interactive) (find-file "~/Dropbox/Org/life.org")))
(global-set-key (kbd "C-c n") 'indent-region)
(global-set-key (kbd "RET") 'newline-and-indent)

;; Always remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Indent org-mode code blocks automagically
(defun gmc:code-block-indent ()
  (interactive)
  (save-excursion
    (org-babel-mark-block)
    (indent-region (region-beginning) (region-end))))

;; Screenshots
(defun gmc:insert-screenshot (file-name)
  "Save screenshot to FILE-NAME and insert an Org link at point.

      This calls the `import' from ImageMagick to take the screenshot,
      and `optipng' to reduce the file size if the program is present."
  (interactive "FSave to file: ")
  ;; Get absolute path
  (let ((file (expand-file-name file-name)))
    ;; Create the directory if necessary
    (make-directory (file-name-directory file) 'parents)
    ;; Still, make sure to signal if the screenshot was in fact not created
    (unless (= 0 (call-process "import" nil nil nil file))
      (user-error "`import' failed to create screenshot %s" file))
    (if (executable-find "optipng")
	(start-process "optipng" nil "optipng" file))
    (insert
     ;; A link relative to the buffer where it is inserted is more portable
     (format "[[file:%s]]"
	     (file-relative-name file
				 (file-name-directory buffer-file-name))))
    (when (eq major-mode 'org-mode)
      (org-redisplay-inline-images))))

; Flash the modeline for the bell
(setq ring-bell-function
      (lambda ()
	(let ((orig-fg (face-foreground 'mode-line)))
	  (set-face-foreground 'mode-line "#F2804F")
	  (run-with-idle-timer 0.1 nil
			       (lambda (fg) (set-face-foreground 'mode-line fg))
			       orig-fg))))

; Close term buffer on exit
(defadvice term-handle-exit
    (after term-kill-buffer-on-exit activate)
  (kill-buffer))

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(use-package ace-window
  :ensure t
  :bind (("M-o" . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l)))

(let ((my-path (expand-file-name "/Library/TeX/texbin")))
  (setenv "PATH" (concat my-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-path))

;; AucTeX settings
(setq-default TeX-master nil)
(setq TeX-parse-self t)
(setq TeX-auto-save t)
(setq TeX-PDF-mode t)

; (add-hook 'LaTeX-mode-hook
; (lambda ()
;   (push
;    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
;      :help "Run latexmk on file")
;     TeX-command-list)))
;
; (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))

; (add-hook 'TeX-after-TeX-LaTeX-command-finished-hook
;            #'TeX-revert-document-buffer)

;; to use pdfview with auctex
; (add-hook 'LaTeX-mode-hook 'pdf-tools-install)

;; to use pdfview with auctex
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)
(setq TeX-view-program-list '(("PDF Tools" "TeX-pdf-tools-sync-view"))
      Tex-source-correlate-start-server t)
(add-hook 'TeX-after-compilation-finished-functions
	  #'TeX-revert-document-buffer)

;; Avy
;; Jump to things in Emacs, tree-style
;; https://github.com/abo-abo/avy
(use-package avy
  :ensure t
  :bind (("C-:" . avy-goto-char)
    ("M-g l" . avy-goto-line))
  :config
  (setq avy-background t))

(require 'calfw)
(require 'calfw-ical)
(defun gmc:open-gmc-calendar ()
  (interactive)
  (cfw:open-ical-calendar "https://calendar.google.com/calendar/ical/gmcclure%40gmail.com/public/basic.ics"))
(global-set-key (kbd "<f12>") 'gmc:open-gmc-calendar)

(use-package clean-aindent-mode
  :ensure t
  :config
  (electric-indent-mode -1)
  (clean-aindent-mode t)
  (setq clean-aindent-is-simple-indent t)
  (add-hook 'prog-mode-hook 'clean-aindent-mode))

(use-package company
  :diminish
  :config
  (global-company-mode 1)
  (company-tng-configure-default)
  (setq ;; Only 2 letters required for completion to activate.
   company-minimum-prefix-length 3

   ;; Search other buffers for compleition candidates
   company-dabbrev-other-buffers t
   company-dabbrev-code-other-buffers t

   ;; Allow (lengthy) numbers to be eligible for completion.
   company-complete-number t

   ;; M-⟪num⟫ to select an option according to its number.
   company-show-numbers t

   ;; Edge of the completion list cycles around.
   company-selection-wrap-around t

   ;; Do not downcase completions by default.
   company-dabbrev-downcase nil

   ;; Even if I write something with the ‘wrong’ case,
   ;; provide the ‘correct’ casing.
   company-dabbrev-ignore-case t

   ;; Immediately activate completion.
   company-idle-delay 0))

;; Deft
;; Quick, plain-text notes in Emacs
;; https://github.com/jrblevin/deft
(use-package deft
  :ensure t
  :config
  (setq deft-directory "~/Google Drive/Notes")
  (setq deft-recursive t)
  (setq deft-extension '("org" "txt"))
  (setq deft-text-mode 'org-mode)
  (setq deft-use-filename-as-title t)
  (setq deft-use-filter-string-for-filename t)
  (setq deft-auto-save-interval 0)
  :bind
  ("C-c d" . deft))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package elfeed
  :ensure t
  :bind
  ("C-x w" . 'elfeed))

(use-package elfeed-goodies
  :ensure t
  :config
  (elfeed-goodies/setup))

(setq elfeed-feeds
      '(("https://news.ycombinator.com/rss" tech)
	("https://lobste.rs/rss" tech)
	("http://feeds.feedburner.com/brainpickings/rss" general)
	("http://feeds.feedburner.com/OpenCulture" general)
	("http://feeds.feedburner.com/universetoday/pYdq" science)
	("http://feeds.101cookbooks.com/101cookbooks" cooking)
	("http://feeds.feedburner.com/CookieAndKate" cooking)
	("http://withfoodandlove.com/feed/" cooking)
	("http://feeds.seriouseats.com/seriouseatsfeaturesvideos" cooking)
	("http://www.greenkitchenstories.com/feed/" cooking)
	("http://feeds.feedburner.com/MinimalistBaker" cooking)
	("http://feeds.feedburner.com/NaturallyElla" cooking)
	("http://feeds.feedburner.com/CoolTools" fun)
	("http://feeds.feedburner.com/nofilmschool/" film)
	("http://love-python.blogspot.com/feeds/posts/default" dev)
	("http://feeds.feedburner.com/CssTricks" dev)
	("http://feeds.feedburner.com/Bludice" dev)
	("http://www.raywenderlich.com/category/swift/feed" dev)
	("https://www.hackingwithswift.com/articles/rss" dev)
	("http://feeds.feedburner.com/Catswhocode" dev)
	("http://www.techiedelight.com/feed/" dev)
	("http://feeds.feedburner.com/catonmat" dev)
	("http://programmingpraxis.com/feed/" dev)
	("http://feeds.feedburner.com/filmmakeriq" film)
	("http://osxdaily.com/feed/" tech)
	("http://feeds.feedburner.com/Noupe" dev)
	("http://feeds.feedburner.com/design-milk" art)
	("http://feeds.feedburner.com/weburbanist" art)
	("http://feeds.feedburner.com/colossal" art)
	("http://rss1.smashingmagazine.com/feed/" dev)
	("http://penpaperpencil.net/rss" pencils)
	("http://www.pencilrevolution.com/feed/" pencils)
	("http://feeds.feedburner.com/NotebookStories" pencils)
	("http://wellappointeddesk.com/feed/" pencils)
	("http://feeds.feedburner.com/penaddict/XQKI" pencils)
	("http://therecordingrevolution.com/feed/" music)
	("http://www.soundonsound.com/news/sosrssfeed.php" music)
	("http://www.gearjunkies.com/feed/" music)
	("http://www.factmag.com/feed/" music)
	("https://feedity.com/musicradar-com/VFtaWlJW.rss" music)
	("http://www.theguitarjournal.com/feed/" music)
	("http://www.premierguitar.com/rss/Magazine.aspx" music)
	("http://www.carryology.com/feed/" fun)
	("http://xkcd.com/rss.xml" fun)
	("http://www.laist.com/index.rdf" general)
	("http://feeds.feedburner.com/thesartorialist" fasion)
	("http://feedpress.me/wink" reading)
	("http://tetw.tumblr.com/rss" reading)
	("https://www.reddit.com/r/emacs.rss" emacs)
	("https://cdm.link/feed/" music)
	("https://www.creativefieldrecording.com/feed/" music)))

(add-hook 'eshell-banner-load-hook
	  '(lambda ()
	     (setq eshell-banner-message
		   (if (executable-find "fortune")
		       (concat (shell-command-to-string "fortune -s") "\n")
		     (concat "GMacs engaged." "\n\n")))))

(setq eshell-prompt-function
      (lambda ()
	(concat (format-time-string "%Y-%m-%d %H:%M" (current-time))
		(if (= (user-uid) 0) " # " " $ "))))

;; Get environment variables such as $PATH from the shell
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package eyebrowse
  :diminish eyebrowse-mode
  :init (setq eyebrowse-keymap-prefix (kbd "C-c C-g"))
  :config
  (eyebrowse-mode t))

(setq diary-file "~/Dropbox/App")

;; Dired
(setq dired-listing-switches "-alh")
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))

;; Dired-x
(require 'dired-x)
(setq-default dired-omit-files-p t) ; Buffer local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))

(when (require 'elpy nil t)
  (elpy-enable))

;; from https://github.com/jorgenschaefer/elpy/issues/1550
(setq elpy-shell-echo-output nil
      python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i")

(setq prettify-symbols-unprettify-at-point 'right-edge)
(global-prettify-symbols-mode 0)

(add-hook
 'python-mode-hook
 (lambda ()
   (mapc (lambda (pair) (push pair prettify-symbols-alist))
	 '(("def" . "𝒇")
	   ("class" . "𝑪")
	   ("and" . "∧")
	   ("or" . "∨")
	   ("not" . "￢")
	   ("in" . "∈")
	   ("not in" . "∉")
	   ("return" . "⟼")
	   ("yield" . "⟻")
	   ("for" . "∀")
	   ("!=" . "≠")
	   ("==" . "＝")
	   (">=" . "≥")
	   ("<=" . "≤")
	   ("[]" . "⃞")
	   ("=" . "≝")))))

(setq ispell-program-name "/usr/local/bin/aspell")

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(use-package helm
  :ensure t
  :config

  ;; Must set before helm-config
  (setq helm-command-prefix-key "C-c h")

  (require 'helm-config)
  (require 'helm-eshell)
  (require 'helm-files)
  (require 'helm-grep)

  ;; rebind tab to do persistent action
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  ;; make TAB works in terminal
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
  ;; list actions using C-z
  (define-key helm-map (kbd "C-z")  'helm-select-action)

  (define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
  (define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
  (define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

  (setq
   helm-google-suggest-use-curl-p t
   helm-scroll-amount 4
   helm-quick-update t
   helm-idle-delay 0.01
   helm-input-idle-delay 0.01
   helm-ff-search-library-in-sexp t
   helm-split-window-in-side-p t
   helm-split-window-default-side 'other
   helm-buffers-favorite-modes (append helm-buffers-favorite-modes
				       '(picture-mode artist-mode))
   helm-candidate-number-limit 100
   helm-M-x-requires-pattern 0
   helm-boring-file-regexp-list
     '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "\\.i$")
   helm-ff-file-name-history-use-recentf t
   helm-move-to-line-cycle-in-source t
   ido-use-virtual-buffers t
   helm-buffers-fuzzy-matching t)

  ;; Save current position to mark ring when jumping to a different place
  (add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

  (helm-mode 1)

  :bind
  ("M-x" . helm-M-x)
  ("C-;" . helm-M-x)
  ("C-x b" . helm-mini)
  ("C-x C-f" . helm-find-files))

(use-package hydra
  :ensure t)

(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(global-set-key "\M-/" 'hippie-expand)

(use-package ivy
  :ensure try
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package swiper
  :bind
  ("C-s" . 'swiper))
;; (use-package posframe)
;; (use-package ivy
;;   :diminish
;;   :init
;;   (use-package amx :defer t)
;;   (use-package counsel :diminish :config (counsel-mode 1))
;;   (use-package swiper :defer t)
;;   (ivy-mode 1)
;;   :bind
;;   (("C-s" . swiper-isearch)
;;    ("M-s r" . ivy-resume)
;;    ("C-x b" . 'ivy-switch-buffer)
;;    ("C-;" . 'counsel-M-x)
;;    (:map ivy-minibuffer-map
;; 	 ("C-r" . ivy-previous-line-or-history)
;; 	 ("M-RET" . ivy-immediate-done))
;;    (:map counsel-find-file-map
;; 	 ("C-~" . counsel-goto-local-home)))
;;   :custom
;;   (ivy-use-virtual-buffers t)
;;   (enable-recursive-minibuffers t)
;;   (ivy-height 10)
;;   (ivy-on-del-error-function nil)
;;   (ivy-magic-slash-non-match-action 'ivy-magic-slash-non-match-create)
;;   (ivy-count-format "【%d/%d】")
;;   (ivy-wrap t)
;;   :config
;;   (defun counsel-goto-local-home ()
;;     "Go to the $HOME of the local machine."
;;     (interactive)
;;     (ivy--cd "~/")))

;; (use-package ivy-posframe
;;   :custom
;;   (ivy-display-function #'ivy-posframe-display-at-frame-center)
;;   ;; (ivy-posframe-width 130)
;;   ;; (ivy-posframe-height 11)
;;   (ivy-posframe-parameters
;;    '((left-fringe . 5)
;;      (right-fringe . 5)))
;;   :custom-face
;;   (ivy-posframe ((t (:background "#282a36"))))
;;   (ivy-posframe-border ((t (:background "#6272a4"))))
;;   (ivy-posframe-cursor ((t (:background "#61bfff"))))
;;   :hook
;;   (ivy-mode . ivy-posframe-enable))

(global-set-key (kbd "C-x g") 'magit-status)

(setq org-special-ctrl-a/e 't)
(setq org-src-tab-acts-natively t)
(setq org-use-speed-commands t)
(setq org-catch-invisible-edits 'show-and-error)
(setq org-cycle-separator-lines 0)
(setq org-refile-targets (quote ((nil :maxlevel . 9)
				 (org-agenda-files :maxlevel . 9))))
(setq org-refile-use-outline-path t)
(setq org-refile-allow-creating-parent-nodes (quote confirm))

(setq org-directory "~/Dropbox/Org")
;(setq org-mobile-inbox-for-pull "~/Google Drive/mobile-inbox.org")
;(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-ellipsis "⤵")

;; Org Notes
(setq org-capture-templates
      '(("b" "Bookmark" entry (file+headline "~/Dropbox/Org/life.org" "Bookmarks")
	 "** %:link%?\n")
	("t" "Todo" entry (file+headline "~/Dropbox/Org/todos.org" "TODOs")
	 "* TODO %?\n")
	("j" "Post" entry (file+datetree "~/Dropbox/Org/journal.org")
	 "* %U %^{Title}\n %?")))

(setq org-agenda-files
      (list "~/Dropbox/Org/journal.org"
	    "~/Dropbox/Org/life.org"
	    "~/Dropbox/Org/notes.org"
	    "~/Dropbox/Org/todos.org"))
(setq org-default-notes-file "~/Dropbox/Org/notes.org")

(defun org-force-open-current-window ()
  (interactive)
  (let ((org-link-frame-setup (quote
			       ((vm . vm-visit-folder-other-frame)
				(vm-imap . vm-visit-imap-folder-other-frame)
				(gnus . org-gnus-no-new-news)
				(file . find-file)
				(wl . wl-other-frame)))
			      ))
    (org-open-at-point)))

;; Depending on universal argument try opening link
(defun org-open-maybe (&optional arg)
  (interactive "P")
  (if arg
      (org-open-at-point)
    (org-force-open-current-window)))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Redefine file opening without clobbering universal argumnet
;; org-open-maybe is defined in org functions section
(define-key org-mode-map "\C-c\C-o" 'org-open-maybe)
(define-key org-mode-map "\C-c\C-x\C-r" 'org-refile)

;; Org TODOs
(setq org-log-done 'note)
;; Save clock history across Emacs sessions
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(use-package org-journal
  :ensure t
  :defer t
  :custom
  (org-journal-dir "~/Google Drive/Journal")
  (org-journal-date-format "%A, %d %B %Y")
  :bind
  ("C-S-j" . org-journal-new-entry))

(use-package page-break-lines)

(use-package powerthesaurus
  :ensure t
  :bind
  ("M-p" . 'powerthesaurus-lookup-word-at-point))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package pdf-tools
  :ensure t
  :config
  (custom-set-variables
   '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
(pdf-tools-install)

(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))

(add-to-list 'load-path "~/Etc/Lib/scel/el")
(require 'sclang)

(setenv "PATH" (concat (getenv "PATH") ":/Applications/SuperCollider.app:/Applications/SuperCollider.app/Contents/MacOS"))
(setq exec-path (append exec-path '("/Applications/SuperCollider.app"  "/Applications/SuperCollider.app/Contents/MacOS" )))

(use-package undo-tree
  :ensure t
  :diminish t
  :config
  (global-undo-tree-mode 1)
  (defalias 'redo 'undo-tree-redo))

(use-package volatile-highlights
  :ensure t
  :config
  (volatile-highlights-mode t))

(use-package web-mode
  :ensure t
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)

  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-expanding t)
  (setq web-mode-enable-css-colorization t)
  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.tpl\\.php\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode 1))

(use-package yankpad
  :ensure t
  :defer 10
  :init
  (setq yankpad-file "~/Dropbox/Org/snips.org")
  :config
  (bind-key "C-c C-x m" 'yankpad-map)
  (bind-key "C-c C-x y" 'yankpad-expand)
  ;; If you want to complete snippets using company-mode
  (add-to-list 'company-backends #'company-yankpad)
  ;; If you want to expand snippets with hippie-expand
  (add-to-list 'hippie-expand-try-functions-list #'yankpad-expand))

(use-package yasnippet
  :ensure t)
(yas-global-mode 1)
(setq yas-snippet-dirs '("/.emacs.d/snippets"))
