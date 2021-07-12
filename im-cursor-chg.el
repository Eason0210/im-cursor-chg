;;; im-cursor-chg.el --- Change cursor color for input method  -*- lexical-binding: t; -*-

;; Inspired by code from pyim and cursor-chg
;; URL: https://github.com/tumashu/pyim/blob/master/pyim-indicator.el
;; URL: https://github.com/emacsmirror/cursor-chg/blob/master/cursor-chg.el

;;; Commentary:
;;
;; To turn on the cursor color change by default,
;; put the following in your Emacs init file.
;;
;; (require 'im-cursor-chg)
;; (im-start-daemon)
;;
;;; Code:

(require 'rime nil t)

(defvar im-cursor-color "Orange"
  "The color for input method.")

(defvar im-default-cursor-color nil
  "The default cursor color.")

(defvar im-timer nil
  "The timer for `im-start-daemon'.")

(defvar im-timer-repeat 0.4)

(defun im--chinese-p ()
  "Check if the current input method is Chinese."
  (if (featurep 'rime)
      (and (rime--should-enable-p)
           (not (rime--should-inline-ascii-p))
           current-input-method)
    current-input-method))

(defun im--daemon-function ()
  "Set cursor color depending on whether an input method is used or not."
  (set-cursor-color (if (im--chinese-p)
                        im-cursor-color
                      im-default-cursor-color)))

(defun im-start-daemon ()
  "Start im-daemon, for update current input method status in real time."
  (interactive)
  (unless im-default-cursor-color
    (setq im-default-cursor-color
          (frame-parameter nil 'cursor-color)))
  (unless (timerp im-timer)
    (setq im-timer
          (run-with-timer
           nil im-timer-repeat
           #'im--daemon-function))))

(defun im-revert-cursor-color ()
  "Reset cursor color to the default color."
  (when im-default-cursor-color
    (set-cursor-color im-default-cursor-color)))

(defun im-stop-daemon ()
  "Stop im-daemon."
  (interactive)
  (when (timerp im-timer)
    (cancel-timer im-timer)
    (setq im-timer nil))
  (im-revert-cursor-color))


(provide 'im-cursor-chg)
;;; im-cursor-chg.el ends here
