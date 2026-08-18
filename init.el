;; Initialize package sources
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org") t)
(package-initialize)

;; Load Custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Minimal UI adjustments
(setq inhibit-startup-screen t)
(tool-bar-mode		-1)
(menu-bar-mode		-1)
(scroll-bar-mode	-1)
(tooltip-mode		-1)
(load-theme 'modus-vivendi-deuteranopia t)
(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font-16"))
(set-frame-parameter nil 'alpha-background 85)
(set-face-background 'fringe (face-background 'default))

;; QoL
(fido-vertical-mode 1)
(which-key-mode 1)
(repeat-mode 1)
(electric-pair-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(delete-selection-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(column-number-mode 1)

;; Variable Customization
(add-hook 'prog-mode-hook #'subword-mode)
;; (add-hook 'prog-mode-hook #'display-line-numbers-mode)

(setq duplicate-line-final-position 1
      completion-ignore-case t
      use-short-answers t
	  imenu-flatten 'annotation
      shell-file-name "/usr/bin/bash"
	  imenu-auto-rescan t
	  use-package-enable-imenu-support t)
(setq-default c-basic-offset 4
			  c-ts-mode-indent-offset 4
			  tab-width 4)

;; Global Keybindings
(keymap-set global-map "C-c c"			#'compile)
(keymap-set global-map "C-c g"			#'eglot)
(keymap-set global-map "C-c n"			#'display-line-numbers-mode)
(keymap-set global-map "C-c r"			#'recentf)
(keymap-set global-map "C-M-S-<down>"	#'duplicate-dwim)
(keymap-set global-map "C-x C-b"		#'ibuffer)

;; Treesitter
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))

(add-to-list 'auto-mode-alist '("\\.[jt]s\\'"	 . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.[jt]sx\\'"	 . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'"	     . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'"	     . php-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'"	     . go-ts-mode))

;; Builtin Packages
(use-package dired
  :custom
  (default-directory "~/Dev/")
  (dired-listing-switches "-alh")
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t))

(use-package org
  :hook ((org-mode . visual-line-mode)
	 (org-mode . org-indent-mode))
  :custom
  (org-directory "~/org/")
  (org-agenda-files '("~/org/agenda.org"))
  :config
  (add-to-list 'org-src-lang-modes '("rust" . rust-ts)))

(use-package eglot
  :bind (:map eglot-mode-map
	      ("C-c C-r" . eglot-rename)
	      ("C-c C-a" . eglot-code-actions)
	      ("C-c C-f" . eglot-format-buffer)
	      ("C-c C-q" . eglot-shutdown)))

(use-package flymake
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

;; External Packages

(use-package corfu
  :ensure t
  ;; :custom
  ;; (setq corfu-auto t
  ;;       corfu-quit-no-match 'separator)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package expand-region :bind (("C-=" . er/expand-region)))
(use-package multiple-cursors
  :ensure t
  :bind
  (("C-S-<down>"     . mc/mark-next-like-this)
   ("C-S-<up>"       . mc/mark-previous-like-this)
   ("C-."            . mc/mark-next-like-this-symbol)
   ("C-c C-S-<down>" . mc/mark-all-like-this)))

(use-package move-text
  :bind (("M-<up>"   . move-text-up)
         ("M-<down>" . move-text-down)))
