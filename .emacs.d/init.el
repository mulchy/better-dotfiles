;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; disable gui stuff
(tool-bar-mode -1)
(menu-bar-mode -1)

(when window-system
  (scroll-bar-mode -1))

;; no bell or flashin
(setq ring-bell-function 'ignore)

;; disable auto-save and auto-backup
(setq-default auto-save-default nil)
(setq-default make-backup-files nil)
(setq-default create-lockfiles nil)
(global-auto-revert-mode 1)

(setq insert-directory-program "/usr/local/bin/gls")

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; require or autoload paredit-mode
(add-hook 'clojure-mode-hook #'paredit-mode)
(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; customize web mode
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-enable-auto-pairing t)
(setq web-mode-enable-auto-closing t)
(setq web-mode-enable-auto-expanding t)
(setq web-mode-auto-close-style 2)
;; (add-hook 'web-mode-hook #'(lambda () (yas-activate-extra-mode 'html-mode)))

;; js-2 mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-strict-missing-semi-warning nil)
(setq js2-missing-semi-one-line-override nil)

;; uncomment this once prettier lands on melpa
;; prettier formatting for js files
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))
(require 'prettier-js)
(setq prettier-target-mode "js2-mode")
(setq prettier-args '("--single-quote"))
(add-hook 'js-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'prettier-before-save)))

;; jsx mode
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))

(require 'elixir-mode)
(require 'alchemist)
(add-hook 'after-init-hook 'global-company-mode)
(setq alchemist-hooks-test-on-save t)
(setq alchemist-test-ask-about-save nil)
(setq alchemist-hooks-compile-on-save t)
(setq alchemist-goto-elixir-source-dir "~/Code/elixir")
;; smartparens elixir config
(require 'smartparens-config)
(sp-with-modes '(elixir-mode)
  (sp-local-pair "fn" "end"
         :when '(("SPC" "RET"))
         :actions '(insert navigate))
  (sp-local-pair "do" "end"
         :when '(("SPC" "RET"))
         :post-handlers '(sp-ruby-def-post-handler)
         :actions '(insert navigate)))

(projectile-global-mode)
(flx-ido-mode 1)
(global-set-key (kbd "s-p") 'projectile-find-file)

; 8 spaces??? r u srs
(setq-default tab-width 2)
(setq js-indent-level 2)

(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(setq neo-smart-open t)
(setq projectile-switch-project-action 'neotree-projectile-action)
(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (if project-dir
          (if (neotree-toggle)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))

;; figure out a better key bind for this
(global-set-key [f8] 'neotree-project-dir)

;; no tabs, use spaces instead
(setq-default indent-tabs-mode nil)

(load-theme 'zenburn t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; activate racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)


;; less gc pauses, who knows if this even has a noticable effect
(setq gc-cons-threshold 20000000)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (intero ag wrap-region idris-mode geiser zenburn-theme web-mode use-package solarized-theme smex smartparens rainbow-delimiters racer projectile prodigy popwin paredit pallet nyan-mode neotree multiple-cursors mocha-snippets mocha markdown-mode magit labburn-theme idle-highlight-mode htmlize highlight-parentheses helm go-mode flycheck-cask flx-ido expand-region exec-path-from-shell drag-stuff color-theme-sanityinc-tomorrow cider base16-theme alchemist)))
 '(safe-local-variable-values
   (quote
    ((cider-cljs-lein-repl . "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")
     (cider-refresh-after-fn . "reloaded.repl/resume")
     (cider-refresh-before-fn . "reloaded.repl/suspend")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(setq geiser-default-implementation "mit")
(setq geiser-active-implementations '(mit))
(setq geiser-mode-start-repl-p t)


;; haskell ligatures
(defun my-correct-symbol-bounds (pretty-alist)
  "Prepend a TAB character to each symbol in this alist,
this way compose-region called by prettify-symbols-mode
will use the correct width of the symbols
instead of the width measured by char-width."
  (mapcar (lambda (el)
            (setcdr el (string ?\t (cdr el)))
            el)
          pretty-alist))

(defun my-ligature-list (ligatures codepoint-start)
  "Create an alist of strings to replace with
codepoints starting from codepoint-start."
  (let ((codepoints (-iterate '1+ codepoint-start (length ligatures))))
    (-zip-pair ligatures codepoints)))

;; list can be found at https://github.com/i-tu/Hasklig/blob/master/GlyphOrderAndAliasDB#L1588
(setq my-hasklig-ligatures
      (let* ((ligs '("&&" "***" "*>" "\\\\" "||" "|>" "::"
                     "==" "===" "==>" "=>" "=<<" "!!" ">>"
                     ">>=" ">>>" ">>-" ">-" "->" "-<" "-<<"
                     "<*" "<*>" "<|" "<|>" "<$>" "<>" "<-"
                     "<<" "<<<" "<+>" ".." "..." "++" "+++"
                     "/=" ":::" ">=>" "->>" "<=>" "<=<" "<->")))
        (my-correct-symbol-bounds (my-ligature-list ligs #Xe100))))

;; nice glyphs for haskell with hasklig
(defun my-set-hasklig-ligatures ()
  "Add hasklig ligatures for use with prettify-symbols-mode."
  (setq prettify-symbols-alist
        (append my-hasklig-ligatures prettify-symbols-alist))
  (prettify-symbols-mode))

(add-hook 'haskell-mode-hook 'my-set-hasklig-ligatures)
(add-hook 'haskell-mode-hook #'intero-mode)
