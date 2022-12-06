sub unique(@a) {
    return [&&] gather for 0 .. @a.end -> $i {
        for @a.kv -> $k, $v {
            take @a[$i] ne $v unless $k == $i;
        }
    }
}

sub MAIN($p where $p (elem) <1 2>) {
    my $a = slurp.chomp.comb.List;
    my $n = $p == 1 ?? 4 !! 14;

    for 0 .. $a.end {
        if unique($a[$_ .. $_ + $n - 1].grep(*.defined)) {
            say $_ + $n;
            last;
        }
    }
}
