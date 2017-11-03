

;disable all demands
(for-each (lambda(x) (psi-demand-skip x)) (psi-get-all-demands))


;enable only selected demands
(for-each psi-demand-enable selected-demands)


