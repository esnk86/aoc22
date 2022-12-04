my %p = (|('a' .. 'z'), |('A' .. 'Z')).map: * => ++$;

sub f($s) {
    my (%a, %b);
    %a{$_}++ for $s.comb[0 ..^ */2];
    %b{$_}++ for $s.comb[*/2 .. *];
    %b{$_} and return %p{$_} for %a.keys;
}

lines>>.&f.sum.say;
