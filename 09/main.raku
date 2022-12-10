class Point {
    has $.x is rw;
    has $.y is rw;
}

class Rope {
    has $.count is required;
    has @!knots = gather take Point.new: :0x, :0y for 1 .. $!count;
    has %!visited = (0 => 0) => 1;

    method parse($_) {
        self!update-head: $_;
    }

    method !update-head($_) {
        /(<[UDLR]>) <.ws> (\d+)/;
        for 1 .. $1 {
            given $0 {
                @!knots[0].y++ when 'U';
                @!knots[0].y-- when 'D';
                @!knots[0].x-- when 'L';
                @!knots[0].x++ when 'R';
            }
            self!update-tails;
        }
    }

    method !update-tails() {
        for @!knots.kv -> $i, $this {
            next if $i == 0;
            my $prev = @!knots[$i.pred];
            until self!touching($this, $prev) {
                $this.x += Int($prev.x <=> $this.x);
                $this.y += Int($prev.y <=> $this.y);
                %!visited{$this.x => $this.y} = 1 if $i == @!knots.end;
            }
        }
    }

    method !touching($p1, $p2) {
        abs($p1.x - $p2.x) <= 1 && abs($p1.y - $p2.y) <= 1
    }

    method answer() {
        %!visited.elems
    }
}

my @lines = lines;

for 2, 10 -> $count {
    my $rope = Rope.new: :$count;
    $rope.parse: $_ for @lines;
    say $rope.answer;
}
