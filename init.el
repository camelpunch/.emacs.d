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
    paredit
    rainbow-delimiters
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

(when (package-installed-p 'rainbow-delimiters)
  (require 'rainbow-delimiters)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(when (package-installed-p 'paredit)
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'clojure-mode-hook          #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode))

;;;; editor config

(xterm-mouse-mode t)
(global-set-key [mouse-4] '(lambda ()
			     (interactive)
			     (scroll-down 1)))
(global-set-key [mouse-5] '(lambda ()
			     (interactive)
			     (scroll-up 1)))
