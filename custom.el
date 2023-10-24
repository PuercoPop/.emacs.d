(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Man-notify-method 'pushy)
 '(ansi-color-names-vector
   ["#000000" "#8b0000" "#00ff00" "#ffa500" "#7b68ee" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(auth-sources '("~/.authinfo.gpg" "~/.authinfo" "secrets:Login"))
 '(auto-revert-avoid-polling t)
 '(bookmark-save-flag 1)
 '(browse-at-remote-remote-type-regexps
   '(("^github\\.com$" . "github")
     ("^bitbucket\\.org$" . "bitbucket")
     ("^gitlab\\.com$" . "gitlab")
     ("^git\\.savannah\\.gnu\\.org$" . "gnu")
     ("^gist\\.github\\.com$" . "gist")
     ("^git\\.sr\\.ht$" . "sourcehut")
     ("^.*\\.visualstudio\\.com$" . "ado")
     ("^pagure\\.io$" . "pagure")
     ("^.*\\.fedoraproject\\.org$" . "pagure")
     ("^.*\\.googlesource\\.com$" . "gitiles")
     ("^gitlab\\.housecalldev\\.com$" . "gitlab")))
 '(c-default-style
   '((c-mode . "bsd")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "gnu")))
 '(cider-repl-history-file "~/.emacs.d/cider-repl-history")
 '(comment-auto-fill-only-comments t)
 '(custom-safe-themes
   '("835d934a930142d408a50b27ed371ba3a9c5a30286297743b0d488e94b225c5f" "a7b63ed697a816576d1af651f3668e1f12e6ac3f4d9c905a136b29c8d9026707" "ce409d3a932171747b7b8b7edafdc70b4614beb31a7204aa25517d7c0ab80c48" "0e44755893f9ff825802c493cded385b1839165c4f094bad72a95125236a5797" "a53f00556ab4c81a0618ab6589053d9e351312d37d9c9cf544e0c8edac2b63ab" "8f1eab02c66e5ed476d60a018ffa32ca181fea4be1ee0a5e197b2d7026608a58" "6fc5c5d388fb99737bdeee3aac74e660b4cf2ef39d6354cdbf1e7c8e475a224e" "47772b7cb9a4d978fa72eb1e895b0d84ecfc0baa670ab539e64c43135eeec79c" "90a6936b8c8f709825a0165928ef95f24f79486805be787630e7fe46bc5c9c7f" "02f30097c5840767499ed2f76d978545f6fb3a1c3ba59274576f7e23fc39d30b" "3a496bf8eafa4dfe4db359b964f559066aafb516898f63fdf450188133112c7b" "b69d8a1a142cde4bbde2f940ac59d2148e987cd235d13d6c4f412934978da8ab" "24b666119df8d11b6509d15cbb9f986bcdc06e9ecacab65b7ba0999304eeff26" "f7fed1aadf1967523c120c4c82ea48442a51ac65074ba544a5aefc5af490893b" "a7b20039f50e839626f8d6aa96df62afebb56a5bbd1192f557cb2efb5fcfb662" "1bddd01e6851f5c4336f7d16c56934513d41cc3d0233863760d1798e74809b4b" "4968afbbd6ec46b3fadd5501f9bec3073cb1d76e331838ab024b24459d4bee7a" "998975856274957564b0ab8f4219300bca12a0f553d41c1438bbca065f298a29" "cbdf8c2e1b2b5c15b34ddb5063f1b21514c7169ff20e081d39cf57ffee89bc1e" "850bb46cc41d8a28669f78b98db04a46053eca663db71a001b40288a9b36796c" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "3c2f28c6ba2ad7373ea4c43f28fcf2eed14818ec9f0659b1c97d4e89c99e091e" "6c9cbcdfd0e373dc30197c5059f79c25c07035ff5d0cc42aa045614d3919dab4" "afd761c9b0f52ac19764b99d7a4d871fc329f7392dfc6cd29710e8209c691477" "edb73be436e0643727f15ebee8ad107e899ea60a3a70020dfa68ae00b0349a87" "d6603a129c32b716b3d3541fc0b6bfe83d0e07f1954ee64517aa62c9405a3441" "387b487737860e18cbb92d83a42616a67c1edfd0664d521940e7fbf049c315ae" "23c0dc923626f1186edf9ed406dad5358477434d635ea90012e93863531a97b3" "b89a4f5916c29a235d0600ad5a0849b1c50fab16c2c518e1d98f0412367e7f97" "3433a30aa4ecd3ba38314cec0b473b8a55ec00d43c1b700a0caeef1b5ac3bc19" "5afcf29b3d73c0959c772321f98735ccb99cca2cf054279202f7568a67828c6c" "9fe1200e682dec8d27d8bf8b0e1b3398a9d39ec1d2e66409217df7fc6ed9faf5" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "8f567db503a0d27202804f2ee51b4cd409eab5c4374f57640317b8fcbbd3e466" "7ea491e912d419e6d4be9a339876293fff5c8d13f6e84e9f75388063b5f794d6" "44710d6bb6f6acb25bc5bf4fcf146842def90197c4e7fd2d2e7143f5613a565a" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "4f01c1df1d203787560a67c1b295423174fd49934deb5e6789abd1e61dba9552" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "fc6697788f00629cd01f4d2cc23f1994d08edb3535e4c0facef6b7247b41f5c7" "df01ad8d956b9ea15ca75adbb012f99d2470f33c7b383a8be65697239086672e" "27a1dd6378f3782a593cc83e108a35c2b93e5ecc3bd9057313e1d88462701fcd" "0feb7052df6cfc1733c1087d3876c26c66410e5f1337b039be44cb406b6187c6" "347f47b3da854bce47e95497bf2df2e313d1cf934adc88af8393a0e3d1b5133e" "5a45c8bf60607dfa077b3e23edfb8df0f37c4759356682adf7ab762ba6b10600" "493175b253b66b5701c6f5cf698b3e32f4f5c2f22fd4c8c50d3c1551f4e50824" "79b6be0f84d3beb977d67ed477b6f876799bdf928370ce2d45d5eb87e9666097" "3cd67549af81cb8bc8b1776704a934fd18ec2bfca5c8d8991ce73e084e43c079" "f0c5c2442612f1f78addc14de77d926923017f475b3e20cdea24ddd83cae76d1" "eb3647d80c027d18acb63e9b4d17d2fe2f2fdd1068ed5a93ff372de1df328e3b" "ae65ccecdcc9eb29ec29172e1bfb6cadbe68108e1c0334f3ae52414097c501d2" "9e816bc85b64963710efdbc57db8545b53f7f359b0736e0b36fbc9efe07f12f4" "040df59d43e528ce7531ed61a6d8e6153aebd4256726d713750a9fb6caef7c62" "ddae0fabfc732be9a6c9e7a6c580f1fc1c69351d7b86e076584890d22808ecce" "7675ffd2f5cb01a7aab53bcdd702fa019b56c764900f2eea0f74ccfc8e854386" "53ee66b48df4b74afdbf5a977495c2bef301e5ab3734baa49009d841e12a4222" "ab400f1c5bcf72ce30e1d865cbae74a6931bff781d757c44449139d5b09a6c14" "7beac4a68f03662b083c9c2d4f1d7f8e4be2b3d4b0d904350a9edf3cf7ce3d7f" "39fe48be738ea23b0295cdf17c99054bb439a7d830248d7e6493c2110bfed6f8" "bffb799032a7404b33e431e6a1c46dc0ca62f54fdd20744a35a57c3f78586646" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" "0f5cebcafc8463d1abc52917c7060499ce0c037989ae635c493945db3e5c0dda" "03cc0972581c0f4c8ba3c10452cb6d52a9f16123df414b917e06445c5fdbe255" "237e7639d42e804946883554bf662f333a41d18382ddd6fc19336612cc05ce89" "2d835b43e2614762893dc40cbf220482d617d3d4e2c35f7100ca697f1a388a0e" "0bff60fb779498e69ea705825a2ca1a5497a4fccef93bf3275705c2d27528f2f" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" "e8825f26af32403c5ad8bc983f8610a4a4786eb55e3a363fa9acb48e0677fe7e" "33af2d5cb040182b798c3a4ee6d16210e700a2fabaa409231e1c4a003cafd1c2" "b055150f79035245ae2a0d22d75eed138343223604e83c9d3babad28c9268589" "801a567c87755fe65d0484cb2bded31a4c5bb24fd1fe0ed11e6c02254017acb2" "341b2570a9bbfc1817074e3fad96a7eff06a75d8e2362c76a2c348d0e0877f31" "732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" "85d1dbf2fc0e5d30f236712b831fb24faf6052f3114964fdeadede8e1b329832" "6bc387a588201caf31151205e4e468f382ecc0b888bac98b2b525006f7cb3307" "7824eb15543c5c57c232c131ca64c4f25bfeeeda6744f71b999787a9172fa74e" "b44f201f67425ece29e34972be12917189cac2bac90e3e35d3160bce211d3199" "30289fa8d502f71a392f40a0941a83842152a68c54ad69e0638ef52f04777a4c" "2296db63b1de14e65390d0ded8e2b5df4b9e4186f3251af56807026542a58201" "13d20048c12826c7ea636fbe513d6f24c0d43709a761052adbca052708798ce3" "14c848e2c4a0a11fcd118e2519078aa50bb6020f89035423b40fff421fb24fbd" "26d49386a2036df7ccbe802a06a759031e4455f07bda559dcf221f53e8850e69" default))
 '(dired-isearch-filenames 'dwim)
 '(emacs-lisp-docstring-fill-column 80)
 '(exotica-theme-enable-italics t)
 '(exwm-floating-border-color "#292F37")
 '(eyebrowse-keymap-prefix "\30rw" t)
 '(fci-rule-color "#383838")
 '(fill-column 80)
 '(forge-alist
   '(("github.com" "api.github.com" "github.com" forge-github-repository)
     ("gitlab.com" "gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository)
     ("salsa.debian.org" "salsa.debian.org/api/v4" "salsa.debian.org" forge-gitlab-repository)
     ("framagit.org" "framagit.org/api/v4" "framagit.org" forge-gitlab-repository)
     ("gitlab.gnome.org" "gitlab.gnome.org/api/v4" "gitlab.gnome.org" forge-gitlab-repository)
     ("codeberg.org" "codeberg.org/api/v1" "codeberg.org" forge-gitea-repository)
     ("code.orgmode.org" "code.orgmode.org/api/v1" "code.orgmode.org" forge-gogs-repository)
     ("bitbucket.org" "api.bitbucket.org/2.0" "bitbucket.org" forge-bitbucket-repository)
     ("git.savannah.gnu.org" nil "git.savannah.gnu.org" forge-cgit**-repository)
     ("git.kernel.org" nil "git.kernel.org" forge-cgit-repository)
     ("repo.or.cz" nil "repo.or.cz" forge-repoorcz-repository)
     ("git.suckless.org" nil "git.suckless.org" forge-stagit-repository)
     ("git.sr.ht" nil "git.sr.ht" forge-srht-repository)
     ("gitlab.housecalldev.com" "gitlab.housecalldev.com/api/v4" "gitlab-housecalldev" forge-gitlab-repository)))
 '(global-undo-tree-mode t)
 '(gofmt-command "goimports")
 '(highlight-tail-colors ((("#29323c" "#1f2921") . 0) (("#2c3242" "#212928") . 20)))
 '(history-delete-duplicates t)
 '(imenu-auto-rescan t)
 '(jdee-db-active-breakpoint-face-colors (cons "#100E23" "#906CFF"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#100E23" "#95FFA4"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#100E23" "#565575"))
 '(jira-url "housecall.atlassian.net")
 '(kubectl-kubectl
   "/opt/rancher-desktop/resources/resources/linux/bin/kubectl")
 '(kubel-use-namespace-list 'on)
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(mastodon-active-user "PuercoPop")
 '(objed-cursor-color "#FF8080")
 '(org-drill-done-count-color "#663311")
 '(org-drill-failed-count-color "#880000")
 '(org-drill-mature-count-color "#005500")
 '(org-drill-new-count-color "#004488")
 '(org-edit-src-content-indentation 0)
 '(org-goto-interface 'outline-path-completion)
 '(org-goto-max-level 3)
 '(pdf-view-midnight-colors (cons "#CBE3E7" "#1E1C31"))
 '(proced-auto-update-flag t)
 '(rcirc-default-full-name "PuercoPop")
 '(rcirc-default-nick "PuercoPop")
 '(rcirc-log-directory nil)
 '(rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY" "MODE"))
 '(rcirc-server-alist
   '(("irc.oftc.net" :nick "PuercoPop" :user-name "PuercoPop" :channels
      ("#wayland" "#freedesktop" "#cat-v" "#pipewire" "#bcache")
      :encryption tls :port "6697")
     ("irc.libera.chat" :nick "PuercoPop" :user-name "PuercoPop" :channels
      ("#go-nuts" "#stumpwm" "#sbcl" "#emacs" "#podman" "#postgresql" "#c++" "#nixos" "#guix" "#commonlisp")
      :encryption tls :port "6697")))
 '(rcirc-track-minor-mode t)
 '(recentf-max-saved-items 50)
 '(ruby-align-chained-calls t)
 '(ruby-insert-encoding-magic-comment nil)
 '(rustic-ansi-faces
   ["#1E1C31" "#FF8080" "#95FFA4" "#FFE9AA" "#91DDFF" "#C991E1" "#AAFFE4" "#CBE3E7"])
 '(safe-local-variable-values
   '((eval add-hook 'eglot-managed-mode-hook
           (lambda nil
             (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
     (eglot-server-programs
      (ruby-mode "ruby-lsp"))
     (vc-prepare-patches-separately)
     (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w")
     (magit-todos-exclude-globs)
     (rspec-docker-file-name . "/home/puercopop/hcp/decision-engine/docker-compose.yml")
     (rspec-docker-container . "audiencies-api")
     (rspec-use-docker-when-possible . t)
     (rspec-use-chruby)
     (eval when
           (fboundp 'rainbow-mode)
           (rainbow-mode 1))
     (git-commit-major-mode . git-commit-elisp-text-mode)
     (Package . CCL)
     (eval progn
           (org-babel-goto-named-src-block "startup")
           (org-babel-execute-src-block)
           (outline-hide-sublevels 1))
     (Package . CLX-EXTENSIONS)
     (Package . GBBOPEN-TOOLS)
     (Package . TUTORIAL)
     (Syntax . common-lisp)
     (Package . COMMON-LISP-USER)
     (Lowercase . YES)
     (Syntax . COMMON-LISP)
     (Package . LISP-UNIT)
     (mangle-whitespace . t)
     (sql-product quote mysql)
     (Package . SYSTEM)
     (Package . CLOS)
     (Syntax . Common-Lisp)
     (Log . clx.log)
     (Package . Xlib)
     (Lowercase . Yes)
     (Base . 10)
     (Package . XLIB)
     (Syntax . Common-lisp)
     (eval font-lock-add-keywords nil
           `((,(concat "("
                       (regexp-opt
                        '("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl")
                        t)
                       "\\_>")
              1 'font-lock-variable-name-face)))
     (whitespace-line-column . 80)))
 '(save-abbrevs 'silently)
 '(sentence-end-double-space t)
 '(switch-to-buffer-in-dedicated-window 'pop)
 '(switch-to-buffer-obey-display-actions t)
 '(tab-bar-new-tab-choice 'bookmark-bmenu-get-buffer)
 '(tab-bar-tab-name-function 'tab-bar-tab-name-truncated)
 '(undo-tree-auto-save-history nil)
 '(use-short-answers t)
 '(vc-annotate-background "#1E1C31")
 '(vc-annotate-color-map
   (list
    (cons 20 "#95FFA4")
    (cons 40 "#b8f7a6")
    (cons 60 "#dbf0a8")
    (cons 80 "#FFE9AA")
    (cons 100 "#ffd799")
    (cons 120 "#ffc488")
    (cons 140 "#FFB378")
    (cons 160 "#eda79b")
    (cons 180 "#db9cbd")
    (cons 200 "#C991E1")
    (cons 220 "#db8bc0")
    (cons 240 "#ed85a0")
    (cons 260 "#FF8080")
    (cons 280 "#d4757d")
    (cons 300 "#aa6a7a")
    (cons 320 "#805f77")
    (cons 340 "#858FA5")
    (cons 360 "#858FA5")))
 '(vc-annotate-very-old-color nil)
 '(vterm-clear-scrollback-when-clearing t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(forge-topic-closed ((t (:inherit magit-dimmed :strike-through t)))))
