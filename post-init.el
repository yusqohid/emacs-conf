;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
(when (file-exists-p custom-file)
  (load custom-file))

(use-package corfu
  :init
    (setq corfu-auto t
          corfu-auto-delay 0.4
          corfu-quit-no-match 'separator)
    (global-corfu-mode)
    (corfu-popupinfo-mode))

(use-package move-text
  :bind (("M-<up>" . move-text-up)
         ("M-<down>" . move-text-down)))

(use-package evil :bind (("C-c v" . evil-mode)))

(use-package vterm
  :bind
  (:map vterm-mode-map
        ("C-S-v" . my-vterm-paste))
  :config
  (setq vterm-shell (executable-find "fish")))

(use-package vertico
  :init (vertico-mode)
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char)))

(use-package yasnippet  :init (yas-global-mode 1))
(use-package orderless  :custom (completion-styles '(orderless basic)))
(use-package marginalia :init (marginalia-mode))
(use-package hl-todo    :hook (prog-mode . hl-todo-mode))
(use-package magit      :commands magit)
(use-package avy        :bind ("C-;"   . avy-goto-char-2))
(use-package consult
  :bind
  (("M-g i" . consult-imenu)
   ("M-s l" . consult-line)
   ("M-s r" . consult-ripgrep)
   ("M-s f" . consult-fd)
   ("C-x b" . consult-buffer)
   ("C-x p b" . consult-project-buffer)))

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  (diff-hl-flydiff-mode)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

(use-package expand-region :bind (("C-=" . er/expand-region)))
(use-package multiple-cursors
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-." . mc/mark-next-like-this-symbol)
   ("C-c C->" . mc/mark-all-like-this)))

(use-package markdown-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

(use-package org
  :ensure nil
  :defer t
  :hook (org-mode . org-indent-mode)
  :init
  (setq org-src-tab-acts-natively t
        org-edit-src-content-indentation 0)
  :config
  (add-to-list 'org-src-lang-modes '("rust" . rust-ts)))

;; (use-package tex
;;   :ensure auctex
;;   :hook (LaTeX-mode . visual-line-mode)
;;   :hook (LaTeX-mode . flyspell-mode)
;;   :hook (LaTeX-mode . LaTeX-math-mode)
;;   :config
;;   (setq TeX-auto-save t)
;;   (setq TeX-parse-self t)
;;   (setq-default TeX-master nil)
;;   (setq TeX-view-program-selection
;;       '((output-pdf "xdg-open")))
;;
;;   ;; gunakan PDF
;;   (setq TeX-PDF-mode t)
;;
;;   ;; compile dengan latexmk
;;   (setq TeX-command-default "LatexMk"))

(use-package undo-fu)
(use-package undo-fu-session
  :after undo-fu
  :config
  (undo-fu-session-global-mode))

(use-package doom-themes
  :config
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-org-config))  ;; Corrects (and improves) org-mode's native fontification

(use-package emacs
  :ensure nil
  :init
  (add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font-18"))
  (column-number-mode 1)
  (repeat-mode 1)
  (electric-pair-mode 1)
  (which-key-mode 1)
  (pixel-scroll-precision-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (global-auto-revert-mode 1)
  (delete-selection-mode 1)
  (save-place-mode 1)
  ;;(load-theme 'modus-vivendi-deuteranopia t)

  :config
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (add-hook 'emacs-lisp-mode-hook #'hs-minor-mode)

  (setq default-directory "~/Dev/"
        dired-dwim-target t
        dired-kill-when-opening-new-dired-buffer t
        completion-ignore-case t)
  (setq shell-file-name "/usr/bin/bash")
  (setq select-enable-clipboard nil
        select-enable-primary nil)
  (setq debug-on-error t)

  (setq-default indent-tabs-mode nil
                c-basic-offset 4
                c-ts-mode-indent-offset 4
                c-default-style "k&r"
                tab-width 4)
  (setq-default line-spacing 0.2)
  (add-hook 'vterm-mode-hook (lambda() (setq-local line-spacing nil)))

  ;; CUSTOM FUNCTION
(defun my/apply-line-number-faces (&rest _)
  (interactive)
  (set-face-background 'fringe (face-background 'default))
  (set-face-attribute 'line-number nil
                      :background 'unspecified
                      :foreground "#5f5f5f")
  (set-face-attribute 'line-number-current-line nil
                      :background 'unspecified))

  (with-eval-after-load 'display-line-numbers
    (my/apply-line-number-faces))

  (add-hook 'enable-theme-functions #'my/apply-line-number-faces)
  (keymap-set global-map "<f5>" #'modus-themes-toggle)

  (setq modus-themes-common-palette-overrides
        '((variable white)))
  
  (defun my-vterm-paste ()
  (interactive)
  (when-let ((text (gui-get-selection 'CLIPBOARD)))
    (vterm-send-string text)))

  (keymap-set global-map "C-c n"   #'display-line-numbers-mode)
  (keymap-set global-map "C-c c"   #'compile)
  (keymap-set global-map "C-c g"   #'eglot)
  (keymap-set global-map "C-c o"   #'olivetti-mode)
  (keymap-set global-map "C-c r"   #'recentf-open)
  (keymap-set global-map "C-S-c"   #'clipboard-kill-ring-save)
  (keymap-set global-map "C-S-v"   #'clipboard-yank)
  (keymap-set global-map "C-c ,"   #'duplicate-line)
  (keymap-set global-map "C-c p"   #'project-find-file)
  (keymap-set global-map "C-c d w"   #'delete-trailing-whitespace)
  (keymap-set global-map "M-z"     #'zap-up-to-char)
  )

(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider)
  (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
  :bind (:map eglot-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)))

;; Treesitter
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))

(add-to-list 'auto-mode-alist '("\\.[jt]s\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.[jt]sx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))

(use-package odin-ts-mode
  :vc (:url "https://github.com/Sampie159/odin-ts-mode")
  :mode "\\.odin\\'")

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest :branch "main"))

(with-eval-after-load 'go-ts-mode
  (setq go-ts-mode-indent-offset 4))
