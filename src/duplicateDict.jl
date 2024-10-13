function duplicateDict(catB_dmls::Vector{Pair})::Vector{OrderedDict} # {String, Vector{Int64}}
	# initiate `catsAtoB_dups` dictionary
	dupDictArray = Vector{OrderedDict}(undef, length(catB_dmls))
    # set up the array of dictionaries using `capB_DLMS`
	for (i, pair) in enumerate(catB_dmls)
		dupDictArray[i] = OrderedDict(
			"Cat Path" => pair.first,
			"CatB_matching_labels" => pair.second
		)	
	end
	# now can add any key-value pairs to any or all dictionaries
	for i in eachindex(dupDictArray)
		for df_rowAtoB in 1:2:size(df)[1]
			df_rowBtoA = df_rowAtoB + 1


			dupDictArray[i]["Cat B labels"] = df[df_rowBtoA, "Catalog A labels"]	
		end
	end


	return dupDictArray
end
