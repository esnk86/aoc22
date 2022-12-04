grammar RPS {
    rule  TOP { <o> <p> }
    token o   { <[ABC]> }
    token p   { <[XYZ]> }
}

class RPSA {
    method TOP($/)   { make $<p>.made.succ + self.s: $<o>.made, $<p>.made }
    method o($/)     { make 'ABC'.index: $/ }
    method p($/)     { make 'XYZ'.index: $/ }
    method s($o, $p) { 3 * ((abs($p - $o + 2) - 1) % 3) }
}

lines.map({ RPS.parse($_, :actions(RPSA)).made }).sum.say
