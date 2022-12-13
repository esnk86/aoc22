my @grid = lines.map(*.comb.List).List;
my @dirs = (-1, 0), (1, 0), (0, -1), (0, 1);
my $alpha = ('a'..'z').join;
my %hist;

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

sub find-shortest-path(@queue) {
    my @paths;
    %hist = ();
    %hist{.[0]}{.[1]} = 1 for @queue;

    while @queue {
        my ($x, $y, $steps) = @queue.shift;
        if @grid[$y][$x] eq 'E' {
            @paths.push: $steps;
        } else {
            my @options = options($x, $y, $steps);
            %hist{.[0]}{.[1]} = 1 for @options;
            @queue.push: |@options;
        }
    }

    return @paths.min;
}

my (@q1, @q2);

for @grid.keys -> $y {
    for @grid[$y].keys -> $x {
        if height-of($x, $y) == 0 {
            @q1.push: ($x, $y, 0) if @grid[$y][$x] eq 'S';
            @q2.push: ($x, $y, 0);
        }
    }
}

say find-shortest-path @q1;
say find-shortest-path @q2;
