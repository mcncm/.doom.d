;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

(package! ewal-doom-themes)
(package! olivetti)
(package! org-variable-pitch)
(package! org-superstar)
(package! org-pretty-tags)
(package! org-wild-notifier)
;; (package! org-roam-server)  ;; disabled for lack of use
;; (package! anki-editor)   ;; disabled for lack of use
;; (package! fira-code-mode)  ;; seems to not play nicely
                              ;; with ligatures module
(package! ivy-bibtex)
;; (package! zotxt)   ;; disabled for lack of use
(package! mu4e-alert)
(package! nov)
(package! google-translate)

;; It seems that these themes aren’t Doom-compatible.
;; (package! modus-vivendi-theme)
;; (package! modus-operandi-theme)
;; (package! poet-theme)

;; snippets: use the default snippets instead of the D
;; (package! doom-snippets :ignore t)
;; (package! yasnippet-snippets)

;; lsp-julia must be manually installed; is not included with the Julia
;; +lsp flag
(package! lsp-julia
  :recipe (:host github :repo "non-jedi/lsp-julia"))

;; ;; The `package!` macro might not be the "correct" way to do this, since it's
;; ;; meant for handling downloading, but this does seem to work well enough for
;; ;; now.
;; (package! cavy-mode
;;   :recipe (:local-repo ))

(use-package "~/proj/cavy/cavy-mode")

;; NOTE for the time being, emacs-jupyter has a bad interaction with native
;; comp. See the Github issue at:
;; https://github.com/nnicandro/emacs-jupyter/issues/297
;; NOTE This is *extra* broken right now
;; (package! jupyter :recipe (:no-native-compile t))

;; (package! ob-async :recipe (:no-native-compile t))
