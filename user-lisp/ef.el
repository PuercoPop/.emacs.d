;; ef.el - a mud/mush/moo/m* client (eventually)

;; Emacs Lisp Archive Entry
;; Package: ef
;; Filename: ef.el
;; Version: 0.09
;; Keywords: mud, mush, client
;; Author: Vivek Dasmohapatra <vivek@etla.org>
;; Maintainer: Vivek Dasmohapatra <vivek@etla.org>
;; Created: 2004-11-10
;; Description: A mud/mush/etc client
;; URL: 
;; Compatibility: Emacs23
;; Last Updated: Wed 2004-12-08 02:28:19 +0000

;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program; if not, write to the Free Software
;;  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

;; Copyright (C) 2004 Vivek Dasmohapatra <vivek@etla.org>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; changes:
;; 0.01 - 0.05:
;; ANSI, utf-8, GA prompt support.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 0.06:
;; window size (NAWS) support (based on rudimentary telnet IAC support).
;; make all strings unibyte before sending, just in case.
;; EOR prompt support.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 0.07
;; host/port/etc not hard wired, connections to multiple worlds now possible
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 0.08
;; slice and store the incomplete-line remainder _before_ utf-8 decoding
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; elisp-dep-block >>
(require 'lui)
(require 'ansi-color);(ansi-color-apply-on-region)
;; elisp-dep-block <<

(defconst ef-version 0.08)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; protocol related gubbins:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IAC commands:
;; end of record 239 357 EF   End of Record
;; End subNeg    240 360 FO   End of option subnegotiation command.
;;                             ie end of parameter-related data, eg:
;;                             IAC WILL <OPTION> <DATA BYTES> IAC END 
;; No Operation  241 361 F1   No operation command.
;; Data Mark     242 362 F2   End of urgent data stream.
;; Break         243 363 F3   Operator pressed Break key or Attention key.
;; Int process   244 364 F4   Interrupt current process.
;; Abort output  245 365 F5   Cancel output from current process.
;; You there?    246 366 F6   Request acknowledgment.
;; Erase char    247 367 F7   Request operator erase the previous character.
;; Erase line    248 370 F8   Request operator erase the previous line.
;; Go ahead!     249 371 F9   End of input for half-duplex connections.
;; SubNegotiate  250 372 FA   Begin option subnegotiation.
;; Will Use      251 373 FB * Agreement to use the specified option.
;; Won't Use     252 374 FC * Reject the proposed option.
;; Start use     253 375 FD * Request to start using specified option.
;; Stop Use      254 376 FE * Demand to stop using specified option.
;; IAC           255 377 FF   insert ÿ (\377) literally
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 0   000 0  Binary Xmit     Allows transmission of binary data.
;; 1   001 1  Echo Data       Causes server to echo back all keystrokes.
;; 2   002 2  Reconnect       Reconnects to another TELNET host.
;; 3   003 3  Suppress GA     Disables Go Ahead! command.
;; 4   004 4  Message Sz      Conveys approximate message size.
;; 5   005 5  Opt Status      Lists status of options.
;; 6   006 6  Timing Mark     Marks a data stream position for reference.
;; 7   007 7  R/C XmtEcho     Allows remote control of terminal printers.
;; 8   010 8  Line Width      Sets output line width.
;; 9   011 9  Page Length     Sets page length in lines.
;; 10  012 A  CR Use          Determines handling of carriage returns.
;; 11  013 B  Horiz Tabs      Sets horizontal tabs.
;; 12  014 C  Hor Tab Use     Determines handling of horizontal tabs.
;; 13  015 D  FF Use          Determines handling of form feeds.
;; 14  016 E  Vert Tabs       Sets vertical tabs.
;; 15  017 F  Ver Tab Use     Determines handling of vertical tabs.
;; 16  020 10 Lf Use          Determines handling of line feeds.
;; 17  021 11 Ext ASCII       Defines extended ASCII characters.
;; 18  022 12 Logout          Allows for forced log-off.
;; 19  023 13 Byte Macro      Defines byte macros.
;; 20  024 14 Data Term       Allows subcommands for Data Entry to be sent.
;; 21  025 15 SUPDUP          Allows use of SUPDUP display protocol.
;; 22  026 16 SUPDUP Outp     Allows sending of SUPDUP output.
;; 23  027 17 Send Locate     Allows terminal location to be sent.
;; 24  030 18 Term Type       Allows exchange of terminal type information.
;; 25  031 19 End Record      Allows use of the End of record code (0xEF).
;; 26  032 1A TACACS ID       User ID exchange used to avoid more than 1 log-in
;; 27  033 1B Output Mark     Allows banner markings to be sent on output.
;; 28  034 1C Term Loc#       A numeric ID used to identify terminals.
;; 29  032 1D 3270 Regime     Allows emulation of 3270 family terminals.
;; 30  036 1E X.3 PAD         Allows use of X.3 protocol emulation.
;; 31  037 1F Window Size     Conveys window size for emulation screen.
;; 32  040 20 Term Speed      Conveys baud rate information.
;; 33  041 21 Remote Flow     Provides flow control (XON, XOFF).
;; 34  042 22 Linemode        Provides linemode bulk character transactions.
;; 255 377 FF options list    Extended options list.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar ef-iac-opt-list nil)
(put 'ef-iac-opt-list 'permanent-local t)

(defvar ef-iac-opcode-alist
  '((?\357 . ef-iac-prompt) ;; prompt precedes this
    (?\366 . ef-iac-ack   ) 
    (?\371 . ef-iac-prompt) ;; prompt precedes this
    ;;(?\372 . ef-iac-opt )
    (?\373 . ef-iac-will  ) ;; + opt
    (?\374 . ef-iac-wont  ) ;; + opt
    (?\375 . ef-iac-on    ) ;; + opt
    (?\376 . ef-iac-off   ) ;; + opt
    (?\377 . ef-iac-iac   ))
  )

(defun ef-iac-ack (opcode data pos proc)
  (if proc (process-send-string proc "\377\361"))
  (replace-match "" nil t data))

(defun ef-iac-prompt (opcode data pos proc)
  (setq ef-old-prompt ef-prompt)
  (when (string-match "\\([^\377\n]+?\\)\377[\371\357]\n?" 
                      data (max 0 (- pos 80)))
    ;;(message "new prompt '%s'" (match-string 1 data))
    (setq ef-prompt (match-string 1 data)
          data (replace-match "" nil t data)))
  data)

(defun ef-iac-will (opcode data pos proc)
  (if (string-match "..\\(.\\)" data pos)
      (progn 
        (add-to-list 'ef-iac-opt-list (string-to-char (match-string 1 data)))
        (replace-match "" nil t data))
    data))

(defun ef-iac-wont (opcode data pos proc)
  (if (string-match "..\\(.\\)" data pos)
      (progn 
        (setq ef-iac-opt-list
              (delete (string-to-char (match-string 1 data)) ef-iac-opt-list))
        (replace-match "" nil t data))
    data))

(defun ef-iac-iac (opcode data pos proc)
  (replace-match "\377" nil t data))

(defun ef-send-iac-opt (proc on option)
  (let ((cseq nil))
    (setq cseq (format "\377%c%c\377\360" (if on ?\373 ?\374) option)
          cseq (string-make-unibyte cseq))
    (process-send-string proc cseq)))

(defun ef-esc-iac (string) (replace-regexp-in-string "\377" "\377\377" string))

(defun ef-send-iac-size (proc)
  (let (window height width cseq)
    (when (and ef-output (setq window (get-buffer-window ef-output)))
      (setq width  (window-width  window)
            height (- (window-height window) 1)
            cseq   (ef-esc-iac (format "%c%c%c%c"
                                       (lsh width -8)
                                       (logand ?\xff width)
                                       (lsh height -8)
                                       (logand ?\xff height)))
            cseq (concat "\377\372\037" cseq  "\377\360"))
      (process-send-string proc (string-make-unibyte cseq)) )))

;; for now, say we'll do SIZE, reject everything else:
(defun ef-iac-on (opcode data pos proc)
  (if (string-match "..\\(.\\)" data pos)
      (let ((option (string-to-char (match-string 1 data))))
        (when proc
          (cond ((eq option ?\037)
                 (ef-send-iac-opt proc t option)
                 (ef-send-iac-size proc))
                (t
                 (ef-send-iac-opt proc nil option)) ))
        (replace-match "" nil t data))
      data))

;; for now, don't reply to requests to turn things off:
(defun ef-iac-off (opcode data pos proc)
  (if (string-match "..\\(.\\)" data pos)
      (let ((option (string-to-char (match-string 1 data))))
        ;; would respond here:
        (replace-match "" nil t data)) 
    data))

(defun ef-interpret-iac (data &optional process)
  (let ((pos nil) (opcode nil) (handler nil))
    (setq data (string-make-unibyte data))
    (while (setq pos (string-match "\377\\([\357\360-\377]\\)" data))
      (setq opcode  (string-to-char (match-string 1 data))
            handler (cdr (assq opcode ef-iac-opcode-alist)))
      ;;(message "opcpde: %d" opcode)
      (if handler
          (setq data (funcall handler opcode data pos process))
        (setq data (replace-match "" nil t data))) ))
  data)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; per-connection meta data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar ef-world nil "ef world data")
;;(make-variable-buffer-local 'ef-world)
(put 'ef-world 'permanent-local t)

(defvar ef-output nil "ef output buffer")
;;(make-variable-buffer-local 'ef-output)
(put 'ef-output 'permanent-local t)

(defvar ef-prompt nil)
;;(make-variable-buffer-local 'ef-prompt)
(put 'ef-prompt 'permanent-local t)

(defvar ef-old-prompt "")
;;(make-variable-buffer-local 'ef-old-prompt)
(put 'ef-old-prompt 'permanent-local t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; naming functions:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ef-buffer-name (world-data)
  "Return a suitable name for this ef connection\'s output buffer."
  (format "%s@%s:%d#"
          (cdr (assoc "user" world-data))
          (cdr (assoc "host" world-data))
          (cdr (assoc "port" world-data))) )

(defalias 'ef-output-buffer-name  'ef-buffer-name)
(defalias 'ef-network-buffer-name 'ef-buffer-name)

(defun ef-process-name (world-data)
  "Return a suitable process-name."
  (format "%s@%s:%d|"
          (cdr (assoc "user" world-data))
          (cdr (assoc "host" world-data))
          (cdr (assoc "port" world-data))) )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ef-process-sentinel (proc event)
  (message "P:%S %s" proc event))

(defun ef-host (world-data) "Extract host from world-data."
  (cdr (assoc "host" world-data)) )

(defun ef-port (world-data) "Extract port from world-data."
  (cdr (assoc "port" world-data)) )

(defun ef-prompt-string ()
  (if (> (length ef-prompt) 0) (concat ef-prompt " ") "input: "))

;;(defconst ef-prompt-re
;;  "^\\(\\(?:\e\\[[ ;0-9]+m\\)?.*\\(?:\e\\[[ ;0-9]+m\\)?\\)\377\371")
;;(makunbound 'ef-prompt-re)

;; (defun ef-strip-prompts (string)
;;   "Extract and interpret any prompt sequences from the server. Returns the
;; string with prompt sequences stripped out. Stores the last prompt found
;; in the variable `ef-prompt' and the original prompt in `ef-old-prompt'."
;;   ;;(message "PROMPT DATA: %S" string)
;;   (setq ef-old-prompt ef-prompt)
;;   (while (string-match ef-prompt-re string)
;;     (setq ef-prompt (match-string 1 string)
;;           string (replace-regexp-in-string ef-prompt-re "" string) ))
;;  string)
(defvar ef-prompt-op-buffer
  (let ((buf (get-buffer-create " *ef prompt*")))
    (buffer-disable-undo buf) buf))

(defun ef-replace-prompt ()
  "Replace the prompt if need be. Return t if the prompt was replaced, or did
not need to be, and nil if there was no prompt to replace."
  (let ((inhibit-read-only t) prompt)
    (if ef-prompt
        (setq prompt ef-prompt
              prompt (with-current-buffer ef-prompt-op-buffer
                       (erase-buffer) (ansi-color-apply prompt))
              prompt (if (> (length prompt) 0) prompt ":"))
      (setq prompt ":"))
    (if (equal ef-old-prompt prompt)
        nil
      (lui-set-prompt prompt) t) ))

(defvar ef-process-remainder  nil "partial lines not yet processed by ef.")
(defvar ef-current-data       nil "full line(s) currently being processed.")
(defvar ef-current-data-plain nil
  "full line(s) currently being processed, stripped of ANSI escapes:
not set until `ef-current-data-plain' is called.")
(defvar ef-input-filters     nil)
(defvar ef-output-filters    nil)
(defvar ef-debug             nil)

(defun ef-current-data-plain ()
  "Return the ANSI-escape stripped version of the current ef line(s)."
  (or ef-current-data-plain
      (setq ef-current-data-plain 
            (replace-regexp-in-string ansi-color-regexp "" ef-current-data))))

(defun ef-debug ()
  (interactive)
  (setq ef-debug (not ef-debug)))

(defun ef-post-output-filter ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max)) ))

(defun ef-process-filter (proc data)
  (let ((start nil) (end nil))

    (when ef-debug
      (with-current-buffer (get-buffer-create "*ef debug*")
        (goto-char (point-max))
        (insert data)))

    (setq data (concat ef-process-remainder data) ;; fetch leftovers from before
          data (ef-interpret-iac    data    proc));; strip/exec IAC sequences

    ;; make sure chunk is purely made of complete lines
    (if (string-match "\n\\'" data)
        (setq ef-process-remainder nil)
      (let ((offs (string-match ".*\\'" data)))
        (setq ef-process-remainder (match-string   0 data)
              data                 (substring data 0 offs)) ))

    (setq data (decode-coding-string data 'utf-8 t))
    ;; utf-8 decode

    ;; CHECK FOR TRIGGERS / USER DEFINED LINEWISE ACTION HERE?:
    (with-current-buffer (process-buffer proc)
      (let ((ef-current-data data) ef-current-data-plain)
        (run-hooks 'ef-input-filters))

      (let ((lui-insertion-delimiter ""))
        (lui-insert data))                 ;; insert only-complete-lines chunk
      (ef-replace-prompt)                  ;; update prompt
      )))

(defvar ef-known-worlds nil)

(defun ef-world-data (world-string)
  (interactive
   (list (completing-read "World: " ef-known-worlds)))
  (let ((world nil)
        (data  nil))
    (setq world (assoc world-string ef-known-worlds))
    (if world nil
      (setq ef-known-worlds
            (cons (setq world (cons world-string nil)) ef-known-worlds)) )
    ;;(message "world: %S %S" world data)
    (mapcar (lambda (ARG)
              (let ((entry nil) (value nil))
                (setq entry (assoc ARG world)
                      value (cdr entry))
                ;;(message "%S %S" current-prefix-arg entry)
                (when (or current-prefix-arg (not value))
                  (setq value (read-string (concat ARG ": "))) 
                  (if (and (stringp value) (string= "port" ARG))
                      (setq value (string-to-int value))) )
                (if entry (setcdr entry value)
                  (setq entry (cons ARG  value))
                  (setq data  (cons entry data)) )
                ;;(message "%s: %S" ARG entry)
                ))
            '("host" "port" "user"))
    (if data (setcdr world data))
    (cdr (assoc world-string ef-known-worlds)) ))

(defun ef-connect (&optional world-data)
  "Connect to the server: returns a buffer with an associated process."
  (interactive)

  (if world-data nil
    (setq world-data (completing-read "World: " ef-known-worlds)))

  (if (stringp world-data)
      (setq world-data (ef-world-data world-data)))

  (let (proc owin obuf)
    (setq obuf (get-buffer-create (ef-buffer-name world-data))
          proc (open-network-stream (ef-process-name world-data)
                                    obuf
                                    (ef-host world-data)
                                    (ef-port world-data)))
    (set-process-sentinel proc 'ef-process-sentinel)
    (set-process-filter   proc 'ef-process-filter)
    (pop-to-buffer obuf)
    (delete-other-windows)

    (make-local-variable 'ef-world)
    (make-local-variable 'ef-output)
    (make-local-variable 'ef-prompt)
    (make-local-variable 'ef-old-prompt)

    (when (fboundp 'set-process-coding-system)
      (set-process-coding-system proc 'no-conversion 'no-conversion))
    (set-buffer-file-coding-system 'utf-8)

    (delete-other-windows)
    (setq owin (selected-window) ef-output obuf)
    (set-window-buffer owin obuf)
    (set-window-dedicated-p owin t)
    (ef-mode)
    obuf))

(defun ef-send-data (string)
  (setq string (encode-coding-string string 'utf-8))
  (process-send-string (get-buffer-process (current-buffer))
                       (string-make-unibyte (concat string "\n"))) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ui functions:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar ef-mode-map 
  (let ((map (make-sparse-keymap)))
    ;; define keys here
    map))

(defun ef-complete (&optional arg)
  (dabbrev-completion))

(define-derived-mode ef-mode lui-mode "ef"
  "A MUD mode"
  :group 'ef
  (setq lui-input-function 'ef-send-line)
  (set (make-local-variable 'lui-possible-completions-function) 'ef-complete)
  (set (make-local-variable 'lui-fill-type) nil)
  (set (make-local-variable 'lui-time-stamp-position) nil)
  (add-hook 'lui-post-output-hook 'ef-post-output-filter nil t))

(defun ef-send-line (data)
  "Send the current line from the input buffer to the server. Should only be
called in the ef input buffer."
  (interactive)
  (let ((ef-current-data data) ef-current-data-plain)
    (run-hooks 'ef-output-filters))
  (lui-insert (format "\n%s %s\n" ef-prompt data))
  (ef-send-data data))

(defun ef-set-window-size (lines)
  "Set the window size to `lines' \(minimum of 1\)."
  (interactive "nbuffer size (in lines): ")
  (set-window-text-height (selected-window) (max (or lines 1) 1)))

