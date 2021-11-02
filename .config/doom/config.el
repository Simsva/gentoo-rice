;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Simon Ericsson"
      user-mail-address "simon@krlsg.se")

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

(after! ccls
  (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
  (set-lsp-priority! 'ccls 2)) ; optional as ccls is the default in Doom

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (substitute-in-file-name "$XDG_DOCUMENTS_DIR/org/"))
(setq org-hide-emphasis-markers :true)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Change font
(setq doom-font (font-spec :family "Iosevka Simsva" :size 14)
      ;;doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "JoyPixels" :size 12)
      doom-big-font (font-spec :family "Iosevka Simsva" :size 19))

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

;; Project directories
(defun count-slash (path) (interactive) (seq-count (lambda (x) (char-equal x ?/)) path))
(setq dev-dir-depth (count-slash (substitute-in-file-name "$SHORTCUT_DIR_DEV")))
(setq dev-dirs
      (seq-filter
       (lambda (x)
         (let ((depth (- (count-slash x) dev-dir-depth)))
           (and (>= depth 1) (<= depth 1))))
       (directory-files-recursively (substitute-in-file-name "$SHORTCUT_DIR_DEV") "." t)))

(setq projectile-project-search-path dev-dirs)
(push (substitute-in-file-name "$SHORTCUT_DIR_SRC") projectile-project-search-path)
(push (substitute-in-file-name "$HOME") projectile-project-search-path)
