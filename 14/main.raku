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

    for @points.kv -> $i, $point {
        next if $i == 0;
        my ($p1, $p2) = @points[$i.pred], @points[$i];

        if $p1[0] != $p2[0] {
            # Horizontal.
            my $y = $p1[1];
            my ($begin, $end) = min-max($p1[0], $p2[0]);
            for $begin .. $end -> $x {
                put-rock-unit $x, $y;
            }
        } else {
            # Vertical.
            my $x = $p1[0];
            my ($begin, $end) = min-max($p1[1], $p2[1]);
            for $begin .. $end -> $y {
                put-rock-unit $x, $y;
            }
        }
    }
}

show-slice;
