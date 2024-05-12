def sub_orbits(G): ##need a fix (G is not the automorphism of the resulting graphs)
	S = G.stabilizer(1)
	T = S.orbits()
	symmetric = []
	asymmetric = []
	all_list = []
	for i in range(1,len(T)):
		O = G.orbit(tuple([1,T[i][0]]),"OnPairs")
		X = DiGraph()
		X.add_edges(O)
		A = X.adjacency_matrix()
		all_list.append(X)
		if A.is_symmetric():
			symmetric.append(Graph(X))
		else:
			asymmetric.append(X)
	asymmetric_pairs = []
	for X in asymmetric:
		A = X.adjacency_matrix()
		for B in asymmetric:
			if (A+B.adjacency_matrix()).is_symmetric() and [B.adjacency_matrix(),A] not in asymmetric_pairs:
				asymmetric_pairs.append([X,B])
	return symmetric,asymmetric_pairs


def check_equality_of_characters(phi,p):
	Phi = SymmetricGroupRepresentation(p).to_character()
	return phi.values() == Phi.values()

def find_partitions(n,phi):
	P = Partitions(n)
	for p in P:
		if check_equality_of_characters(phi,p) == True:
			return p 
		

def find_largest_partition(n,H):
	G = SymmetricGroup(n)
	triv = H.trivial_character()
	phi = triv.induct(G)
	Const = phi.irreducible_constituents()
	Parts = []
	for f in Const:
		Parts.append(find_partitions(n,f))
	P = posets.IntegerPartitionsDominanceOrder(n)
	S = P.subposet(Parts)
	T = list(S)
	return T[len(T)-2]

def find_orbits(n,H):
	G = SymmetricGroup(n)
	K = group_action_on_cosets(G,H)
	p = find_largest_partition(n,H)
	T = p.young_subgroup()
	S = group_action_on_cosets_intransitive(G,H,T)
	return S.orbits()

def is_coclique(K,O):
	Graphs = sub_orbits(K)[0]
	for X in Graphs:
		if X.is_independent_set(O[0]) == True or X.is_independent_set(O[1]) == True:
			return True,X.independent_set(value_only=True),[len(x) for x in O]
	return False

def check_graphs(n,H):
	K = group_action_on_cosets(SymmetricGroup(n),H)
	O = find_orbits(n,H)
	print (is_coclique(K,O))

def check_all(n,H):
	K = group_action_on_cosets(SymmetricGroup(n),H)
	p = find_largest_partition(n,H)
	print (p)
	T = p.young_subgroup()
	S = group_action_on_cosets_intransitive(G,H,T)
	O = S.orbits()
	Graphs = sub_orbits(K)[0]
	for X in Graphs:
		if X.is_independent_set(O[0]) == True or X.is_independent_set(O[1]) == True:
			print ('Index = {0}'.format(Graphs.index(X)),X.independent_set(value_only=True),[len(x) for x in O],(min(X.spectrum()))==-X.degree()[0]*len(O[0])/(X.order()-len(O[0])), min(X.spectrum()) == -X.degree()[0]*len(O[1])/(X.order() - len(O[1])) )
