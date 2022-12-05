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
        my @spaces = $<space>.map(*.made).List;
        @stacks[$_].unshift: @spaces[$_] for 0 .. @spaces.end;
    }
    method space($/) { make $<crate>.made // $<empty>.made }
    method crate($/) { make $/.comb[1] }
    method empty($/) { '' }
}

grammar Move {
    rule TOP { move <n> from <n> to <n> }
    token n  { \d+ }
}

class Move-Actions {
    method TOP($/) {
        my ($count, $from, $to) = $<n>.map(+*).List;
        given $problem {
            move1($count, $from, $to) when 1;
            move2($count, $from, $to) when 2;
        }
    }
}

# Move $count crates with the CrateMover 9000.
sub move1($count, $from, $to) {
    @stacks[$to - 1].push: @stacks[$from - 1].pop
        for 1 .. $count;
}

# Move $count crates with the CrateMover 9001.
sub move2($count, $from, $to) {
    my $moved = @stacks[$from - 1];
    @stacks[$to - 1].push: $_
        for splice($moved, $moved.elems - $count, $count);
}

sub process($grammar, $actions) {
    for @lines {
        my $ast = $grammar.parse: $_, :$actions;
        $ast.made if $ast.defined;
    }
}

sub MAIN($pn where $pn (elem) <1 2>) {
    $problem = $pn;
    @lines = $*IN.lines;
    process Stack, Stack-Actions;
    @$_.=grep(*.so) for @stacks;
    process Move, Move-Actions;
    print @$_[* - 1] for @stacks;
    print "\n";
}
