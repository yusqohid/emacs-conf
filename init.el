;; Initialize package sources  -*- lexical-binding: t; -*-
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Load Custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Minimal UI adjustments
(setq inhibit-startup-screen t)
(tool-bar-mode      -1)
(menu-bar-mode      -1)
(scroll-bar-mode    -1)
(tooltip-mode       -1)
(load-theme 'gruvbox-dark-hard t)
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-12"))
;; (add-to-list 'default-frame-alist '(alpha-background . 85))
(set-face-attribute 'line-number nil                :background 'unspecified)
(set-face-attribute 'line-number-current-line nil   :background 'unspecified)
(set-face-background 'fringe (face-background 'default))

;; QoL
(fido-vertical-mode 1)
(which-key-mode 1)
(repeat-mode 1)
(electric-pair-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(delete-selection-mode 1)
(global-auto-revert-mode 1)
(column-number-mode 1)

;; Variable Customization
(add-hook 'prog-mode-hook #'subword-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(setq duplicate-line-final-position 1
      completion-ignore-case t
      use-short-answers t
      shell-file-name "/usr/bin/bash"
      imenu-flatten 'prefix
      imenu-auto-rescan t
      use-package-enable-imenu-support t)

;; Delete by moving to trash in interactive mode
(setq delete-by-moving-to-trash (not noninteractive)
      remote-file-name-inhibit-delete-by-moving-to-trash t)

(setq-default c-basic-offset 4
              c-ts-mode-indent-offset 4
              indent-tabs-mode nil
              tab-width 4)

;; Global Keybindings
(keymap-set global-map "C-c c"          #'compile)
(keymap-set global-map "C-c g"          #'eglot)
(keymap-set global-map "C-c n"          #'display-line-numbers-mode)
(keymap-set global-map "C-c r"          #'recentf)
(keymap-set global-map "C-c f"          #'consult-fd)
(keymap-set global-map "C-M-S-<down>"   #'duplicate-dwim)
(keymap-set global-map "C-x C-b"        #'ibuffer)

;; Treesitter
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))

(add-to-list 'auto-mode-alist '("\\.[jt]s\\'"    . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.[jt]sx\\'"   . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'"       . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'"      . php-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'"       . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.odin\\'"     . odin-ts-mode))

(add-hook 'c-ts-mode-hook 'eglot-ensure)

;; Builtin Packages
(use-package dired
  :custom
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
  :config
  (add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider)
  (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
  (add-to-list 'eglot-ignored-server-capabilities :semanticTokensProvider)
  :bind (:map eglot-mode-map
              ("C-c C-r" . eglot-rename)
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-f" . eglot-format-buffer)
              ("C-c C-q" . eglot-shutdown)))

(use-package flymake
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

;; External Packages

(use-package company
  :ensure t
  :bind ("M-<tab>" . company-complete)
  :init
  (global-company-mode 1))

(use-package yasnippet     :init (yas-global-mode 1))
(use-package expand-region :bind (("C-=" . er/expand-region)))
(use-package multiple-cursors
  :bind (("C-S-<down>"     . mc/mark-next-like-this)
         ("C-S-<up>"       . mc/mark-previous-like-this)
         ("C-."            . mc/mark-next-like-this-symbol)
         ("C-c C-S-<down>" . mc/mark-all-like-this)))

(use-package move-text
  :bind (("M-<up>"         . move-text-up)
         ("M-<down>"       . move-text-down)))

(use-package diff-hl
  :hook ((prog-mode  . diff-hl-mode)
         (text-mode  . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  (diff-hl-flydiff-mode)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))
