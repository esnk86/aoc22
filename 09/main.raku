class Point {
    has $.x is rw;
    has $.y is rw;
}

class Rope {
    has $!h = Point.new(:0x, :0y);
    has $!t = Point.new(:0x, :0y);
    has %!v = (0 => 0) => 1;

    method parse($_) {
        self!update-head: $_;
        self!update-tail;
    }

    method !update-head($_) {
        /(<[UDLR]>) <.ws> (\d+)/;
        given $0 {
            $!h.y += $1 when 'U';
            $!h.y -= $1 when 'D';
            $!h.x -= $1 when 'L';
            $!h.x += $1 when 'R';

        }
    }

    method !update-tail() {
        until self!touching {
            $!t.x += Int($!h.x <=> $!t.x);
            $!t.y += Int($!h.y <=> $!t.y);
            %!v{$!t.x => $!t.y} = 1;
        }
    }

    method !touching() {
        abs($!h.x - $!t.x) <= 1 && abs($!h.y - $!t.y) <= 1
    }

    method answer1() {
        %!v.elems
    }
}

my $rope = Rope.new;
$rope.parse: $_ for lines;
say $rope.answer1;
