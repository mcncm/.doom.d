;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(load "~/.doom.d/secrets.el")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (getenv "ORG_DIR"))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Fira Code Retina" :size 20)
      doom-big-font (font-spec :family "Fira Code Retina" :size 30)
      doom-variable-pitch-font (font-spec :family "ETBembo" :size 25 :weight 'thin))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'ewal-doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;;;;;;;;;;;;;;;;;
;; generalities ;;
;;;;;;;;;;;;;;;;;;

(setq +doom-dashboard-banner-dir "~/.doom.d/banner")
(setq my/banner-template-file "dodecahedron.svg")
(setq +doom-dashboard-banner-file "banner.svg")

(setq my/org-agenda-directory (concat org-directory "/agenda"))

;; More closely match the Spacemacs convention that I like. I'm still not sure
;; what the default "repeat" behavior of the comma key actually /does/. I might
;; prefer it. In any case, I should also see if I ought to unmap that key first.
;; Note that this *unmaps* 'SPC-m'.
(setq doom-localleader-key ",")


(defun my/find-file-in-home ()
  "Search for a file in home directory."
  (interactive)
  (ido-find-file-in-dir gnus-home-directory))

(defun my/find-file-in-agenda ()
  "Search for a file in home directory."
  (interactive)
  (ido-find-file-in-dir my/org-agenda-directory))

(map! :map doom-leader-file-map
      "h" #'my/find-file-in-home
      "a" #'my/find-file-in-agenda)

(defun my/ewal-color (color)
  "COLOR should be a symbol defined in ewal-base-palette. Options are:
'comment, 'background, 'foreground, 'cursor, 'black, 'red,
'green, 'yellow, 'blue, 'magenta, 'cyan, 'white"
  (cdr (assoc color ewal-base-palette)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; font and face configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Fix awful lsp colors
;; To check: are all these `after!' macros expensive? Are they huritng my
;; startup time?
(after! lsp-modeline
  (after! ewal-doom-themes
    (set-face-attribute 'lsp-modeline-code-actions-face nil
                        :foreground (my/ewal-color 'cyan))))

;; Set some org theme things
(let* ((base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :forefround ,base-font-color)))
  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline))))
   `(org-level-7 ((t (,@headline))))
   `(org-level-6 ((t (,@headline))))
   `(org-level-5 ((t (,@headline))))
   `(org-level-4 ((t (,@headline :height 1.1))))
   `(org-level-3 ((t (,@headline :height 1.25))))
   `(org-level-2 ((t (,@headline :height 1.5))))
   `(org-level-1 ((t (,@headline :height 1.75))))
   `(org-document-title ((t (,@headline :height 2.0 :underline nil))))))

(custom-set-variables '(fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#[" "#_(" "x")))
(add-hook 'prog-mode-hook 'fira-code-mode)

;; A fun little trick: recolor the banner!
;; using ~async-shell-command~ could be a problem. Maybe try ~shell-command~.
(defun my/recolor-banner ()
  (message "recoloring banner")
  (shell-command
   (concat "sed -e \"s/#000000/"
           (my/ewal-color 'blue) "/\" "
           +doom-dashboard-banner-dir "/" my/banner-template-file " > "
           +doom-dashboard-banner-dir "/" +doom-dashboard-banner-file)))

;; TODO figure out how to do this correctly
;; (advice-add 'load-theme :after #'my/recolor-banner)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; programming configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Not necessary if using :editor format-all, but that seems not to work.
(setq rustic-lsp-server 'rust-analyzer
      rustic-format-on-save t)

;; Will this make company mode work?
(set-company-backend!
  '(c-mode
    haskell-mode
    emacs-lisp-mode
    lisp-mode
    sh-mode
    python-mode
    rust-mode
    js-mode)
  '(:separate
    ;; company-tabnine
    company-files
    company-yasnippet))

(setq +lsp-company-backend
      '(company-lsp :with company-tabnine :separate))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/latex-fragment-completion ()
  ;; This regexp will trigger LaTeX compilation whenever following a '$'
  ;; character by an optional punctuation character and whitespace.
  ;; NOTE: newlines aren't working. It might be that you're supposed to use a
  ;; "character class" like [:space:] or \s-, but neither of these seems to
  ;; work.
  ;; NOTE: `looking-back' is known to be quite slow. See:
  ;; https://emacs.stackexchange.com/a/12744
  (when (looking-back "\$[\.,!?-]?\s")
    (save-excursion
      (backward-char 1)
      (org-toggle-latex-fragment))))

(after! org
  (setq-default
   org-log-done 'time
   org-hide-emphasis-markers t
   org-startup-with-latex-preview t
   org-agenda-files (directory-files my/org-agenda-directory t "\.org$")
   org-latex-create-formula-image-program 'imagemagick)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  ;; Specify the extra latex packages we want to use, and include them.
  (setq org-latex-packages-extra '("tikz" "tikz-cd" "physics"))
  ;; This assumes that there was nothing in this variable to begin with!
  (setq org-latex-packages-alist
        (mapcar (lambda (package) `("" ,package t))
              org-latex-packages-extra))
  ;; This will render the bullets more correctly!
  (set-face-attribute 'org-superstar-header-bullet nil :family "Fira Code")
  ;; actually a beaker
  (push '("research" . "") org-pretty-tags-surrogate-strings))
  ;; actually a book
  ;; (push '("read" . "read") org-pretty-tags-surrogate-strings))


;; TODO break out  a lot of these hooks into some appropriate ‘text-mode’ hook.
(add-hook 'org-mode-hook
          '(lambda ()
             ;; disable flycheck if you're in an agenda file
             (when (string-prefix-p my/org-agenda-directory (buffer-file-name))
               (flycheck-mode -1))
             (visual-line-mode) ;; improved wrapping
             (org-indent-mode)
             (olivetti-mode)
             (electric-quote-mode) ;; replace “ and ”.
             (display-line-numbers-mode -1)
             (org-variable-pitch-minor-mode)
             (org-superstar-mode)
             (org-pretty-tags-mode)
             (add-hook 'post-self-insert-hook #'my/latex-fragment-completion 'append 'local)))

(add-hook 'org-roam-mode-hook
          '(lambda ()
             ;; This shouldn't be necessary... Is it?
             (org-mode)
             ;; Do I want this in all org buffers?
             (org-zotxt-mode)))

;; org-journal configurations
(after! org-journal
  (setq-default org-journal-dir (concat org-directory "/journal")
                org-journal-encrypt-journal t
                org-journal-file-type 'weekly))

;; org-roam configurations
(after! org-roam
  (setq-default org-roam-directory (concat org-directory "/roam")))

;; deft directory
(after! org-roam
  (after! deft
    (setq-default deft-directory org-roam-directory)))

;; alert configurations
(after! alert
  (setq-default alert-default-style 'libnotify
                ;; alerts fade out after 15 seconds
                alert-fade-time 30))

(add-hook 'after-init-hook 'org-wild-notifier-mode)


;;;;;;;;;;;;;;;
;; pdf stuff ;;
;;;;;;;;;;;;;;;

;; Does the framework allow this kind of nesting of these macros?
(after! pdf
  (after! ewal-doom-themes
    ;; This should be a cons (FOREGROUND . BACKGROUND) of colors.
    (setq pdf-view-midnight-colors
          `(,(my/ewal-color 'foreground) .
            ,(my/ewal-color 'background)))))

;; Start in midnight mode!
(add-hook 'pdf-view-mode-hook #'pdf-view-midnight-minor-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Citation management ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun my/org-zotxt-get-bibtex () 1)

;; (defun my/org-zotxt-find-attachment () 1)

;; (defun my/org-zotxt-insert-reference-link-with-ref () 1)

;; (defun org-zotxt-insert-reference-link (&optional arg)
;;  "Insert a zotero link in the `org-mode' document.

(map! :after org
      :map org-mode-map
      :localleader
      :prefix ("z" . "org-zotxt")
      "i" #'org-zotxt-insert-reference-link
      "u" #'org-zotxt-update-reference-link-at-point
      "o" #'org-zotxt-open-attachment)

;; Should this be ~after!~ something?
(setq! +biblio-pdf-library-dir (concat org-directory "/biblio/pdfs/")
       +biblio-default-bibliography-files (directory-files
                                           (concat org-directory "/biblio/bibs")
                                           t directory-files-no-dot-files-regexp)
       +biblio-notes-path (concat org-directory "/biblio/notes/"))

(after! org-roam-bibtex
  ;; Do I need this?
  (setq! orb-persp-project `("notes" . ,+biblio-notes-path)))

;;;;;;;;;;;;;;;
;; Coq stuff ;;
;;;;;;;;;;;;;;;

;; Change the color-setting from the version, wrap in 'set-face-attribute' call
;; (proof-locked-face :background ,(ewal-get-color 'background 2))


;;;;;;;;;;;;;;;;;;;;;;;;
;; Dictionaries, etc. ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Instead of doing this, could you instead just open it in the minibuffer,
;; where this is a default behavior?
;;
;; Should perhaps use the popup module for this.
;;
;; (map! ;; :after org
;;       :map wordnut-mode-map
;;       ;; :localleader
;;       ;; :prefix ("z" . "org-zotxt")
;;       "q" #'delete-window)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Email configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! mu4e
  (load! "./mu4e-config.el"))

(setq
 +mu4e-backend 'offlineimap
 mu4e-get-mail-command "offlineimap"
 mu4e-context-policy 'pick-first
 message-kill-buffer-on-exit t
 ;; should just quit when I type `q`
 mu4e-confirm-quit nil)

;; maybe also necessary to get rid of line breaks correctly?
;; TODO line breaks are still not handled correctly
;; mu4e-compose-format-flowed t)
(add-hook 'mu4e-view-mode-hook 'olivetti-mode)
(add-hook 'mu4e-compose-mode-hook
          '(lambda ()
             (visual-line-mode) ;; improved wrapping
             (olivetti-mode)
             (display-line-numbers-mode -1)
             (use-hard-newlines -1)
             (flyspell-mode))
          t)


;;;;;;;;;;;;;;;;;;;
;; Odds and ends ;;
;;;;;;;;;;;;;;;;;;;

;; A fun little thing you can do in Emacs 27. Function due to internet stranger.
(defun screenshot-svg ()
  "Save a screenshot of the current frame as an SVG image.
Saves to a temp file and puts the filename in the kill ring."
  (interactive)
  (let* ((filename (make-temp-file "Emacs" nil ".svg"))
         (data (x-export-frames nil 'svg)))
    (with-temp-file filename
      (insert data))
    (kill-new filename)
    (message filename)))
