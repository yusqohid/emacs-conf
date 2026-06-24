(setq custom-file "~/.config/emacs/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(require 'use-package)
(setq use-package-always-ensure t)

(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
;; (evil-mode 1)

(use-package company
  :ensure t
)

;; (use-package undo-fu
;;   :ensure t)
;;
;; (use-package undo-fu-session
;;   :ensure t
;;   :after undo-fu
;;   :config
;;   (undo-fu-session-global-mode))

;; (use-package base16-theme
;;   :ensure t
;;   :config
;;   (load-theme 'base16-default-dark t))
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
  :init
  (add-to-list 'default-frame-alist '(font . "Terminess Nerd Font-16"))
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (column-number-mode 1)
  ;; (electric-pair-mode 1)
  (fido-vertical-mode 1)
  (pixel-scroll-precision-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (global-auto-revert-mode 1)
  (delete-selection-mode 1)
  ;; (load-theme 'modus-vivendi t))

  :config
  ;; (windmove-default-keybindings 'meta)

  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (add-hook 'prog-mode-hook #'whitespace-mode)
  (add-hook 'text-mode-hook #'display-line-numbers-mode);transparent line number
  (add-hook 'emacs-lisp-mode-hook #'hs-minor-mode)
  (add-hook 'js-ts-mode-hook #'eglot-ensure) ; eglot auto load
  (add-hook 'typescript-ts-mode-hook #'eglot-ensure)
  (add-hook 'tsx-ts-mode-hook #'eglot-ensure)

  (setq default-directory "~/Dev/")
  (setq use-package-always-defer t)
  (setq use-short-answers t)
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq inhibit-splash-screen t
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

  ;; Fungsi untuk menyalin teks yang diblok ke Clipboard sistem
  (defun my/copy-to-clipboard ()
    (interactive)
    (if (region-active-p)
        (progn
          (let ((select-enable-clipboard t))
            (kill-ring-save (region-beginning) (region-end)))
          (message "Text Copied to Clipboard"))
      (message "Unable to Copy, Select text first!")))

  ;; Fungsi untuk menempel teks dari Clipboard sistem
  ;; (defun my/paste-from-clipboard ()
  ;;   (interactive)
  ;;   (let ((select-enable-clipboard t))
  ;;     (yank)))
  (defun my/paste-from-clipboard ()
    (interactive)
    (insert (gui-get-selection 'CLIPBOARD)))

  (defun my/open-init-file ()
    "Open the initialization file."
    (interactive)
    (let ((emacs-path (expand-file-name "~/.config/emacs/init.el")))
      (find-file emacs-path)))

  (add-hook 'after-init-hook 'global-company-mode)
  ;;(add-hook 'c-mode-hook 'eglot-ensure)
  ;;(add-hook 'c++-mode-hook 'eglot-ensure)
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
(setq treesit-language-source-alist
      '((typescript
         "https://github.com/tree-sitter/tree-sitter-typescript"
         "master"
         "typescript/src")
        (tsx
         "https://github.com/tree-sitter/tree-sitter-typescript"
         "master"
         "tsx/src")))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

(load-file custom-file)
