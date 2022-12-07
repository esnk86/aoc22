my %p = (|('a' .. 'z'), |('A' .. 'Z')).map: * => ++$;

sub ans(@a) {
    sum gather take %p{ .head.comb.first: { .tail(* - 1).all.match: $^c } } for @a
}

my @lines = lines;
say ans @lines.map: { .comb(Int(.chars / 2)).List };
say ans @lines.rotor: 3;
