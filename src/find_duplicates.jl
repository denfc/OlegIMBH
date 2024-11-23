function find_duplicates(arr)
    return unique(filter(x -> count(==(x), arr) > 1, arr))
end