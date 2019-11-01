;;; init.el --- Andrew's config

;;; Commentary:
;;; It's pretty sweet

;;; Code:

;; packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(defvar config-packages
  '(
    company
    dracula-theme
    exec-path-from-shell
    flycheck
    git-gutter
    haskell-mode
    hasklig-mode
    hlint-refactor
    idris-mode
    intero
    magit
    paredit
    projectile
    rainbow-delimiters
    terraform-mode
    tide
    web-mode
    which-key
    yaml-mode
    ))

(defun install-packages ()
  "Install packages that I use."
  (interactive)
  (package-refresh-contents)
  (mapc #'(lambda (package)
	    (unless (package-installed-p package)
              (package-install package)))
	config-packages))

;; use gpg-agent as SSH agent
(setenv "SSH_AUTH_SOCK"
        "/run/user/1000/gnupg/S.gpg-agent.ssh")

(when (not (display-graphic-p)) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(blink-cursor-mode 0)
(winner-mode 1)
(savehist-mode 1)
(require 'mouse)
(xterm-mouse-mode t)
(defvar mouse-sel-mode)
(setq mouse-sel-mode t)
(setq ring-bell-function 'ignore)
(global-auto-revert-mode t)
(setq make-backup-files nil)
(when (package-installed-p 'which-key)
  (which-key-mode))

;; font
(set-face-attribute 'default nil
                    :family "Hasklig"
                    :height 120
                    :weight 'normal
                    :width 'normal)
(when (and (package-installed-p 'hasklig-mode)
           (display-graphic-p))
  (add-hook 'prog-mode-hook 'hasklig-mode))
(custom-set-faces
 '(completions-common-part ((t (:height 1.0 :width normal))))
 '(font-lock-function-name-face ((t (:height 1.0)))))

;; no tabs!
(setq-default indent-tabs-mode nil)

;; show filename in title bar regardless of numbers of frames
(setq frame-title-format "%b")

;; no line wrapping
(set-default 'truncate-lines t)

;; all programming languages
(add-hook 'prog-mode-hook
          ;; highlight parens
          'show-paren-mode
          'eldoc-mode)

(setq-default display-line-numbers t)

(add-hook 'before-save-hook
          'delete-trailing-whitespace)

(defvar company-idle-delay) ; autocomplete delay
(setq company-idle-delay 0.1
      indent-tabs-mode nil
      column-number-mode t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil
      inhibit-startup-message t)

;; mouse
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)
(global-set-key (kbd "<mouse-4>") #'scroll-down-line)
(global-set-key (kbd "<mouse-5>") #'scroll-up-line)
(global-set-key (kbd "<mouse-6>") #'ignore)
(global-set-key (kbd "<mouse-7>") #'ignore)

;; copy PATH from shell
(when (package-installed-p 'exec-path-from-shell)
  (add-hook 'after-init-hook 'exec-path-from-shell-initialize))

;; git gutter
(when (package-installed-p 'git-gutter)
  (add-hook 'after-init-hook 'global-git-gutter-mode))

;; autocompletion
(when (package-installed-p 'company)
  (add-hook 'after-init-hook 'global-company-mode))

;; paredit
(when (package-installed-p 'paredit)
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
  (add-hook 'haskell-mode-hook          #'enable-paredit-mode)
  (add-hook 'idris-mode-hook            #'enable-paredit-mode))

;; rainbow parens
(when (package-installed-p 'rainbow-delimiters)
  (require 'rainbow-delimiters)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; terraform
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

;; typescript
(defun setup-tide-mode ()
  "Set up Tide for TypeScript."
  (interactive)
  (tide-setup)
  (tide-hl-identifier-mode +1)
  (electric-indent-mode -1))

(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; align autocomplete tooltips to the right hand side
(defvar company-tooltip-align-annotations)
(setq company-tooltip-align-annotations t)

;; haskell
(defvar haskell-stylish-on-save)
(setq haskell-stylish-on-save t)

(defvar haskell-mode-stylish-haskell-path)
(setq haskell-mode-stylish-haskell-path "brittany")

(when (package-installed-p 'intero)
  (add-hook 'haskell-mode-hook 'intero-mode))
(with-eval-after-load 'intero
  (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
  )
(haskell-indentation-mode -1)

;; idris
(add-hook 'idris-mode-hook
	  (lambda ()
	    (local-set-key [backtab] (quote idris-simple-indent-backtab))
	    (local-set-key [?\t] (quote idris-simple-indent))))

;; projectile fuzzy find
(when (package-installed-p 'projectile)
  (projectile-mode +1)
  (recentf-mode +1)
  (defvar projectile-mode-map)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; magit
(global-set-key (kbd "C-x g") 'magit-status)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(blink-cursor-mode nil)
 '(case-replace nil)
 '(company-idle-delay 0.1)
 '(company-tooltip-align-annotations t)
 '(custom-enabled-themes (quote (dracula)))
 '(custom-safe-themes
   (quote
    ("274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" "aaffceb9b0f539b6ad6becb8e96a04f2140c8faa1de8039a343a4f1e009174fb" "4bfced46dcfc40c45b076a1758ca106a947b1b6a6ff79a3281f3accacfb3243c" "2a739405edf418b8581dcd176aaf695d319f99e3488224a3c495cb0f9fd814e3" default)))
 '(fci-rule-color "#383838")
 '(flycheck-global-modes (quote (not idris-mode)))
 '(global-company-mode t)
 '(global-flycheck-mode t)
 '(haskell-literate-default (quote bird))
 '(haskellindent-spaces 2)
 '(idris-stay-in-current-window-on-compiler-error t)
 '(intero-extra-ghc-options (quote ("-Wno-type-defaults")))
 '(intero-pop-to-repl nil)
 '(mouse-wheel-scroll-amount (quote (3 ((shift) . 1))))
 '(package-selected-packages
   (quote
    (kubernetes which-key hlint-refactor web-mode projectile haskell-mode flycheck dracula-theme company exec-path-from-shell hasklig-mode markdown-preview-mode terraform-mode toml-mode dockerfile-mode flymd git-gutter yaml-mode rainbow-delimiters paredit magit intero idris-mode)))
 '(safe-local-variable-values
   (quote
    ((intero-targets "infrastructure:lib" "infrastructure:exe:release" "infrastructure:test:infrastructure-test")
     (idris-load-packages "mrk")
     (intero-targets "release:lib" "release:exe:release-exe" "release:test:release-test")
     (idris-load-packages "contrib"))))
 '(typescript-indent-level 2))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(provide 'init)
;;; init.el ends here
