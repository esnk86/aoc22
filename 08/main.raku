my @heights = lines.map(*.comb.map(+*).Array).Array;

sub up($x, $y)    { @heights[0..$y.pred].map(*[$x]) }
sub down($x, $y)  { @heights[$y.succ..*].map(*[$x]) }
sub left($x, $y)  { @heights[$y][0..$x.pred] }
sub right($x, $y) { @heights[$y][$x.succ..*] }

sub is-visible($x, $y) {
    my @directions = up($x, $y), down($x, $y), left($x, $y), right($x, $y);

    [||] gather for @directions {
        take @heights[$y][$x] > .all;
    }
}

sub scenic-score($x, $y) {
    my $height = @heights[$y][$x];
    my @directions = up($x, $y).reverse, down($x, $y), left($x, $y).reverse, right($x, $y);

    [*] gather for @directions {
        take [+] gather for @$_ {
            take 1;
            last if $_ >= $height;
        }
    }
}

say sum gather for 0 .. @heights.end -> $y {
    for 0 .. @heights[$y].end -> $x {
        if is-visible($x, $y) {
            take 1;
        }
    }
}

say max gather for 0 .. @heights.end -> $y {
    for 0 .. @heights[$y].end -> $x {
        take scenic-score($x, $y);
    }
}
