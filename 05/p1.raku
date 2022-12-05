my @lines;
my @stacks;

grammar Stack {
    token TOP   { <space>+ % ' ' }
    token space { <crate> | <empty> }
    token crate { '[' <[A..Z]> ']' }
    token empty { ' ' ** 3 }
}

grammar Stack-Actions {
    method TOP($/) {
        my @spaces = $<space>.map(*.made).List;
        @stacks[$_].push: @spaces[$_] for 0 .. @spaces.end;
    }
    method space($/) { make $<crate>.made // $<empty>.made }
    method crate($/) { make $/.comb[1] }
    method empty($/) { Nil }
}

grammar Move {
    rule TOP { move <n> from <n> to <n> }
    token n  { \d+ }
}

class Move-Actions {
    method TOP($/) {
        my ($count, $from, $to) = $<n>.map(+*).List;
        @stacks[$to - 1].push: @stacks[$from - 1].pop
            for 1 .. $count;
    }
}

sub process($grammar, $actions) {
    for @lines {
        my $ast = $grammar.parse: $_, :$actions;
        $ast.made if $ast.defined;
    }
}

@lines = lines;
process Stack, Stack-Actions;
@$_.=grep(*.defined).=reverse for @stacks;
process Move, Move-Actions;
print @$_[* - 1] for @stacks;
print "\n";
