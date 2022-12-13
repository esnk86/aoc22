my @paths;
my @grid;
my %hist;
my @dirs = (-1, 0), (1, 0), (0, -1), (0, 1);
my $alpha = ('a'..'z').join;

sub height-of($x, $y) {
    my $c = @grid[$y][$x];
    if $c eq 'S' {
        return 0;
    } elsif $c eq 'E' {
        return 25;
    } else {
        return $alpha.index: $c;
    }
}

sub can-move($x1, $y1, $x2, $y2) {
    return [&&]
        !defined(%hist{$x2}{$y2}),
        $y2 (elem) @grid.keys,
        $x2 (elem) @grid[$y2].keys,
        height-of($x2, $y2) - height-of($x1, $y1) <= 1;
}

sub options($x, $y, $steps) {
    return @dirs
        .map({ ($x + .[0], $y + .[1], $steps.succ) })
        .grep({ can-move $x, $y, .[0], .[1] })
        .List;
}

sub find-path($x is copy, $y is copy) {
    my $steps;
    my @queue;

    @queue.push: ($x, $y, 0);
    %hist{$x}{$y} = 1;

    while @queue {
        ($x, $y, $steps) = @queue.shift;

        if @grid[$y][$x] eq 'E' {
            @paths.push: $steps;
        } else {
            my @options = options($x, $y, $steps);
            %hist{.[0]}{.[1]} = 1 for @options;
            @queue.push: |@options;
        }
    }
}

@grid = lines.map(*.comb.List).List;

for @grid.keys -> $y {
    for @grid[$y].keys -> $x {
        if @grid[$y][$x] eq 'S' {
            find-path($x, $y);
            last;
        }
    }
}

say @paths.min;
