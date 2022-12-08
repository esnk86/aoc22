my @heights = lines.map(*.comb.map(+*).Array).Array;

sub is-visible($x, $y) {
    my $height = @heights[$y][$x];
    return True if $height > @heights[$y][0..$x-1].all;
    return True if $height > @heights[$y][$x+1..*].all;
    return True if $height > @heights[0..$y-1].map(*[$x]).all;
    return True if $height > @heights[$y+1..*].map(*[$x]).all;
    False;
}

say sum gather for 0 .. @heights.end -> $y {
    for 0 .. @heights[$y].end -> $x {
        if is-visible($x, $y) {
            take 1;
        }
    }
}
