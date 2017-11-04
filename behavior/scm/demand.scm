
;assign value 0.5 to each demand
(for-each (lambda(x) (psi-set-demand-value x 0.5)) (psi-get-all-enabled-demands))

;disable all demands
(for-each (lambda(x) (psi-demand-skip x)) (psi-get-all-demands))


;enable only selected demands
(for-each psi-demand-enable selected-demands)


(define (find-minimum demands)
	(if (null? (cdr demands))
		(car demands)
		(find-minimum 
			(if (> (psi-get-number-value (car demands)) (psi-get-number-value (cadr demands)))
				(cdr demands)
				(append (list (car demands))  (cddr demands) )
			)
		)

	)
)


(define (weight-fn demand)
	(tv-mean (cog-tv demand))
)

(define (sort-by-weight demand-list WEIGHT-FN)

    (sort demand-list (lambda (RA RB)
        (< (WEIGHT-FN RA) (WEIGHT-FN RB))))
)




;enable the least satisfied demand first
;(define current-demand (find-minimum selected-demands))
;(psi-demand-enable current-demand)

;(define demand-node (list-ref (cog-chase-link 'InheritanceLink 'ConceptNode (list-ref (psi-get-all-enabled-demands) 0)) 0))

(define prev-count (psi-get-loop-count))

;Arrange order of demands with least satisfied demand first
;NEED TO FIX: psi-demand-cache should not be accessible here
(set! psi-demand-cache (sort-by-weight (psi-get-all-enabled-demands) weight-fn))

(define (update-demands)

	(define (select-rule demands)

		(define rules (psi-select-rules-per-demand (car demands)))


		(if (not (null? rules)) 

			(list (car rules) (car demands))

			(if (not (null? (cdr demands)))
				(select-rule (cdr demands))
				(list)
			)
		)
	)


	(if (not (= prev-count (psi-get-loop-count)))
		(let ((rule-demand (select-rule (psi-get-all-enabled-demands))))

			
			(if (not (null? rule-demand))
				(begin
					(display (psi-get-loop-count))
					;(display (cadr rule-demand))
					(set! prev-count (psi-get-loop-count))
					(psi-demand-value-increase (cadr rule-demand) (Number (* (tv-mean (cog-tv (car rule-demand))) 10)))

					;Arrange order of demands with least satisfied demand first
					;NEED TO FIX: psi-demand-cache should not be accessible here
					(set! psi-demand-cache (sort-by-weight (psi-get-all-enabled-demands) weight-fn))
				)
			)
		)
	)

(stv 1 1)


)


(DefineLink
	(DefinedPredicateNode "update-demands")
	(EvaluationLink
		(GroundedPredicateNode "scm: update-demands") 
		(List)
	)
)



;Set demand updater for each chat demand
;NEED TO FIX: there is redundancy in setting the same demand updater three times (Need to come up with a better way)
;NEED TO FIX: One demand updater can update each chat demand (should not be like this)

(for-each
	(lambda(x)
		(psi-set-updater! (DefinedPredicateNode "update-demands") x)
	) selected-demands
)