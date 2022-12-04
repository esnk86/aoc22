grammar RP {
    token TOP { <r> ',' <r> }
    token r   { <n> '-' <n> }
    token n   { \d+ }
}

class RPA {
    method TOP($/) { make $<r>.map(*.made).List }
    method r($/)   { make $<n>[0] .. $<n>[1] }
    method n($/)   { make +$/ }
}

my @pairs = lines.map: { RP.parse($_, :actions(RPA)).made };

say sum gather for @pairs -> ($r1, $r2) {
    take 1 if $r1 ~~ $r2 or $r2 ~~ $r1;
}

say sum gather for @pairs -> ($r1, $r2) {
    take 1 if $r1.any ~~ $r2 or $r2.any ~~ $r1;
}
