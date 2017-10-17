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
	(ConceptNode "") 
)


(DefineLink
	(DefinedSchemaNode "update_demand")
	(LambdaLink
	(VariableList
		(VariableNode "$X")
		(VariableNode "$Y")
	)
		(ExecutionOutputLink
			(GroundedSchemaNode "scm: update_demand")
			(ListLink
				(VariableNode "$X")
				(VariableNode "$Y")
			)
		)
	)
)

;(Define
;  (DefinedSchema "update_demand")
;  (Lambda (ExecutionOutput (GroundedSchema "scm: update_demand") (List)))
;)







