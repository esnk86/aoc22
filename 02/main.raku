grammar Input {
    rule  TOP { <o> <p> }
    token o   { <[ABC]> }
    token p   { <[XYZ]> }
}

role Input-Actions {
    method o($/) { make 'ABC'.index: $/ }
    method p($/) { make 'XYZ'.index: $/ }
}

class P1 does Input-Actions {
    method TOP($/)   { make $<p>.made.succ + self.s: $<o>.made, $<p>.made }
    method s($o, $p) { 3 * ((abs($p - $o + 2) - 1) % 3) }
}

class P2 does Input-Actions {
    method TOP($/)   { make 3 * $<p>.made + self.s: $<o>.made, $<p>.made }
    method s($o, $p) { ($o + $p + 2) % 3 + 1 }
}

my @lines = lines;
for P1, P2 -> $actions {
    @lines.map({ Input.parse($_, :$actions).made }).sum.say;
}
