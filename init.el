

;; Define repos
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/packages/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; use-package still isn't installed everywhere, so check
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'user-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Define paths
(defvar my/org-dir (expand-file-name "~/Dropbox/org/")
  "Root directory for all Org files.")
(defvar my/roam-dir (expand-file-name "roam/" my/org-dir)
  "org-roam notes directory.")
(defvar my/bib-file (expand-file-name "zotero.bib" my/org-dir)
  "BibTeX file auto-exported by Zotero Better BibTeX.")
(defvar my/zotero-storage (expand-file-name "~/Zotero/storage/")
  "Zotero attachment storage directory.")
(defvar my/calibre-dir (expand-file-name "~/Calibre Library/")
  "Calibre library directory.")

;; Create directories if needed
(dolist (dir (list my/org-dir my/roam-dir))
  (unless (file-exists-p dir)
    (make-directory dir t)))

;; Some sensible defaults
(setq-default
 inhibit-startup-message t
 ring-bell-function 'ignore
 make-backup-files nil
 kill-buffer-delete-auto-save-files t
 create-lockfiles nil
 auto-save-default nil
 fill-column 80
 tab-width 4
 indent-tabs-mode nil)

;; More sensible defaults
(savehist-mode 1)
(global-auto-revert-mode 1)
(delete-selection-mode 1)
(column-number-mode 1)

;; Keyboard shortcuts recommended for org-mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Try vertico + orderless out
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; A bunch of defaults for org-mode to try out, based on the existing setup
(use-package org
  :ensure nil
  :custom
  (org-directory          my/org-dir)
  (org-default-notes-file (expand-file-name "inbox.org" my/org-dir))
  (org-agenda-files
   (seq-filter
    (lambda (f) (not (string-prefix-p my/roam-dir f)))
    (directory-files-recursively my/org-dir "\\.org$")))
  ;; GTD todo states
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

  ;; Nice log into LOGBOOK drawer
  (org-log-done            'time)
  (org-log-into-drawer     t)

  ;; Tags for contexts
  (org-tag-alist
   '(("@computer" . ?c) ("@phone" . ?p) ("@errands" . ?e)
     ("@home" . ?h) ("@office" . ?o) ("READING" . ?r)))

  ;; Refiling: allow refile up to 3 levels deep across agenda files
  (org-refile-targets     '((org-agenda-files :maxlevel . 3)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)  ; single-step via vertico

  ;; Citations backend (org-cite, built-in since Org 9.5)
  (org-cite-global-bibliography (list my/bib-file))

  :bind
  (("C-c a"   . org-agenda)
   ("C-c c"   . org-capture)
   ("C-c l"   . org-store-link)))

;; Capture templates
(with-eval-after-load 'org
  (setq org-capture-templates
        '(("t" "Task" entry
           (file+headline "inbox.org" "Tasks")
           "* TODO %?\n  %U\n  %a")

          ("n" "Note" entry
           (file+headline "inbox.org" "Notes")
           "* %?\n  %U\n  %a")

          ("r" "Reading note (book/article)" entry
           (file+headline "inbox.org" "Reading")
           "* READING %?\n  %U\n  %a"
           :empty-lines 1)

          ("j" "Journal" entry
           (file+datetree "journal.org")
           "* %U %?\n" :clock-in t :clock-resume t))))

;; org-super-agenda: groups your agenda into labelled sections
(use-package org-super-agenda
  :after org
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "Today"    :time-grid t :date today :todo "TODAY" :order 1)
          (:name "Next"     :todo "NEXT"                           :order 2)
          (:name "Waiting"  :todo "WAITING"                        :order 3)
          (:name "Reading"  :tag "READING"                         :order 4)
          (:name "Someday"  :priority<= "C"                        :order 9))))

;; Nicer Org appearance
(use-package org-modern
  :after org
  :hook (org-mode . org-modern-mode))

;; A clean, readable theme
(use-package modus-themes
  :config
  (modus-themes-load-theme 'modus-operandi))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
