"""
dfc 19 November 2024
https://github.com/gcalderone/SortMerge.jl

CoPilot Explain
denfc: @workspace /explain 

Workspace: This code appears to be implementing a spatial join operation using a sort-merge algorithm, specifically designed for astronomical coordinate matching.

The `lt` function is a simple comparator that checks if one latitude/longitude pair is "less than" another by comparing their second components (longitudes).

The `sd` function is more complex - it's a distance-based comparator that takes two coordinate arrays (`v1`, `v2`), indices (`i1`, `i2`), and a threshold in arcseconds. It performs these steps:
1. Converts the threshold from arcseconds to degrees
2. Checks if points are far apart in longitude (quick rejection)
3. If points are close in longitude, calculates the great circle distance (`gcirc`)
4. Returns:
   - `0` if points are within the threshold (match)
   - `sign(d)` if points are far apart in longitude
   - `999` if points are not a match but close in longitude

Finally, the code calls `sortmerge` with two coordinate arrays (`[lat1 long1]` and `[lat2 long2]`), using the defined comparison functions and a 1 arcsecond threshold. The `@time` macro measures execution time.

This implementation is optimized for astronomical coordinate matching by using longitude as a first-pass filter before calculating more expensive great circle distances.

denfc: @workspace /explain explain line 18

Workspace: Let me explain this Julia line which uses some interesting shorthand syntax:

```julia
(abs(d) >= 1)  &&  (return sign(d))
```

This is a compact way of writing an if statement using Julia's short-circuit evaluation. Here's what it does step by step:

1. First, `abs(d)` gets the absolute value of `d` (which represents the normalized longitude difference)
2. Then checks if this value is `>= 1`
3. If true, it executes the second part after `&&` which returns `sign(d)`
4. If false, it skips the second part and continues with the rest of the function

It's equivalent to this more traditional if statement:
```julia
if abs(d) >= 1
    return sign(d)
end
```

The `&&` operator in Julia (like many other languages) uses short-circuit evaluation - if the first condition is false, it doesn't even evaluate the second part.

This is a common Julia idiom for concise conditional returns, though newer developers might find the traditional `if` statement more readable.

**Note**: In this specific context, this line is part of the spatial distance comparison, checking if two points are far enough apart in longitude to avoid the more expensive great circle distance calculation.

denfc: Is this expression better than the equivalent ternary expression?

GitHub Copilot: In Julia, this use of short-circuit `&&` versus a ternary operator involves a few considerations:

**Short-circuit &&:**
```julia
(abs(d) >= 1)  &&  (return sign(d))
```

**Equivalent ternary:**
```julia
abs(d) >= 1 ? return sign(d) : nothing
```

The short-circuit `&&` version is generally preferred here because:

1. It's more idiomatic Julia - this pattern is commonly used in the Julia ecosystem
2. It's more efficient - it only evaluates the second part if needed
3. The return statement is more natural in this form
4. It's clearer that this is an early exit condition

The ternary version:
- Requires an explicit `nothing` branch
- Is less clear about control flow
- Is typically better suited for value assignment rather than control flow

While both work, the short-circuit version better expresses the intent of "if condition met, do this and exit". It's particularly appropriate in this spatial joining context where we want fast rejection of non-matching coordinates.

- After looking at timeings with the new "const" variables scheme and finding no substantial improvement, CoPilot analyzed ...

GitHub Copilot
Let's analyze why moving the threshold calculations to constants didn't significantly improve performance:

Reason Analysis:

The original calculation threshold_arcsec/3600.0 was very simple
	- Julia's compiler likely optimized this constant division anyway
	- The function sd() is called many times, but the calculation overhead was minimal
	- The main computational cost is in:
		- Array operations
		- Great circle distance calculations (gcirc)
		- Sorting operations

Profiling Plan:

Optimization Focus:
The real performance gains would likely come from:
	- Optimizing the great circle distance calculation
	- Improving the sorting algorithm
	- Using parallel processing for large datasets
	- Pre-sorting/indexing strategies

While the constant definition is cleaner code, for significant performance improvements we'd need to focus on these larger computational bottlenecks.

denfc
Well done! Thanks.

testSortMerge.jl
:83-106
GitHub Copilot
You're welcome! Indeed, the refactoring to use module-level constants made the code cleaner and more maintainable, even if the performance gain was minimal. The core logic of the spatial join algorithm remains efficient with its quick longitude-based filtering before calculating the more expensive great circle distances.
"
"""

using SortMerge
using AstroLib
const THRESHOLD_ARCSEC = 1.0
const THRESHOLD_DEG = THRESHOLD_ARCSEC/3600.0 

nn = 1_000_000
lat1  = rand(nn) .* 180 .- 90.;
long1 = rand(nn) .* 360;
lat2  = rand(nn) .* 180 .- 90.;
long2 = rand(nn) .* 360;

lt(v, i, j) = (v[i, 2] < v[j, 2])
# function sd(v1, v2, i1, i2, threshold_arcsec) # original
function sd(v1, v2, i1, i2)
    # threshold_deg = threshold_arcsec / 3600. # [deg]
    # d = (v1[i1, 2] - v2[i2, 2]) / threshold_deg
    d = (v1[i1, 2] - v2[i2, 2]) / THRESHOLD_DEG
    (abs(d) >= 1)  &&  (return sign(d))
    dd = gcirc(2, v1[i1, 1], v1[i1, 2], v2[i2, 1], v2[i2, 2])
    # (dd < threshold_arcsec)  &&  (return 0)
    (dd < THRESHOLD_ARCSEC)  &&  (return 0)
    return 999
end
# @time j = sortmerge([lat1 long1], [lat2 long2], lt1=lt, lt2=lt, sd=sd, 1.)
@time j = sortmerge([lat1 long1], [lat2 long2], lt1=lt, lt2=lt, sd=sd)