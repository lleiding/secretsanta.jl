#!/usr/bin/env julia

# A sript to draw for secret santa and send pairings via e-mail using msmtp.

# Usage: julia secretsanta.jl <table> [<mail account>]

# <table> is a csv table with columns "Name", "Pair", and "Address".
# Use the "Pair" columns to prevent drawing, e.g, partners names by assigning
# partners an identical id.

using Random
using CSV
using Dates

"""
    readtable(f)

Reads a csv file f containing information of secret santa participants.
Order of columns is: names, pairs, e-mail addresses.
"""
function readtable(tablefile)
    if isfile(tablefile)
        table = CSV.read(tablefile, comment="#")
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

"""
    mailsecretsanta(t, a)

Notifies participants via e-mail using information in table `t`.
This requires a set-up msmtp. Choose your prefered mail account `a`.
"""
function mailsecretsanta(table, mailaccount = "default")
    if length(size(table)) > 1
        for i in 1:size(table, 1)
            name = table.Name[i]
            mail = table.Address[i]
            santa = table.Santa[i]
            message = "To: $mail\r\nSubject: Weihnachtswichteln $(Dates.year(Dates.today()))\r\n\r\nHallo $name,\r\n\r\nDu darfst heuer $santa bewichteln.\r\n\r\nLG\r\nDein Weihnachtswichtelskript\r\n\r\nBesuch mich auf https://github.com/lleiding/secretsanta.jl\r\n"
            run(pipeline(`echo $message`, `msmtp -a $mailaccount $mail`))
        end
    else
        name = table.Name
        mail = table.Address
        santa = table.Santa
        message = "To: $mail\r\nSubject: Weihnachtswichteln $(Dates.year(Dates.today()))\r\n\r\nHallo $name,\r\n\r\nDu darfst heuer $santa bewichteln.\r\n\r\nLG\r\nDein Weihnachtswichtelskript\r\n"
        run(pipeline(`echo $message`, `msmtp -a $mailaccount $mail`))
    end        
end

"""
    runsecretsanta(f, a)

Runs the secret santa script using information in file `f`.
Mailing requires a set-up msmtp. Choose your prefered mail account `a`.
"""
function runsecretsanta(filename, mailaccount)
    table = readtable(filename)
    table.Santa = getsecretsanta(table[:,1], table[:,2])
    mailsecretsanta(table, mailaccount)
end

runsecretsanta(ARGS[1], ARGS[2])
