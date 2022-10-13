Red [
    Title: "Combinatorics"
    Author: "Galen Ivanov"
    Version: 0.1
]

; What's needed:
; vector dialect for more elegant and succinct presentation of the algorithms
; Combinations

; from-mixed-base

; ----------------------------
; ---- Helper functions ------
; ----------------------------

factorial: func [ 
   { Works for n up to 12 } 
    n [ integer! ]
][
    either n < 1 [ return 1 ] [ n * factorial n - 1 ]
]

range: func [
    {Generates a list 1..n}
    n [ integer! ]
][
    collect/into [
        repeat i n [ keep i ]
    ] make block! n
]

product: function [
    {Calculates the product of a block of numbers}
    series [block!] {A block of numbers}
][
    p: 1
    foreach n series [p: p * n]
    p
]

replicate: function [
    {Replicates each element of src} 
    src   [series!]
    times [integer! block!] {If block! it should be the same length as src}
][
    if number? times [times: append/dup to-block times times (length? src) - 1]
    res: make block! product times
    repeat n length? src [append/dup res src/:n times/:n]
    if string? src [res: rejoin res]
    res
]

mixed-base: function [
    {Converts an integer to a block of mixed base numbers}
    n    [integer!]
    base [block!]
][
    d: make block! length? base
    foreach b reverse copy base [
        insert d n % b
        n: to-integer n / b
    ]
    d
]

; -----------------------------------------------------

odometer: function [
    {Constructs a block of ranged permutations with sizes given in the input block} 
    bases [block!]
][
    ; Currently it's 0-based
    ; Should I change it to reflect Red's 1-based indexing?
    ; That will influence power-set, where I'll need to subtract 1 from masks
    collect [repeat n product bases [keep/only mixed-base n - 1 bases]]
]

power-set: function [
    {Generates a power set of a set}
    src [series!]
][
    masks: odometer replicate to-block 2 length? src
    collect [foreach mask masks [keep/only replicate src reverse mask]]
]

atomic-to-reduced: func [
    { Converts a permuatation number from atomic to REVERSED reduced representation
      It is reversed in order to avoid one additional reversal in "reduced-to-standard" function }
    n [ integer! ] 
    width [ integer! ]
][
    collect [
        foreach base range width [
            keep n % base
            n: to integer! n / base
        ]
    ]
]

reduced-to-standard: func [
    {Converts the reduced representation of a permutation to standard}
    p [ series! ] { p must be in REVERSE order }
][
    std: copy []
    foreach n p [
        forall std [
            if n <= std/1 [std/1: std/1 + 1]
        ]
        insert std n
    ]   
    std
]

n-permutation: func [
    {Generates the n-th permuatation of the series 
      The original series has permutation number 0}
    block [ series! ]
    n [ integer! ]
][
    indeces: reduced-to-standard atomic-to-reduced n length? block
    collect [
        foreach idx indeces [
            keep block/(idx + 1)
        ]
    ] 
]

permutations: func [
   {Generates all permutations of a series}
    block [ series! ]
    
][
   str?: string? block
    n: factorial length? block
    p: make block! n
    collect/into [
        repeat i n [
            n-perm: n-permutation block i - 1
            keep/only either str?[ rejoin n-perm ] [ n-perm ] 
        ]
    ] p
    
]

nCk: function [
    {Calculates the binomial coefficient. a.k.a n choose k }
    n [integer!]  "size of the set"
    k [integer!]  "size of the subset to get from n"
][
    ;f!: :factorial
    ;(f! n) / ((f! k) * f! (n - k))
    p: 1
    repeat i k [p: n + 1 - i / i * p]
    to-integer p
]

;prin "All permutations of [a b c]: "
;print mold permutations [a b c]
;print ["Original arrangement:" mold n-permutation [a b c] 0]
;print ["Third arrangement:" mold n-permutation [a b c] 2]
;print ["Last arrangemen:" mold n-permutation [a b c] 5]
;print {All permutations of "abc"}
;print mold permutations "abc"
;
;print "nCk tests:"
;print ["5 choose 2 ->" nCk 5 2]
;print ["7 choose 3 ->" nCk 7 3]
;print ["8 choose 4 ->" nCk 8 4]

;print "Odometer test:"
;foreach r odometer [2 3 4][probe r]

;probe replicate [1 2 3] [3 2 1]
;probe replicate "abcd" [1 2 3 0]
;t: to-block now/date
;probe replicate t 3

probe power-set [1 2 3]
probe power-set "Red"  ; The empty set is now an emtpy block. Should it be an empty string for string arguments?
