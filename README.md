# secretsanta.jl

A sript to draw for secret santa and send pairings via e-mail using msmtp.

Usage: julia secretsanta.jl <table> [<mail account>]

<table> is a csv table with columns "Name", "Pair", and "Address".
Use the "Pair" columns to prevent drawing, e.g, partners names by assigning
partners an identical id.

**Requires a set-up msmtp.**
