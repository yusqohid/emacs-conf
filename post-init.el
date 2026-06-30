;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  (diff-hl-flydiff-mode)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

(use-package evil
  :ensure t
  :init
  (require 'evil))

(use-package org
  :ensure nil
  :defer t
  :config
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-content-indentation 0)
  (add-to-list 'org-src-lang-modes '("rust" . rust-ts)))

(use-package tex
  :ensure auctex
  :hook (LaTeX-mode . visual-line-mode)
  :hook (LaTeX-mode . flyspell-mode)
  :hook (LaTeX-mode . LaTeX-math-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-view-program-selection
      '((output-pdf "xdg-open")))

  ;; gunakan PDF
  (setq TeX-PDF-mode t)

  ;; compile dengan latexmk
  (setq TeX-command-default "LatexMk"))

;; (use-package undo-fu
;;   :ensure t)
;;
;; (use-package undo-fu-session
;;   :ensure t
;;   :after undo-fu
;;   :config
;;   (undo-fu-session-global-mode))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-opera t)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode))

(use-package magit
  :ensure t
  :commands magit)

(use-package emacs
  :ensure nil
  :init
  (add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font-16"))
  (column-number-mode 1)
  (repeat-mode 1)
  ;; (electric-pair-mode 1)
  (fido-vertical-mode 1)
  (which-key-mode 1)
  (pixel-scroll-precision-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (global-auto-revert-mode 1)
  (delete-selection-mode 1)
  ;; (load-theme 'modus-vivendi t))

  :config
  ;; (windmove-default-keybindings 'control)

  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  ;;(add-hook 'prog-mode-hook #'whitespace-mode)
  (add-hook 'text-mode-hook #'display-line-numbers-mode)
  (add-hook 'emacs-lisp-mode-hook #'hs-minor-mode)
  (add-hook 'js-ts-mode-hook #'eglot-ensure) ; eglot auto load
  (add-hook 'typescript-ts-mode-hook #'eglot-ensure)
  (add-hook 'tsx-ts-mode-hook #'eglot-ensure)

  (setq default-directory "~/Dev/")
  (setq dired-kill-when-opening-new-dired-buffer t
        explicit-shell-file-name "/usr/bin/bash"
        shell-file-name "/usr/bin/bash")
  ;; Stop Emacs from overwriting OS clipboard
  (setq select-enable-clipboard nil)
  (setq select-enable-primary nil)

  (setq-default indent-tabs-mode nil
                c-basic-offset 4
                c-default-style "k&r"
                tab-width 4)

  (with-eval-after-load 'display-line-numbers
    (set-face-attribute 'line-number nil :background 'unspecified)
    (set-face-attribute 'line-number-current-line nil :background 'unspecified))

  (defun my/copy-to-clipboard ()
    (interactive)
    (if (region-active-p)
        (progn
          (let ((select-enable-clipboard t))
            (kill-ring-save (region-beginning) (region-end)))
          (message "Text Copied to Clipboard"))
      (message "Unable to Copy, Select text first!")))

  (defun my/paste-from-clipboard ()
    (interactive)
    (insert (gui-get-selection 'CLIPBOARD)))

  (defun my/open-init-file ()
    "Open the initialization file."
    (interactive)
    (let ((emacs-path (expand-file-name "~/.config/emacs/post-init.el")))
      (find-file emacs-path)))

  ;;(add-hook 'c-mode-hook 'eglot-ensure)

  (add-hook 'prog-mode-hook
            (lambda ()
              (local-set-key (kbd "<f5>") #'compile)))

  (keymap-set global-map "C-c n" #'display-line-numbers-mode)
  (keymap-set global-map "C-c a" #'my/open-init-file)
  (keymap-set global-map "C-c v" #'evil-mode)
  (keymap-set global-map "C-c f r" #'recentf-open)
  (keymap-set global-map "C-S-c" #'my/copy-to-clipboard)
  (keymap-set global-map "C-S-v" #'my/paste-from-clipboard)
)
;; Treesitter
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
