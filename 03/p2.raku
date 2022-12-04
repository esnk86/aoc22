my %p = (|('a' .. 'z'), |('A' .. 'Z')).map: * => ++$;
my @lines = lines;
my @groups;

loop (my $i = 0; $i < @lines; $i += 3) {
    @groups.push: @lines[$i .. $i + 2];
}

say sum gather for @groups -> @group {
    @group.=map(*.comb.List);
    for @group[0].List {
        if $_ (elem) @group[1] and $_ (elem) @group[2] {
            take %p{$_};
            last;
        }
    }
}
