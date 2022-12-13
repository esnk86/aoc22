sub correct-order($a is copy, $b is copy) {
    if $a ~~ Int and $b ~~ Int {
        return $a <=> $b;
    } elsif $a ~~ Array and $b ~~ Array {
        for 0 .. max($a.end, $b.end) {
            return Less if $_ > $a.end;
            return More if $_ > $b.end;
            given correct-order($a[$_], $b[$_]) {
                next when Same;
                default { return $_ }
            }
        }
        return Same;
    } else {
        $_ ~~ Array or $_ = Array.new($_) for $a, $b;
        return correct-order($a, $b);
    }
}

my @packets = lines.grep(*.chars > 0).map(*.EVAL).List;
my @div = [[2]], [[6]];

say sum gather for @packets.rotor(2).kv -> $i, ($a, $b) {
    take $i.succ if correct-order($a, $b) ~~ Less;
}

@packets.push: |@div;
@packets.=sort: &correct-order;

say [*] gather for @packets.kv -> $i, $packet {
    take $i.succ if $packet === @div.any;
}
