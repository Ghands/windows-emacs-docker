;;; Set the startup screen
(setq inhibit-startup-message t)
;;; Don't open file of user dialog
(setq use-file-dialog nil)
(setq use-dialog-box nil)
;;; Change the cursor from block to bar
(setq-default cursor-type 'block)
;;; (setq-default cursor-color "#f08080")
(set-cursor-color "#f08080")
;;; Show line number global
;; (global-linum-mode 1)
;;; Highlight the paren
(show-paren-mode 1)
;;; Close the scroll bar
(scroll-bar-mode 0)
;;; Close the tool bar
(tool-bar-mode 0)
;;; Highlight the current line
(global-hl-line-mode 1)
;;; Disable the bell function
(setq ring-bell-function 'ignore)
;;; Make the line truncated automatically
(global-visual-line-mode 1)

;;; Set the network proxy
;;(setq url-proxy-services '(("http" . "127.0.0.1:12333")))

;;; Automatic generated configurations by emacs
(setq custom-file "custom.el")
(load custom-file)

;;; Initialize package.el
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;;; Install use-package
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;; Install custom theme
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;;; Install and configure flyspell
(use-package flyspell
  :ensure t
  :demand
  :config
  (setq-default ispell-program-name "/usr/bin/hunspell")
  (setq ispell-local-dictionary "en_US")
  (setq ispell-local-dictionary-alist
      '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

;;; configure org-mode
;;  (setq org-file-apps '("\\.pdf\\'" . "evince %s")))
;;  (progn (setcdr (assoc "\\.pdf\\'" org-file-apps) "evince %s")))
(use-package org-ref
  :ensure t
  :after org
  :config
  (setq org-startup-indented t)
  (plist-put org-format-latex-options :scale 2)
  (add-hook 'org-mode-hook 'flyspell-mode)
  (setq reftex-default-bibliography '("~/Nextcloud/PaperReading/database.bib"))
  (setq org-ref-bibliography-notes "~/Nextcloud/PaperReading/database.org"
      org-ref-default-bibliography '("~/Nextcloud/PaperReading/database.bib")
      org-ref-pdf-directory "~/Nextcloud/PaperReading/pdfs/")
  ;;  (setq org-file-apps '("\\.pdf\\'" . "evince %s"))
  (eval-after-load "org" '(progn (setcdr (assoc "\\.pdf\\'" org-file-apps) "evince %s")))
  (defun my/org-ref-open-pdf-at-point ()
    "Open the pdf for bibtex key under point if it exists."
    (interactive)
    (let* ((results (org-ref-get-bibtex-key-and-file))
           (key (car results))
       (pdf-file (car (bibtex-completion-find-pdf key))))
      (if (file-exists-p pdf-file)
      (funcall bibtex-completion-pdf-open-function pdf-file)
      (message "No PDF found for %s" key))))
  (setq org-ref-open-pdf-at-point 'my/org-ref-open-pdf-at-point))

;;; Install and configure ssh-deploy
(use-package hydra
  :ensure t
  :defer t)
(use-package ssh-deploy
  :ensure t
  :demand
  :after hydra
  :hook ((after-save . ssh-deploy-after-save)
	 (find-file . ssh-deploy-find-file))
  :bind-keymap
  ("C-c s" . ssh-deploy-prefix-map))

;;; Install and configure projectile
(use-package projectile
  :ensure t
  :demand
  :bind-keymap
  ("C-c p" . projectile-command-map))

;;; Install and configure helm, which is benefit for index
(use-package helm
  :ensure t
  :demand
  :bind
  ("M-x" . 'helm-M-x)
  ("C-s" . 'helm-occur)
  ("C-x b" . 'helm-mini)
  ("C-x C-f" . 'helm-find-files)
  :config
  (setq helm-split-window-in-side-p t
	helm-M-x-fuzzy-match t))

;;; Install and configure the key cheatsheet, which can company your shortcut
(use-package which-key
  :ensure t
  :demand
  :config
  (which-key-mode))

;;; Install git related packages
(use-package magit
  :ensure t)

;;; Install diff-hl to highlight uncommited changes
(use-package diff-hl
  :ensure t
  :demand t
  :config
  (global-diff-hl-mode))

;;; Install and configure auctex
(use-package cdlatex
  :ensure t
  :defer t)
(use-package tex
  :ensure auctex
  :defer t
  :config
  (setq-default TeX-master nil)
  (setq TeX-PDF-mode t)
  (mapc (lambda (model)
	  (add-hook 'LaTeX-mode-hook model))
	(list 'turn-on-cdlatex
	      'reftex-mode
	      'outline-minor-mode
	      'flyspell-mode
	      'hide-body t
	      '(lambda () (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)% %t" TeX-run-TeX nil t)))
	      )))

;;; Install and configure python development environment
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setq elpy-rpc-backend "jedi"
	elpy-rpc-python-command "~/.venv/work/bin/python3")
  (setq python-shell-interpreter "~/.venv/work/bin/ipython3"
	python-shell-interpreter-args "-i --simple-prompt"))

;;; Install and configure ipython-notebook
(use-package ein
  :ensure t
  :defer t
  :config
  (require 'ein)
  (require 'ein-notebook)
  (require 'ein-subpackages))

;;; Install the tool to transform file into other formats
(use-package ox-pandoc
  :ensure t
  :defer t)

;;; Install multi-term to support multiple terminals in Emacs
(use-package multi-term
  :ensure t
  :defer t)
