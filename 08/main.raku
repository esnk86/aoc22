my @heights = lines.map(*.comb.map(+*).Array).Array;

sub up($x, $y)    { @heights[0..$y.pred].map(*[$x]) }
sub down($x, $y)  { @heights[$y.succ..*].map(*[$x]) }
sub left($x, $y)  { @heights[$y][0..$x.pred] }
sub right($x, $y) { @heights[$y][$x.succ..*] }

sub is-visible($x, $y) {
    my @directions = &up, &down, &left, &right;

    [||] gather for @directions {
        take @heights[$y][$x] > .($x, $y).all;
    }
}

sub scenic-score($x, $y) {
    my @directions = &reverse o &up, &down, &reverse o &left, &right;

    [*] gather for @directions {
        take [+] gather for .($x, $y) {
            take 1;
            last if $_ >= @heights[$y][$x];
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
