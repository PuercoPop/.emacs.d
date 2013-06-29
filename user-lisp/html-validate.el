;;; html-validate.el --- HTML Validation

;; Author: Javier Olaechea <pirata@gmail.com>
;; License: GLP3

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;; ol id="error_loop
;; li class="msg_err | msg_warn"

(defgroup html-validate nil
  "Submit the current buffer for validation to w3 validator"
  :group 'convenience
  :prefix "html-validate-")

(defconst html-validate-validator-url "http://validator.w3.org/check")

(defcustom html-validate-output-buffer "*html-validate-output*"
  "Buffer name for Output"
  :type 'string
  :group 'convenience)

(defun html-validate-default-callback (response)
  "Parse response and show the output in a buffer"
  ;;libxml-parse-html-region
  
  (with-current-buffer (get-buffer-create html-validate-output-buffer)
  ;; Clear Buffer
    (erase-buffer)
    (insert response)
    (view-buffer-other-window (current-buffer))))


(defun html-validate-current-buffer ()
  (interactive)

  (let ((url-request-method "POST")
        (url-request-data (concat "fragment=" (buffer-string))))
    (url-retrieve html-validate-validator-url 'html-validate-default-callback)))

(provide 'html-validate)
;;; html-validate.el ends here
