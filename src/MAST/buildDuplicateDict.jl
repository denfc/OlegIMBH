"""
    - called from `sixCrossMatches``
"""
function buildDuplicateDict(catB_dmls::Vector{Pair})::Vector{OrderedDict} # {String, Vector{Int64}}
	# dmls stands for `dup_matching_label_sets`
	# initiate `catsAtoB_dups` dictionary
	dupDictArray = Vector{OrderedDict}(undef, length(catB_dmls))
    # set up the array of dictionaries using `capB_dlms`
	for (i, pair) in enumerate(catB_dmls)
		dupDictArray[i] = OrderedDict(
			"Cat Path" => pair.first,
			"CatB_matching_labels_set" => pair.second
		)	
	end
	# 'cause `df` is global, can now add any key-value pairs from it the `dupDictArray` dictionaries
	for ind_dupDictArray in eachindex(dupDictArray)
		# `as ind_dupDictArray goes from 1 to 3, df_rowAtoB` should go 1, 3, 5
		# `as ind_dupDictArray goes from 1 to 3, df_rowBtoA` should go 2, 4, 6
		df_rowAtoB = 2ind_dupDictArray - 1
		df_rowBtoA = df_rowAtoB + 1
		for ind_BmatchingLabel in dupDictArray[ind_dupDictArray]["CatB_matching_labels_set"]
			print(ind_BmatchingLabel, " ")
			catA_ind = findall(x -> x == ind_BmatchingLabel, df[df_rowAtoB, "Catalog B matching labels"])

BUT if findfirst in df_rowBtoA, isn't that better?, because there's only one?
	df[df_rowAtoB, "Catalog A labels"][ind_CatALabels]
	df[df_rowBtoA, "Catalog B matching labels"][170, 1]


			ind_firstCartesian = getindex.(catA_ind, 1)
			if ind_dupDictArray == 2
				for ind_CatALabels in ind_firstCartesian
					println("ind_CatALabels = $ind_CatALabels ", df[df_rowAtoB, "Catalog A labels"][ind_CatALabels], " ")
				end
			end
		end
		println()

		dupDictArray[ind_dupDictArray]["Cat A labels"] = df[df_rowAtoB, "Catalog A labels"]	
		dupDictArray[ind_dupDictArray]["Cat B labels"] = df[df_rowBtoA, "Catalog A labels"]	

	end
	return dupDictArray
end
