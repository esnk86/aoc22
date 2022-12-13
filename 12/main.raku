my @paths;
my @grid;
my @queue;
my %hist;
my @dirs = (-1, 0), (1, 0), (0, -1), (0, 1);
my $alpha = ('a'..'z').join;

sub height-of($x, $y) {
    given @grid[$y][$x] {
        return 0 when 'S';
        return 25 when 'E';
        default { return $alpha.index: $_ }
    }
}

sub can-move($x1, $y1, $x2, $y2) {
    return [&&]
        not %hist{$x2}{$y2}:exists,
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

sub find-paths() {
    my $steps;
    my $x;
    my $y;

    %hist{.[0]}{.[1]} = 1 for @queue;

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

sub MAIN($problem where $problem (elem) <1 2>) {
    @grid = lines.map(*.comb.List).List;

    for @grid.keys -> $y {
        for @grid[$y].keys -> $x {
            if $problem == 1 and @grid[$y][$x] eq 'S' {
                @queue.push: ($x, $y, 0);
                last;
            } elsif $problem == 2 and @grid[$y][$x] eq 'S'|'a' {
                @queue.push: ($x, $y, 0);
            }
        }
    }

    find-paths;

    say @paths.min;
}
