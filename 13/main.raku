multi compare(Int $a, Int $b) {
    return $a <=> $b;
}

multi compare(Array $a, Array $b) {
    for 0 .. max($a.end, $b.end) {
        return Less if $_ > $a.end;
        return More if $_ > $b.end;
        given compare($a[$_], $b[$_]) {
            next when Same;
            default { return $_ }
        }
    }
    return Same;
}

multi compare($a is copy, $b is copy) {
    $_ ~~ Array or $_ = Array.new($_) for $a, $b;
    return compare($a, $b);
}

my @packets = lines.grep(*.chars > 0).map(*.EVAL).List;
my @div = [[2]], [[6]];

say sum gather for @packets.rotor(2).kv -> $i, ($a, $b) {
    take $i.succ if compare($a, $b) ~~ Less;
}

@packets.push: |@div;
@packets.=sort: &compare;

say [*] gather for @packets.kv -> $i, $packet {
    take $i.succ if $packet === @div.any;
}
