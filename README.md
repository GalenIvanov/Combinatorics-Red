# Combinatorics-Red
Basic combinatorics in Red language

* odometer
* power set
* Cartesian product
* number of combinations
* n-combination
* combinations
* n-permutation
* permutations
* number of variations
* variations

## Odometer

Generates a block of ranged permutations of block of integers. It can be regarded as a set of nested loops. Currently it is 0-based.

```
>> odometer [2 2 3]
[0 0 0]
[0 0 1]
[0 0 2]
[0 1 0]
[0 1 1]
[0 1 2]
[1 0 0]
[1 0 1]
[1 0 2]
[1 1 0]
[1 1 1]
[1 1 2]
```

## Power set

Creates the power set of a set - that is the set contsisting of all subsets of the given set.

```
>> power-set [1 2 3 4]
== [[] [1] [2] [1 2] [3] [1 3] [2 3] [1 2 3] [4] [1 4] [2 4] [1 2 4] [3 4] [1 3 4] [2 3 4] [1 2 3 4]]
```

## Cartesian product

Creates a block of all tuples of a given block of blocks:

```
>> cartesian-product [[a b]  [+ -] [1 3 2]]
== [[a + 1] [a + 3] [a + 2] [a - 1] [a - 3] [a - 2] [b + 1] [b + 3] [b + 2] [b - 1] [b - 3] [b - 2]]

```

## Number of combinations, nCk

Finds the binomial coefficient, or `n choose k` - the number of ways to choose an (unordered) subset of k elements from a fixed set of n elements

```
>> nCk 7 3
== 35
```

## N-th combination

`n-combination` finds the n-th combination of k elements from a set. Uses combinatorial number system.

```
>> n-combination [1 2 3] 2 1  ; the first combination of 2 elements from [1 2 3]
== [1 2]
>> n-combination [1 2 3] 2 3    ; the third (last) one -> nCk 3 2 is 3
== [2 3]
```

Uses combinatorial number system: https://en.wikipedia.org/wiki/Combinatorial_number_system

## Combinations

Finds all combinations of k elements of a series. It's done by generating every n-th combination in the range from 1 to `nCk (length? series) k`.

```
>> probe combinations [Red Orange Yellow Green Cyan] 2
[[Red Orange] [Red Yellow] [Orange Yellow] [Red Green] [Orange Green] [Yellow Green] [Red Cyan] [Orange Cyan] [Yellow Cyan] [Green Cyan]]
```

There is also an `all-combinations` function that is presented only to demonstrate a naive brute-force approach to the problem. Given a set of n elements, we can construct all n-digit binary numbers. 1 means that the element is used and 0 - not used. We are interested only in binary representations that have exactly `k` `1`s in them. So we generate all numbers in the range from `0` to `2 ** n - 1`, and keep only those that have `k` ones in their binary representation. Then we extract the series elements at the positions of ones.

## N-th permutation

`n-permutation` finds the n-th permutation of a series using factorial number system. (There are `n!` permutations total). 0-based.

```
>> n-permutation "abcdefghij" (factorial 10) - 1  ; the last permutation - i.e. series reversed
== "jihgfedcba"
```

`n-permutation` is based on Eugene McDonnell's article "Representing a Permutation" in  "At play with J":
https://code.jsoftware.com/wiki/Doc/Articles/Play121

## Permutations

Generates all permutations of a series. Calls `n-permuation` for all numbers in the range from 0 to `(factorial length? series) - 1`

```
>> permutations [a b c]
== [[a b c] [a c b] [b a c] [b c a] [c a b] [c b a]]
```

## Number of variations

`nVk` calculates the number of variations of k elements of set of n elements without repetition

```
>> nVk 10 5
== 30240
```

## Variations

Finds all the variations of k element of a series. Unlike combinations, here the order of elementw matters. Implemented by finding all permutations of of combinations oh k elements of the series.

```
>> variations "abcd" 2
== ["ab" "ba" "ac" "ca" "bc" "cb" "ad" "da" "bd" "db" "cd" "dc"]
```

# To do:
* Combinations with repetition
* Variations with repetition
