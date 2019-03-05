﻿(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?l1 - location1 ?l2 - location2 ?r - robot)
      :precondition (and (and (no-robot ?l2) (at ?r ?l1)) (or (connected ?l1 ?l2) (connected ?l2 ?l1)))
      :effect (and (and (at ?r ?l2) (no-robot ?l1)) (and (not (at ?r ?l1)) (not (no-robot ?l2))))
   )
   
   (:action robotMoveWithPallette
      :parameters (?l1 - location1 ?l2 - location2 ?r - robot ?p - pallette)
      :precondition (and (and (and (no-robot ?l2) (at ?r ?l1)) (or (connected ?l1 ?l2) (connected ?l2 ?l1))) (and (at ?p ?l1) (no-pallette ?l2)))
      :effect (and (and (and (at ?r ?l2) (no-robot ?l1)) (and (not (at ?r ?l1)) (not (no-robot ?l2)))) (and (and (at ?p ?l2) (no-pallette ?l1)) (and (not (at ?p ?l1)) (not (no-pallette ?l2)))))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (and (and (at ?p l) (contains ?p ?si)) (and (ships ?s ?o) (orders ?o ?si))) (packing-at ?s ?l))
      :effect (and (contains ?s ?si) (not (contains ?p ?si)))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (packing-at ?s ?l) (started ?s) (ships ?s ?o) (not (complete ?s)))
      :effect (and (and (available ?l) (complete ?s)) (not (packing-at ?s ?l)))
   )
)