class Slice {
    has @!slice;

    method !min-max($a, $b) {
        return min($a, $b), max($a, $b);
    }

    method !put-rock-unit($x, $y) {
        @!slice[$_] //= ['.'] for 0 .. $y.pred;
        @!slice[$y.pred][$_] //= '.' for 0 .. $x.pred;
        @!slice[$y.pred][$x.pred] = '#';
    }

    method show() {
        my @lines;
        my $min = Inf;
        my $max = 0;

        @lines.push: .join for @!slice;

        for @lines { $max = max($max, .chars) }
        for @lines { $_ ~= '.' until .chars == $max }
        for @lines { $min = min($min, m/^ '.' */.chars) }
        for @lines { s/^ '.' ** {$min}// }
        for @lines { say $++, " $_" }
    }

    method make(@lines) {
        for @lines {
            my @points = .split(' -> ').map(*.split(',').map: +*);

            for @points.keys -> $i {
                next if $i == 0;
                my ($p1, $p2) = @points[$i.pred], @points[$i];

                if $p1[0] != $p2[0] {
                    # Horizontal.
                    my ($begin, $end) = self!min-max($p1[0], $p2[0]);
                    self!put-rock-unit: $_, $p1[1] for $begin .. $end;
                } else {
                    # Vertical.
                    my ($begin, $end) = self!min-max($p1[1], $p2[1]);
                    self!put-rock-unit: $p1[0], $_ for $begin .. $end;
                }
            }
        }
    }
}

my $slice = Slice.new;
$slice.make: lines;
$slice.show;
