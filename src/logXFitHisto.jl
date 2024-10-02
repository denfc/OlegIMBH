function logXFitHisto(X::Array, binSize::Float64, x_nolog::Bool)
	tmp = minimum(X)
	if tmp >= 0.0 
		if x_nolog logX = X else logX = log10.(X) end # in honor of "mass_mstar_logmsun"; worry later if some are zero (see SHR-4 then)
			# nPoints = length(X) # using in median calculation, below
		# binSize = 0.15 # dex; fit on Histogram will keep binSize fixed as given and therefore not pick up the last point.
		# firstEdge = minimum(m)
		# lastEdge = maximum(m) + binSize # problem is that you won't pick up one at the last point becuase the condition on the right-hand edge is less than, not less than or equal
		# EdgeRange = (firstEdge:binSize:lastEdge)
		# ym = fit(Histogram, mass_mstar_logmsun, nbins = 50) # I believe nbins here is treated as a suggestion!
		# y_fit = fit(Histogram, m, EdgeRange) # CAREFUL!  while the firstEdge is indeed the first edge, y_fit.edges[1][begin], because binSize remains fixed --- a (desired) property of "fit") --- lastEdge cannot (well, most likely) then equal y_fit.edges[1][end].  I don't want it to, i.e., I don't want just the last point in the last bin, but the last edge always includes the last point, I think. 
	else
		neg = findall(x -> x < 0, X)
		if x_nolog
			logX = X
		else
			logX = log10.(abs.(X)) 
			logX[neg] = -logX[neg]
			println("PROBLEM IF LESS THAN ONE TO START, WILL BE TURNED INTO POSITIVE, BUT IT SHOULD BE NEGATIVE! Warning: negative number transformed into minus log absolute value of negative number on x axis.")
		end
	end
	firstEdge = minimum(logX)
	if firstEdge == -Inf  # this should handle the zeros
		nonInfIndex = findall(x-> abs(x) != Inf, logX)
		firstEdge = minimum(logX[nonInfIndex])
	end
	maxLogX = maximum(logX)
	Xticks = collect(floor(firstEdge):1:ceil(maxLogX))
	if length(Xticks)==2 Xticks=[first(Xticks), mean(Xticks)/2, mean(Xticks), 1.5*mean(Xticks), last(Xticks)] end
	Xlims = (Xticks[begin], Xticks[end])
	lastEdge = maxLogX + binSize # problems solved by the binSize extension: 1) you wouldn't pick up one at the last point because the condition on the right-hand edge is less than, not less than or equal 2) range calculation, start:step:finish, does not go beyond finish, i.e., it ends at the last step, which may be prior to finish
	EdgeRange = firstEdge:binSize:lastEdge
	y_fit = fit(Histogram, logX, EdgeRange) # fit on Histogram keeps binSize fixed as given 
	# h = normalize(y_fit, mode=:probability)
	h = normalize(y_fit, mode=:pdf) # consider a switch between the two modes 
	Yends = extrema(y_fit.weights) # tuples are immutable
	# println("Y extrema: ", Yends)
	if Yends[1]<=1 # necessary to see the 1s (10^0)
		# ORIGINAL logYTintervals = collect(-1:1:ceil(log10(Yends[2]))) -- why should y ever be less than 1?
		logYTintervals = collect(0:1:ceil(log10(Yends[2])))
	else
		logYTintervals = collect(floor(log10(Yends[1])):1:ceil(log10(Yends[2])))
	end
	Yticks = 10 .^ logYTintervals
	# Ylims = (expYTicks[begin], expYTicks[end])
	Ylims = (Yticks[begin], Yticks[end])
	return Xticks, Xlims, Yends, Yticks, Ylims, y_fit, h
	# below was used to find median
	#=
	trueNbins = length(y_fit.weights)
	xm = zeros(Float64, trueNbins)
	for j = 1:trueNbins
		if (y_fit.weights[j] != 0) xm[j] = median(mass_mstar_logmsun[i] for i=1:nPoints if ((mass_mstar_logmsun[i] >= y_fit.edges[1][j]) && (mass_mstar_logmsun[i] < y_fit.edges[1][j + 1]))) end
	end
	=#
end