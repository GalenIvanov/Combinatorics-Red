Red [
    Title: "Combinatorics"
    Author: "Galen Ivanöv"
    Version: 0.1
]

; What's needed:
; vector dialect for more elegant and succinct presentation of the algorithms
; Combinations
; Power set


factorial: func [ 
   { Works for n up to 12 } 
    n [ integer! ]
] [
    either n < 1 [ return 1 ] [ n * factorial n - 1 ]
]

range: func [
    { Generates a list 1..n}
    n [ integer! ]
] [
    collect/into [
        repeat i n [ keep i ]
    ] make block! n
]

mixed-base: function [
    {Converts an integer to a mixed base number}
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

odometer: function [
    {Constructs a block of ranged permutations with sizes given in the input block} 
    bases [block!]
][
    p: 1
	foreach n bases [p: p * n]
	collect [repeat n p [keep/only mixed-base n - 1 bases]]
]

atomic-to-reduced: func [
    { Converts a permuatation number from atomic to REVERSED reduced representation
      It is reversed in order to avoid one additional reversal in "reduced-to-standard" function }
    n [ integer! ] 
    width [ integer! ]
] [
    collect [
        foreach base range width [
            keep n % base
            n: to integer! n / base
        ]
    ]
]

reduced-to-standard: func [
    { converts the reduced representation of a permutation to standard }
    p [ series! ] { p must be in REVERSE order }
] [
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
    { Generates the n-th permuatation of the series 
      The original series has permutation number 0 }
    block [ series! ]
    n [ integer! ]
] [
    indeces: reduced-to-standard atomic-to-reduced n length? block
    collect [
        foreach idx indeces [
            keep block/(idx + 1)
        ]
    ] 
]

permutations: func [
   { Generates all permutations of a series }
    block [ series! ]
    
] [
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
    { Calculates the binomial coefficient. a.k.a n choose k  }
    n [integer!]  "size of the set"
	k [integer!]  "size of the subset to get from n"
][
    ;f!: :factorial
	;(f! n) / ((f! k) * f! (n - k))
	p: 1
	repeat i k [p: n + 1 - i / i * p]
	to-integer p
]

prin "All permutations of [a b c]: "
print mold permutations [a b c]
print ["Original arrangement:" mold n-permutation [a b c] 0]
print ["Third arrangement:" mold n-permutation [a b c] 2]
print ["Last arrangemen:" mold n-permutation [a b c] 5]
print {All permutations of "abc"}
print mold permutations "abc"

print "nCk tests:"
print ["5 choose 2 ->" nCk 5 2]
print ["7 choose 3 ->" nCk 7 3]
print ["8 choose 4 ->" nCk 8 4]

print "Odometer test:"
foreach r odometer [2 3 4][probe r]
