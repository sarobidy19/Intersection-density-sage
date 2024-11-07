# Intersection-density-sage


Some codes for permutation groups in sagemath. This is mainly intended for the purpose of computing the intersection density of a transitive group.

## How to use this code

```python 
	sage: load("https://raw.githubusercontent.com/sarobidy19/Intersection-density-sage/refs/heads/main/all-functions.sage") ```

```python 
sage: G = permutation_group(SymmetricGroup(5))
sage: M = G.conjugacy_classes_subgroups()
sage: for x in M:
....: 	if x.is_isomorphic(DihedralGroup(6)):
....:		H = x	
....: 		break
sage: K = G.group_action(H)
sage: S = K.stabilizer(1)
sage: S.structure_description()
'D6'
sage: K.degree(),K.rank_of_group()
```
