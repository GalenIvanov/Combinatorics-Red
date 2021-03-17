Red [
    Title: "Combinatorics"
    Author: "Galen Ivanöv"
    Version: 0.1
]

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
    r: make block! n
    collect/into [
        repeat i n [ keep i ]
    ] r
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

prin "All permutations of [a b c]: "
print mold permutations [a b c]
print ["Original arrangement:" mold n-permutation [a b c] 0]
print ["Third arrangement:" mold n-permutation [a b c] 2]
print ["Last arrangemen:" mold n-permutation [a b c] 5]
print {All permutations of "abc"}
print mold permutations "abc"
