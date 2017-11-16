(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'load-path "~/.emacs.d/lisp")

; Uncomment following line if you want to indicate the 80th character column
(require 'fill-column-indicator)

;; define behaviour for home and end keys
;(global-set-key [home] 'beginning-of-line)
;(global-set-key [end] 'end-of-line)

; style I want to use in c++ mode
(c-add-style "my-c++-style" 
	          '("stroustrup"
		    (indent-tabs-mode . nil)        ; use spaces rather than tabs
		    (setq-default fill-column 80)  ; set 80 characters as the length of each line
		    (c-basic-offset . 4)            ; indent by four spaces
		    (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
					(brace-list-open . 4)
					(statement-case-open . +)))))

(defun my-c++-mode-hook ()
  (c-set-style "my-c++-style")        ; use my-style defined above
  (auto-fill-mode)
  (hs-minor-mode)                     ; for code collapsing
  (c-toggle-auto-hungry-state 1))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c++-mode-hook 'fci-mode)

;; enable modes by default
;;(xterm-mouse-mode t)
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
;; Enable ido-mode by default
(setq ido-enable-flex-matching t) ; Allows for flex matching on word initials
(setq ido-everywhere t) ; set ido-everywhere true so that ido used in buffers/files
(ido-mode 1)


;;; Finding stuff using vc-git-grep
;;;Better git grep (from https://www.ogre.com/node/447)
(defun git-grep-prompt ()
  (let* ((default (current-word))
	 (prompt (if default
		     (concat "Search for: (default " default ") ")
		   "Search for: "))
	 (search (read-from-minibuffer prompt nil nil nil nil default)))
    (if (> (length search) 0)
	search
      (or default ""))))

(defun git-grep-repo (search)
  "git-grep the entire current repo"
  (interactive (list (git-grep-prompt)))
  (grep-find (concat "git --no-pager grep -P -n "
		     (shell-quote-argument search)
		     " `git rev-parse --show-toplevel`")))

;; Use hippie-expand for expand key
(global-set-key (kbd "M-/") 'hippie-expand)

;;; 3b - Hippie expand
(setq hippie-expand-try-functions-list '(try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-line try-complete-lisp-symbol-partially try-complete-lisp-symbol))

;; Map this to f3 for easy access
(global-set-key (kbd "<f3>") 'git-grep-repo)

;; easy keys for split windows
(global-set-key (kbd "M-1") 'delete-other-windows) ; 【Alt+3】 unsplit all
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)
(global-set-key (kbd "M-RET") 'other-window) ; 【Alt+Return】 move cursor to next pane
(global-set-key (kbd "M-0") 'delete-window)  ; remove current pane

;; easy key for block hiding
(global-set-key (kbd "C-c c") 'hs-toggle-hiding)

;; enable home and end keys
(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end] 'move-end-of-line)

;; to switch between most recent buffers
(global-set-key (kbd "M-t") 'mode-line-other-buffer)

;; to list all open buffers in emacs
(global-set-key (kbd "M-b") 'list-buffers)

;; jumping between header and source
;;; This is specific to the repo structure for engine team work
;;; It helps ff-find-other-file be able to jump to the correct header/src
;;; inside the video_analysis libraries
;;(setq ff-always-in-other-window t)
(setq cc-search-directories '("."
			      "../src/"
			      "../include/"
			      "../include/*/*"
			      "../../src/"
			      "../../src/*/*"
			      "../../include/*/*"
			      "../../../src/*/*"))
(global-set-key (kbd "C-c f") 'ff-find-other-file)
