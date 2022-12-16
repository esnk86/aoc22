class Slice {
    has %!slice;
    has $!bottom = 0;
    has $!answer = 0;

    method !floor() {
        $!bottom + 2;
    }

    method make(@lines) {
        for @lines {
            my @points = .split(' -> ').map(*.split(',').map: +*);

            for @points.keys.tail(* - 1) -> $i {
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

    method simulate() {
        $!answer++ until self!put-sand-unit;
        $!answer++;
        self.show;
        say $!answer;
    }

    method show() {
        my @lines;
        my $min-la = Inf;
        my $max-y;
        my $max-x;

        $max-y = %!slice.keys.max;
        $max-x = %!slice.values.map(*.max).max.key;

        @lines = gather for 0 .. $max-y -> $y {
            take (0..$max-x).map({ %!slice{$y}{$_} // ' ' }).join;
        }
        @lines.=List;

        for @lines { $min-la = min($min-la, m/^ ' ' */.chars) }
        for @lines { s/^ ' ' ** {$min-la}// }
        for @lines { .say }
    }

    method !min-max($a, $b) {
        return min($a, $b), max($a, $b);
    }

    method !put-rock-unit($x, $y) {
        $!bottom = max $!bottom, $y;
        %!slice{$y}{$x} = '#';
    }

    method !put-sand-unit() {
        my ($x1, $y1) = 500, 0;

        GRAVITY: while True {
            my @dirs =
                ($x1,      $y1.succ),
                ($x1.pred, $y1.succ),
                ($x1.succ, $y1.succ);

            for @dirs {
                my ($x2, $y2) = @$_;
                if (%!slice{$y2}{$x2} // ' ') eq ' ' {
                    ($x1, $y1) = ($x2, $y2);
                    last if $y1.succ == self!floor;
                    next GRAVITY;
                }
            }

            %!slice{$y1}{$x1} = 'o';
            return $x1 == 500 && $y1 == 0;
        }
    }
}

my $slice = Slice.new;
$slice.make: lines;
$slice.simulate;
