Red [
    Title: "Combinatorics tests"
    Author: "Galen Ivanov"
]

#include %combinatorics.red

print "Odometer test:^/"
foreach r odometer [2 3 4][probe r]

print [newline "Power set:" newline]
probe power-set [1 2 3 4]
probe power-set "Red"  ; The empty set is an empty block. Should it be an empty string?

print [newline "Cartesian product:" newline]
probe cartesian-product [[a b c] [* -] [3 2]]

print [newline "nCk tests:" newline ]
print ["5 choose 2 ->" nCk 5 2]
print ["7 choose 3 ->" nCk 7 3]
print ["8 choose 4 ->" nCk 8 4]
print ["20 choose 10 ->" nCk 20 10]

print [newline "N-th combination:" newline]
probe n-combination "abcdefghi" 5 0
probe n-combination "abcdefghi" 5 72
probe n-combination "abcdefghi" 5 125

print [newline "Combinations:" newline]

;probe all-combinations [1 2 3 4] 2
;probe all-combinations "abcde" 3
;The following test takes 0:01:09.08193 on my machine to complete
;t: now/precise
;all-combinations range 20 10 
;probe difference now/precise t

;t: now/precise
;combinations range 20 10  ; approximately 7 times faster than all-combinations 
;probe difference now/precise t

probe combinations "abcdefghi" 3

print [newline "Permutations:" newline]
prin "All permutations of [a b c]: "
print mold permutations [a b c]
print ["Original arrangement:" mold n-permutation [a b c] 0]
print ["Third arrangement:" mold n-permutation [a b c] 2]
print ["Last arrangemen:" mold n-permutation [a b c] 5]
print {All permutations of "abcd"}
print mold permutations "abcd"

print [newline "Number of variations:" newline]
print nVk 10 5

print [newline "Variations:" newline]
probe variations "abcd" 3