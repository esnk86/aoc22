my @screen = [[' '] xx 40] xx 6;
my ($x, $y, $c) = 1, -1, 1;

sub update() {
    my $pos = ($c - 1) % 40 or $y++;
    @screen[$y][$pos] = '#' if $pos == $x-1|$x|$x+1;
    my $s = ($c - 20) %% 40 ?? $x !! 0;
    return $s * $c++;
}

say sum gather for lines() {
    if /addx <.ws> ('-'?\d+)/ {
        take update for 1..2;
        $x += $0;
    } else {
        take update;
    }
}

.join.say for @screen;
