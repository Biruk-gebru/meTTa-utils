;; Ordered set type definition
(: OS (-> $a Type))
(: NilOS (OS $a))
(: ConsOS (-> $a (OS $a) (OS $a)))

;; Insert an element into an ordered set
;; Takes a comparison comparator 
;;      -- comparator returns the result of the comparison in terms of symbol atoms as decribed below
;;      G -- strictly greater than, E -- equal to, L -- strictly lower than

(: OS.insert (-> (-> $a $a Atom) $a (OS $a) (OS $a)))
(= (OS.insert $comparator $x NilOS) (ConsOS $x NilOS))
(= (OS.insert $comparator $new (ConsOS $x $xs))
    
    (case ($comparator $new $x)
        ((G (ConsOS $new (ConsOS $x $xs)))
         (E (ConsOS $x $xs))
         (L (ConsOS $x (OS.insert $comparator $new $xs))))))

;; Length of an OS
(: OS.length (-> (OS $a) Number))
(= (OS.length NilOS) 0)
(= (OS.length (ConsOS $x $xs)) (+ 1 (OS.length $xs)))

;; Get by index
! (bind! INDEX_ERROR "empty set/index out of range")

;; OS.getByIndx -- get by index
(: OS.getByIdx (-> Number (OS $a) $a)) 
(= (OS.getByIdx $idx NilOS) (Error $idx INDEX_ERROR))
(= (OS.getByIdx $idx (ConsOS $x $xs)) 
    (if (== $idx 0)
        $x
        (OS.getByIdx (- $idx 1) $xs)))

;; OS.takeN -- takes N number of exemplars from the oredered set of exemplars
;; this will cull dominated exemplars from the ordered set

(: OS.takeN (-> Number (OS $a) (OS $a)))
(= (OS.takeN $n NilOS) NilOS)
(= (OS.takeN $n (ConsOS $x $xs)) 
    (if (== $n 0)
        NilOS
        (let $t (OS.takeN (- $n 1) $xs) (ConsOS $x $t))))

;; OS.contains -- check is an ordered list contains a particular element
(: OS.contains (-> (OS $a) $a Bool))
(= (OS.contains Nil $el) False)
(= (OS.contains (ConsOS $x $xs) $el)
    (if (== $x $el)
        True
        (OS.contains $xs $el)))