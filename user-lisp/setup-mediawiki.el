(require 'mediawiki)
(require 'secrets)
(setq mediawiki-site-alist `(("Wikipedia" "http://en.wikipedia.org/w/"
                              ,wikipedia-login
                              ,wikipedia-password "Main Page")
                             ("Wikipedia-es" "http://es.wikipedia.org/w/"
                              ,wikipedia-login
                              ,wikipedia-password
                              "Wikipedia:Portada")
                             ("WikEmacs" "http://wikemacs.org/w/" 
                              ,wikemacs-login
                              ,wikemacs-password
                              "Main Page")))

(setq mediawiki-site-default "Wikipedia")

(provide 'setup-mediawiki)
