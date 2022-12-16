my @slice;

sub min-max($a, $b) {
    return min($a, $b), max($a, $b);
}

sub put-rock-unit($x, $y) {
    @slice[$_] //= ['.'] for 0 .. $y.pred;
    @slice[$y.pred][$_] //= '.' for 0 .. $x.pred;
    @slice[$y.pred][$x.pred] = '#';
}

sub show-slice() {
    my @lines;
    my $min = Inf;
    my $max = 0;

    @lines.push: .join for @slice;
    for @lines { $max = max($max, .chars) }
    for @lines { $_ ~= '.' until .chars == $max }
    for @lines { $min = min($min, m/^ '.' */.chars) }
    for @lines { s/^ '.' ** {$min}// }
    for @lines { say $++, " $_" }
}

for lines() -> $line {
    my @points = $line.split(' -> ').map(*.split(',').map: +*);

    for @points.keys -> $i {
        next if $i == 0;
        my ($p1, $p2) = @points[$i.pred], @points[$i];

        if $p1[0] != $p2[0] {
            # Horizontal.
            my ($begin, $end) = min-max($p1[0], $p2[0]);
            put-rock-unit $_, $p1[1] for $begin .. $end;
        } else {
            # Vertical.
            my ($begin, $end) = min-max($p1[1], $p2[1]);
            put-rock-unit $p1[0], $_ for $begin .. $end;
        }
    }
}

show-slice;
