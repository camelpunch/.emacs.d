;;; init.el --- Andrew's config

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
    elm-mode
    erlang
    fiplr
    haskell-mode
    intero
    paredit
    rainbow-delimiters
    rust-mode
    yaml-mode
    ))

(defun install-packages ()
  "Install packages that I use"
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
  (add-hook 'haskell-mode-hook          #'enable-paredit-mode))

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

;;;; haskell config
(setq haskell-stylish-on-save t)

;;;; editor config
(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))
(setq mouse-sel-mode t)
(global-auto-revert-mode t)
(global-set-key [mouse-4] '(lambda ()
			     (interactive)
			     (scroll-down 1)))
(global-set-key [mouse-5] '(lambda ()
			     (interactive)
			     (scroll-up 1)))
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(add-hook 'prog-mode-hook 'show-paren-mode)

(setq fiplr-ignored-globs '((directories (".git" ".stack-work" "elm-stuff"))
			    (files ("*.jpg" "*.png" "*.zip" "*~"))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(clojure-align-forms-automatically t)
 '(elm-format-on-save t)
 '(elm-indent-offset 2)
 '(haskellindent-spaces 2)
 '(haskell-indentation-layout-offset 2)
 '(haskell-indentation-left-offset 2)
 '(haskell-indentation-starter-offset 2)
 '(package-selected-packages
   (quote
    (magit intero yaml-mode rust-mode rainbow-delimiters paredit haskell-mode fiplr erlang elm-mode company cider)))
 '(send-mail-function (quote sendmail-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
