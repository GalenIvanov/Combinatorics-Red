Red [
    Title: "Combinatorics"
    Author: "Galen Ivanov"
    Version: 0.1
]

; What's needed:
; Faster Combinations (recursive implementation?)
; Combinations with repetition
; Variations witt repetition
; Cartesian product
; general to-base and from-base functions
; iterators for permutations and combinations
; vector dialect for more elegant and succinct presentation of the algorithms

; for inspiration: 
;https://docs.python.org/3/library/itertools.html#

; ----------------------------
; ---- Helper functions ------
; ----------------------------

range: func [
    {Generates a list 1..n}
    n [integer!]
][
    collect/into [repeat i n [keep i]] make block! n
]

product: function [
    {Calculates the product of a block of numbers}
    series [block! vector!] {A block of numbers}
][
    p: 1
    foreach n series [p: p * n]
    p
]

factorial: func [ 
   { Works for n up to 12 } 
    n [integer!]
][
    product range n
]

; Pascal's form:
; 1  1  1  1  1  1
; 1  2  3  4  5
; 1  3  6 10
; 1  4 10
; 1  5
; 1
pascals-triangle: function [
    {Creates the first n rows of the Pascal's triangle in Pascal form}
    n [integer!] {Works for n up to 34}
][
    T: make block! n
    row: make block! n
    append/dup row 1 n
    append/only T copy row
    repeat r n - 1 [
        clear head row
        left: 0
        repeat c n - r [append row left: left + T/:r/:c]
        append/only T copy row
    ]
    T    
]

replicate: function [
    {Creates a new series with each element of src replicated accordind to times} 
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

cartesian-product: function [
    {Finds the cartesian product of the input series}
    block [block!]
][
    lengths: make block! length? block
    forall block [append lengths length? block/1]
    collect [
        foreach tuple odometer lengths [
            keep/only collect [
                repeat n length? tuple [keep block/:n/(1 + tuple/:n)]
            ]
        ]
    ]
]

all-combinations: function [
    {Generates all the combinations of k items of src}
    src [series!]    
    k   [integer!] 
][
    ; Inefficient, because initially generates all 2 ** length? src masks
    masks: odometer replicate to-block 2 length? src
    reverse collect [
        foreach mask masks [
            if k = sum mask [keep/only replicate src mask]
        ]    
    ]
]

n-combination: function [
    {Finds the n-th combination of k items from src}
    src [series!]
    k   [integer!]
    n   [integer!]
][
    ; uses combinatorial number system
    ; https://en.wikipedia.org/wiki/Combinatorial_number_system
    
    comb: make block! k
    row: k + 1 ; Red uses 1-based indexing
    if n > 1 [
        until [
            col: 0
            until [pascal/:row/(col: col + 1) >= n]
            if zero? col: col - 1 [break]
            n: n - pascal/:row/:col
            insert comb src/(row + col - 1)
            row: row - 1
            zero? col
        ]
    ]    
    while [row > 1][insert comb src/(row: row - 1)]
    if string? src [comb: rejoin comb]
    comb
]

combinations: function [
    {Generates all the combinations of k items of src}
    src [series!]
    k   [integer!]
][
    size: nCk length? src k
    collect/into [
        foreach n range size [keep/only n-combination src k n]
    ] make block! size
]

reduced-to-standard: func [
    {Converts the reduced representation of a permutation to standard}
    p [series!] { p must be in REVERSE order }
][
    std: copy []
    foreach n p [
        forall std [if n <= std/1 [std/1: std/1 + 1]]
        insert std n
    ]   
    std
]

n-permutation: function [
    {Generates the n-th permuatation of the series 
      The original series has permutation number 0}
    block [series!]
    n [integer!]
][
    atomic-to-reduced: reverse mixed-base n reverse range length? block
    indeces: reduced-to-standard atomic-to-reduced
    collect [foreach idx indeces [keep block/(idx + 1)]] 
]

permutations: func [
   {Generates all permutations of a series}
    block [series!]
    
][
   str?: string? block
    n: factorial length? block
    collect/into [
        repeat i n [
            n-perm: n-permutation block i - 1
            keep/only either str? [rejoin n-perm][n-perm] 
        ]
    ] make block! n
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

nVk: function [
    {Number of variations of k items of n without repetition}
    n [integer!]
    k [integer!]
][
    ;(factorial n) / factorial n - k ; math definition
    product at range n k + 1
]

variations: function [
    {Finds all the k variations of src series}
    src [series!]
    k   [integer!]
][
    collect/into [
        foreach c combinations src k [keep permutations c]
    ] make block! nVk length? src k
]
;-----------------------
;--- Initializations ---
;-----------------------

pascal: pascals-triangle 34

;-----------------------


;prin "All permutations of [a b c]: "
;print mold permutations [a b c]
;print ["Original arrangement:" mold n-permutation [a b c] 0]
;print ["Third arrangement:" mold n-permutation [a b c] 2]
;print ["Last arrangemen:" mold n-permutation [a b c] 5]
;print {All permutations of "abcd"}
;print mold permutations "abcd"
;
;print "nCk tests:"
;print ["5 choose 2 ->" nCk 5 2]
;print ["7 choose 3 ->" nCk 7 3]
;print ["8 choose 4 ->" nCk 8 4]
;print ["20 choose 10 ->" nCk 20 10]

;print "Odometer test:"
;foreach r odometer [2 2 2][probe r]

;probe replicate [1 2 3] [3 2 1]
;probe replicate "abcd" [1 2 3 0]
;t: to-block now/date
;probe replicate t 3

;probe power-set [1 2 3]
;probe power-set "Red"  ; The empty set is now an emtpy block. Should it be an empty string for string arguments?

;probe all-combinations [1 2 3 4] 2
;probe all-combinations "abcde" 3
; The following test takes 0:01:09.08193 on my machine to complete
;t: now/precise
;all-combinations range 20 10 
;probe difference now/precise t

;t: now/precise
;combinations range 20 10  ; approximately 7 times faster than all-combinations 
;probe difference now/precise t

;probe combinations "abcdefghi" 3

;probe n-combination "abcdefghi" 5 0
;probe n-combination "abcdefghi" 5 72
;probe n-combination "abcdefghi" 5 125

;foreach n range nCk 6 3 [print [mold n-combination [1 2 3 4 5 6] 3 n]]

;print nVk 10 5
;probe variations "abcd" 3

probe cartesian-product [[1 2] [a b c] [+ -]]
