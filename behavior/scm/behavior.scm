(use-modules
	(opencog)
	(opencog exec)
	(opencog atom-types)
	(opencog pointmem)
	(opencog nlp relex2logic)
	(opencog openpsi)
	(opencog openpsi dynamics)
	(opencog eva-behavior)
	(opencog nlp ghost))



(ghost-parse-file "topic1.scm")



; --------------------------------------------------------------

(define goal-node (ConceptNode (string-append psi-prefix-str "goal")))


(define (get-all-goals)
"
  get-all-goals - Return a list of all goal-nodes.
"
    (filter
        (lambda (x) (not (equal? x goal-node)))
        (cog-chase-link 'InheritanceLink 'ConceptNode goal-node))
)


(map 
	(lambda(goal)
		(define demand (psi-demand (cog-name goal)))
		(psi-set-demand-value demand 0.5)
	)
	(get-all-goals)
)


(define-public (update_demand demand num)

	(psi-demand-value-increase (psi-demand (cog-name demand)) (cog-execute! (TimesLink (Number (cog-name num)) (Number "100"))) )
	(List (Word ""))
)




;(Define
;  (DefinedSchema "update_demand")
;  (Lambda (ExecutionOutput (GroundedSchema "scm: update_demand") (List)))
;)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define self_happy (psi-create-emotion "self_happy"))
(define self_sad (psi-create-emotion "self_sad"))

(define user_happy (psi-create-emotion "user_happy"))
(define user_sad (psi-create-emotion "user_sad"))


(map 
	(lambda(emo)
		(psi-set-value! emo 0.5)
	)
	(psi-get-emotions)
)


(define-public (update_emotion emoWord rate)
	(define emo (primitive-eval (string->symbol (cog-name emoWord))))
	(define val (psi-get-number-value emo))
	(psi-set-value!  emo (+ val (* val (string->number (cog-name rate)))))
	(List (Word ""))

)



(define-public (emotion emoWord thresh)

	(define emo (primitive-eval (string->symbol (cog-name emoWord))))

	;(define truthValue (stv 0 1))
	
	(if (>= (psi-get-number-value emo) (string->number (cog-name thresh)))
		(stv 1 1)
		(stv 0 1)
	)


)







