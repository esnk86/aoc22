my $problem;
my @lines;
my @stacks;

grammar Stack {
    token TOP   { <space>+ % ' ' }
    token space { <crate> | <empty> }
    token crate { '[' <[A..Z]> ']' }
    token empty { ' ' ** 3 }
}

class Stack-Actions {
    method TOP($/) {
        for $<space>.map(*.made).kv -> $k, $v {
            @stacks[$k].unshift: $v if $v;
        }
    }
    method space($/) { make $<crate>.made }
    method crate($/) { make $/.comb[1] }
}

grammar Move {
    rule TOP { move <n> from <n> to <n> }
    token n  { \d+ }
}

class Move-Actions {
    method TOP($/) {
        my ($count, $from, $to) = $<n>.map(+*).List;
        given $problem {
            move($count, $from, $to, :r) when 1;
            move($count, $from, $to) when 2;
        }
    }
}

sub move($count, $from, $to, :$r) {
    my $src = @stacks[$from.pred];
    my $dst = @stacks[$to.pred];
    my $load = splice($src, $src.elems - $count, $count);
    @$load.=reverse if $r;
    $dst.push: |$load;
}

sub process($grammar, $actions) {
    for @lines {
        .defined and .made with $grammar.parse: $_, :$actions;
    }
}

sub MAIN($pn where $pn (elem) <1 2>) {
    $problem = $pn;
    @lines = $*IN.lines;
    process Stack, Stack-Actions;
    process Move, Move-Actions;
    .tail.print for @stacks;
    print "\n";
}
