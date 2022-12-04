grammar RPS {
    rule  TOP { <o> <p> }
    token o   { <[ABC]> }
    token p   { <[XYZ]> }
}

class RPSA {
    method TOP($/)   { make 3 * $<p>.made + self.s: $<o>.made, $<p>.made }
    method o($/)     { make 'ABC'.index: $/ }
    method p($/)     { make 'XYZ'.index: $/ }
    method s($o, $p) { ($o + $p + 2) % 3 + 1 }
}

lines.map({ RPS.parse($_, :actions(RPSA)).made }).sum.say
