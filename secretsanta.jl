#!/usr/bin/env julia

using Random
using CSV

"""
    readtable(f)

Reads a csv file f containing information of secret santa participants.
Order of columns is: names, pairs, e-mail addresses.
"""
function readtable(tablefile)
    if isfile(tablefile)
        table = CSV.read(tablefile)
    else
        error("$tablefile is not a valid file.")
    end
    table
end

"""
    getsecretsanta(n, p)

Takes two vectors with names, n, and corresponding pairings, p,
and returns a permutated names vector for secret santa.
"""
function getsecretsanta(names, pairs)
    santaindex = shuffle(eachindex(names))
    while any(pairs.== pairs[santaindex])
        santaindex = shuffle(eachindex(names))
    end
    secretsanta = names[santaindex]
end

table = readtable(ARGS[1])

table.Santa = getsecretsanta(table[:,1], table[:,2])
