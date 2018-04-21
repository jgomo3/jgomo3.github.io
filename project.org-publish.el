(setq org-publish-project-alist
      '(
        ("text"
         :base-directory "~/Workspace/Personal/jgomo3.github.io/"
         :base-extension "org"
         :publishing-directory "~/Workspace/Personal/jgomo3.github.io-published/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :head-levels 4
         :auto-preamble t
         )
        ("static"
         :base-directory "~/Workspace/Personal/jgomo3.github.io/"
         :base-extension "css\\|js\\|png\\|gif\\|pdf\\|mp3\\|ogg\||swf"
         :publishing-directory "~/Workspace/Personal/jgomo3.github.io-published/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("jgomo3" :components ("text" "static"))
        )
      )
