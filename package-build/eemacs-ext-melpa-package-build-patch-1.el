(defun __adv/around/package-build--run-process/ignore-invalid-submodule-operation
    (orig-func &rest orig-args)
  (let* (
         ;; orig args parsing
         (directory (car orig-args))
         (destination (cadr orig-args))
         (command (caddr orig-args))
         (rest-args (cdddr orig-args))

         ;; Show debug information
         ;; (debug-on-error t)
         ;; (print-level nil)
         ;; (print-length nil)
         ;; (edebug-print-level nil)
         ;; (edebug-print-length nil)

         ;; patch needed variable declarations
         (directory-fname
          (when (stringp directory)
            (save-match-data
              (replace-regexp-in-string
               "/$" ""
               directory))))
         (working-dir-name
          (when directory-fname
            (file-name-nondirectory directory-fname)))
         (git-submodule-operation-p
          (ignore-errors (string= (car rest-args) "submodule"))))
    (if (or
         ;; Ignore git submodule operation on 'emacs-request' recipe
         ;; since its submodule is not an valid url i.e. its author's
         ;; own repo in his local filesystem.
         (and (ignore-errors (string= working-dir-name "request"))
              git-submodule-operation-p)
         ;; TODO: add more conditions
         )
        (prog1
            ;; return the success return so that the next procedure
            ;; working correctly
            t
          (warn "Ignore submodule operation on working tree '%s'"
                directory))
      ;; call `orig-func' otherwise
      (apply orig-func orig-args))))

(advice-add 'package-build--run-process
            :around
            #'__adv/around/package-build--run-process/ignore-invalid-submodule-operation
            )

(provide 'eemacs-ext-melpa-package-build-patch-1)
