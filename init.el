;; Save history between sessions
(savehist-mode 1)

;; Disable all backups, autosaves, and lockfiles
(setf make-backup-files nil)
(setf kill-buffer-delete-auto-save-files t)
(setq create-lockfiles nil)


;; Keyboard shortcuts recommended for org-mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
