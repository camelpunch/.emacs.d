;;; init.el --- Andrew's config

;;; Commentary:
;;; It's pretty sweet

;;; Code:
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-message t)

;;;; packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(defvar packages
  '(
    cider
    clojure-mode
    company
    dracula-theme
    elm-mode
    erlang
    eziam-theme
    flycheck
    git-gutter
    go-guru
    go-mode
    haskell-mode
    idris-mode
    intero
    magit
    paredit
    projectile
    rainbow-delimiters
    rust-mode
    terraform-mode
    tide
    web-mode
    yaml-mode
    ))

(defun install-packages ()
  "Install packages that I use."
  (interactive)
  (package-refresh-contents)
  (mapc #'(lambda (package)
	    (unless (package-installed-p package)
              (package-install package)))
	packages))

;;;; enable packages

(when (package-installed-p 'git-gutter)
  (add-hook 'after-init-hook 'global-git-gutter-mode))

(when (package-installed-p 'company)
  (add-hook 'after-init-hook 'global-company-mode))

(when (package-installed-p 'paredit)
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'clojure-mode-hook          #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
  (add-hook 'haskell-mode-hook          #'enable-paredit-mode)
  (add-hook 'idris-mode-hook            #'enable-paredit-mode))

(when (package-installed-p 'rainbow-delimiters)
  (require 'rainbow-delimiters)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(when (package-installed-p 'intero)
  (add-hook 'haskell-mode-hook 'intero-mode))

;;;; clojure boot config
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))

;;;; cider config
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq nrepl-log-messages t)
(setq cider-prompt-for-symbol nil)

;;;; elm config
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-elm))
(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)

;;;; go config
(setq gofmt-command "goimports")
(add-hook 'before-save-hook #'gofmt-before-save)
(setq gofmt-before-save t)
(require 'go-guru)
(add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)

;;;; terraform config
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

;;;; typescript config
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (add-hook 'before-save-hook 'tide-format-before-save)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;;;; haskell config
(setq haskell-stylish-on-save t)
(with-eval-after-load 'intero
  (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
)

;;;; idris config
(add-hook 'idris-mode-hook
	  (lambda ()
	    (local-set-key [backtab] (quote idris-simple-indent-backtab))
	    (local-set-key [?\t] (quote idris-simple-indent))))

;;;; editor config

;; no tabs!
(setq-default indent-tabs-mode nil)

;; faster autocomplete
(setq company-idle-delay 0.1)

;; show filename in title bar regardless of numbers of frames
(setq frame-title-format "%b")

(set-face-attribute 'default nil :height 140)

;; org mode
(setq org-log-done 'time)

(add-to-list 'load-path "~/path/to/org-present")
(autoload 'org-present "org-present" nil t)

(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-read-write)))))

;; the rest

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(blink-cursor-mode 0)
(winner-mode 1)
(savehist-mode 1)
(setq linum-format "%d ")
(require 'mouse)
(xterm-mouse-mode t)
(setq mouse-sel-mode t)
(setq ring-bell-function 'ignore)
(global-auto-revert-mode t)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)
(global-set-key (kbd "<mouse-6>") #'ignore)
(global-set-key (kbd "<mouse-7>") #'ignore)

(projectile-mode +1)
(recentf-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(global-set-key (kbd "C-x g") 'magit-status)
(add-hook 'prog-mode-hook 'show-paren-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(clojure-align-forms-automatically t)
 '(custom-enabled-themes (quote (dracula)))
 '(custom-safe-themes
   (quote
    ("aaffceb9b0f539b6ad6becb8e96a04f2140c8faa1de8039a343a4f1e009174fb" "4bfced46dcfc40c45b076a1758ca106a947b1b6a6ff79a3281f3accacfb3243c" "2a739405edf418b8581dcd176aaf695d319f99e3488224a3c495cb0f9fd814e3" default)))
 '(elm-format-on-save t)
 '(elm-indent-offset 2)
 '(fci-rule-color "#383838")
 '(flycheck-global-modes (quote (not idris-mode)))
 '(global-flycheck-mode t)
 '(haskell-indentation-layout-offset 2)
 '(haskell-indentation-left-offset 2)
 '(haskell-indentation-starter-offset 2)
 '(haskellindent-spaces 2)
 '(idris-stay-in-current-window-on-compiler-error t)
 '(intero-extra-ghc-options (quote ("-W" "-Werror")))
 '(intero-pop-to-repl nil)
 '(package-selected-packages
   (quote
    (php-mode ruby-refactor tide markdown-preview-mode flycheck-gometalinter terraform-mode go-guru neotree toml-mode org-present dockerfile-mode flymd git-gutter yaml-mode rust-mode rainbow-delimiters paredit magit intero idris-mode go-mode fiplr eziam-theme erlang elm-mode cider)))
 '(safe-local-variable-values (quote ((idris-load-packages "contrib"))))
 '(send-mail-function (quote sendmail-send-it))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Variable" :foundry "ADBO" :slant normal :weight normal :height 128 :width normal)))))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
