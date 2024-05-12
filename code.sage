def sieve_for_groups(G):
	if rank_of_group(G) == 2:
		return 1
	else:
		if RatioBound(G) == G.stabilizer(1).order():
			density = 1
		if G.socle().order()< 2^8:
			if G.order()<1000:
				Nder = []
				for x in G:
					if is_derangement(x) == False and x.order() > 1:
						Nder.append(x)
				X = Graph()
				E = []
				C = Combinations(Nder,2)
				for x in C:
					if is_derangement(x[0]*x[1].inverse()) == True:
						E.append((x[0],x[1]))
				X.add_vertices(Nder)
				X.add_edges(E)
				return (1+X.independent_set(value_only=True))/G.stabilizer(1).order()
			if G.is_primitive() == False:
				CC = G.conjugacy_classes_representatives()
				key = False
				for x in CC:
					H = G.subgroup([x])
					if H.is_semi_regular():
						O = [sorted(list(set(u))) for u in H.orbits()]
						for y in G.blocks_all():
							if sorted(list(set(y))) in O:
								print ("using a semi-regular quotient ...", end="", flush=True)
								print("\r", end="", flush=True)
								K = induced_action_label_fixed(G,(G.blocks_all()).index(y))
								density = find_using_gurobi(K)
								d = density
								if d == 1:
									#print ("Ye")
									return d
								else:
									key == True
									pass
							else:
								pass
						#if key == False:
					else:
						pass				
				return find_using_gurobi(G)
			else:
				density = find_using_gurobi(G)
		if G.socle().order()> 2^8:
			print ("Yes")
			density = find_using_gurobi(G)
	#print ("Yeseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")
	density = find_using_gurobi(G)
	return density

def sieve_for_groups_without_blocks(G):
	if rank_of_group(G) == 2:
		return 1
	else:
		if RatioBound(G) == G.stabilizer(1).order():
			return 1
		else:
			return find_using_gurobi(G)
	#print ("Yeseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")
#	density = find_using_gurobi(G)
#	return density
				
def sieve_for_groups_old(G):
	if rank_of_group(G) == 2:
		density = 1
	else:
		if RatioBound(G) == G.stabilizer(1).order():
			density = 1
		else:
			density = find_using_gurobi(G)
	return density

def find_using_gurobi(G):
	N = []
	T = eigenvalues_group_conjugacy_class_and_weights_gurobi(G)[0]
	#if ceil(T[0][0]) > float(T[0][0]) and floor(T[0][0]) < float(T[0][0]) :
	#	m = ceil(T[0][0])
	#else:
	m = round(float(T[0][0]))
	n = G.order()/(m+1)
	N.append([m,G.degree(),G.structure_description()])
	if m == G.degree()-1:
		return 1 
	if n.is_integer() and n>G.degree()-1 and G.order()<factorial(9) and intersecting_subgroup_order_evalues(G,n) == True:
		return G.degree()/(m+1)
	else:
		return "???"

def intersection_spectrum(G):
    M = G.conjugacy_classes_subgroups()
    L,N = [],[]
    for  x in M:
        if x.order() not in [1,G.order()] and is_prime_power(ZZ(G.order()/x.order())) == False:
            K = group_action_on_cosets(G,x)
            T = eigenvalues_group_conjugacy_class_and_weights_gurobi(K)[0]
            if ceil(T[0][0]) > float(T[0][0]) and floor(T[0][0]) < float(T[0][0]) :
                m = ceil(T[0][0])
            else:
                m = float(T[0][0])
            n = K.order()/(m+1)
            N.append([m,K.degree(),x.structure_description()])
            if n.is_integer() and intersecting_subgroup_order(K,n) == True:
                L.append(K.degree()/(m+1))
    return L,N

def find_information(n,k):
	L = []
	G = TransitiveGroup(n,k)
	L.append(["Join: {0} \n\r".format(is_join(G))])
	L.append(["Spectrum: {0}\n\r".format(eigenvalues_group_with_all_dim(G))])
	return L

def create_individual_file(n,k):
	G = TransitiveGroup(n,k)
	d = sieve_for_groups(G)
	f = open("TransitiveGroup({0},{1}).txt".format(n,k),"w+")
	L = ["Density: {0}\n\r".format(d)]
	L += find_information(n,k)
	f.writelines("transitive_group_id: [{0},{1}]\n\r Description: {2} \n\r Stabilizer: {3} \n\r".format(n,k,G.structure_description(),G.stabilizer(1).structure_description()))
	for x in L:
		for y in x:
			f.writelines(y)
	f.close()
	return L,G,d

def number_of_transitive_groups(n): 
	return ZZ(TransitiveGroups(n).cardinality())

def create_markdown_file(n):
	f = open("all-files-order-{0}.md".format(n),"w+")
	f.writelines("|n|k|Description|Density|Information|\n |:---|:---|:-----:|:-------:|:----------:|\n")
	m = number_of_transitive_groups(n)
	for k in [1..m]:
		print (m,k, end="", flush=True)
		print("\r", end="", flush=True)
		G = TransitiveGroup(n,k)
		if G.is_abelian():
			f.writelines("|{0}|{1}|{3}|{2}|{4}|\n".format(n,k,1,G.structure_description(),"Abelian"))
		else:
			N,G,d = create_individual_file(n,k)
			f.writelines("|{0}|{1}|{2}|{3}|[details](TransitiveGroup({0},{1}).txt)|\n".format(n,k,G.structure_description(),d))
			#else:
			#	f.writelines("|{0}||||number of groups: {1}|\n".format(n,m))
	f.close()
	return "Done"

def create_markdown_file_with_fixed_stop(n,t):
	f = open("all-files-order-{0}.md".format(n),"w+")
	f.writelines("|n|k|Description|Density|Information|\n |:---|:---|:-----:|:-------:|:----------:|\n")
	m = number_of_transitive_groups(n)
	for k in [1..m]:
		if k < t:
			print (m,k, end="", flush=True)
			print("\r", end="", flush=True)
			G = TransitiveGroup(n,k)
			if G.is_abelian():
				f.writelines("|{0}|{1}|{3}|{2}|{4}|\n".format(n,k,1,G.structure_description(),"Abelian"))
			else:
				N,G,d = create_individual_file(n,k)
				f.writelines("|{0}|{1}|{2}|{3}|[details](TransitiveGroup({0},{1}).txt)|\n".format(n,k,G.structure_description(),d))
				#else:
				#	f.writelines("|{0}||||number of groups: {1}|\n".format(n,m))
		else:
			if rank_of_group(G) == 2:
				G = TransitiveGroup(n,k)
				f.writelines("|{0}|{1}|{3}|{2}|{4}|\n".format(n,k,"???",G.structure_description(),"large"))
			else:
				G = TransitiveGroup(n,k)
				f.writelines("|{0}|{1}|{3}|{2}|{4}|\n".format(n,k,"???",G.structure_description(),"large"))
	f.close()
	return "Done"

def create_markdown_file_fixed_list(n,L):
	f = open("all-files-order-{0}-{1}-{2}.md".format(n,L[0],L[-1]),"w+")
	f.writelines("|n|k|Description|Density|Information|\n |:---|:---|:-----:|:-------:|:----------:|\n")
	m = number_of_transitive_groups(n)
	for k in L:
		print (m,k, end="", flush=True)
		print("\r", end="", flush=True)
		G = TransitiveGroup(n,k)
		if G.is_abelian():
			f.writelines("|{0}|{1}|{3}|{2}|{4}|\n".format(n,k,1,G.structure_description(),"Abelian"))
		else:
			N,G,d = create_individual_file(n,k)
			f.writelines("|{0}|{1}|{2}|{3}|[details](TransitiveGroup({0},{1}).txt)|\n".format(n,k,G.structure_description(),d))
			#else:
			#	f.writelines("|{0}||||number of groups: {1}|\n".format(n,m))
	f.close()
	return "Done"