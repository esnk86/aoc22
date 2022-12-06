my &uniq = { .comb.Set.elems == .chars }

my $s = slurp;

for 4, 14 -> $n {
    say $s.comb.keys.first({ uniq $s.substr: $_, $n }) + $n;
}
