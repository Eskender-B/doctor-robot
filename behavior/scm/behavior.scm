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




(ghost-parse-file "please-user.top")

(ghost-parse-file "curiosity.top")

(ghost-parse-file "stay-alive.top")



(define-public selected-demands (list (ConceptNode "GHOST: please_user") (ConceptNode "GHOST: curiosity") (ConceptNode "GHOST: stay_alive")))

(load "actions.scm")
(load "demand.scm")