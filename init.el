(setq debug-on-error t)
;; Disable startup message
(setq inhibit-startup-message t)
(scroll-bar-mode -1)   ; Disable visible scrollbar
(tool-bar-mode -1)     ; Disable the toolbar
(tooltip-mode -1)      ; Disable tooltips
(set-fringe-mode 10)   ; Give some breathing room

(menu-bar-mode -1)      ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
	      term-mode-hook
	      eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "JetBrains Mono" :height 170) ; Set the font face

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Intialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
 (unless package-archive-contents
  (package-refresh-`contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind(("C-s" . swiper)
	:map ivy-minibuffer-map
	("TAB" . ivy-alt-done)
	("C-l" . ivy-alt-done)
	("C-j" . ivy-next-line)
	("C-k" . ivy-previous-line)
	:map ivy-switch-buffer-map
 	("C-k" . ivy-previous-line)
	("C-l" . ivy-done)
	("C-d" . ivy-switch-buffer-kill)
	:map ivy-reverse-i-search-map
	("C-k" . ivy-previous-line)
	("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1))

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :after counsel)

(use-package counsel
 :bind(
	("M-x" . counsel-M-x)
	("C-x b" . counsel-ibuffer)
	("C-x C-f" . counsel-find-file)
	:map minibuffer-local-map
	("C-r" . counsel-minibuffer-history))
 :config
 (setq ivy-initial-inputs-alist nil)) 

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(use-package all-the-icons ; Icons for doom-modeline
  :if (display-graphic-p)
  :commands all-the-icons-install-fonts
  :init
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish (which-key-mode)
  :config
    (setq which-key-idle-delay 0.3))

(use-package doom-modeline
  :init 
  (doom-modeline-mode 1)
  :custom 
  (doom-modeline-height 15))
  
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package general
  :config
  (general-create-definer bob/leader-keys
   :keymaps '(normal insert visual emacs)
   :prefix "SPC"
   :global-prefix "C-SPC")

  (bob/leader-keys
   "t"  '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffermode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(bob/leader-keys
  "ts" '(hydra-scale-text/body :which-key "scale text"))
