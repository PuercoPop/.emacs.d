;; Check for scp, etc.
(unless (executable-find "scp")
  (error "Please install scp to continue."))

(defgroup publish nil
  "Convinience scripts for exporting my webpage files to my webserver."
  :group 'convenience
  :prefix "publish-")

(defcustom publish-personal-webpage-src-path "~/Webpage/Personal/"
  "Route where the files are on my machinec"
  :type 'string
  :group 'convenience)

(defcustom publish-webpage-dst-path "kraken:www"
  "Route where files should be on the server"
  :type 'string
  :group 'convenience)

(defun publish-personal-webpage ()
  "scp -r ~/Webpage/Personal/ kraken:www"
  (shell-command (concat "scp -r"
                         publish-webpage-src-path
                         " "
                         publish-webpage-dst-path)))
