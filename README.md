# Combinatorics-Red
Basic combinatorics in Red language

* odometer
* power set
* Cartesian product
* number of combinations
* combinations
* permutations
* number of variations
* variations

Permutations are based on Eugene McDonnell's article "Representing a Permutation" in  "At play with J":

https://code.jsoftware.com/wiki/Doc/Articles/Play121


## Odometer

Generates a block of ranged permutations of block of integers. it can be regarded as a set of netsed loops. Currently it is 0-based.

```
>>odometer [2 2 3]
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
>>power-set [1 2 3 4]
[[] [1] [2] [1 2] [3] [1 3] [2 3] [1 2 3] [4] [1 4] [2 4] [1 2 4] [3 4] [1 3 4] [2 3 4] [1 2 3 4]]
```

## Cartesian product

Creates a block of all tuples of a given block of blocks:

```
>>cartesian-product [[a b]  [+ -] [1 3 2]]
[[a + 1] [a + 3] [a + 2] [a - 1] [a - 3] [a - 2] [b + 1] [b + 3] [b + 2] [b - 1] [b - 3] [b - 2]]

```

## Number of combinations, nCk

Finds the binomial coefficient, or `n choose k` - the number of ways to choose an (unordered) subset of k elements from a fixed set of n elements

```
>>nCk 7 3
35
```

## N-th combination

Finds the n-th combination of k elements from a set. Uses combinatorial number system.

```
>>n-combination [1 2 3] 2 1  ; the first combination of 2 elements from [1 2 3]
[1 2]
n-combination [1 2 3] 2 3    ; the third (last) one -> nCk 3 2 is 3
[2 3]
```

## Combinations

Finds all combinations of k elements of a series. Generates every n-th combination in the range from 1 to `nCk (length? series) k`.

```
>>probe combinations [Red Orange Yellow Green Cyan] 3
[[Red Orange Yellow] [Red Orange Green] [Red Yellow Green] [Orange Yellow Green] [Red Orange Cyan] [Red Yellow Cyan] [Orange Yellow Cyan] [Red Green Cyan] [Orange Green Cyan] [Yellow Green Cyan]]
```

# To do:
* Combinations with repetition
* Variations with repetition
