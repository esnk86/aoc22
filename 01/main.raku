my @cals = 0;

for lines() {
    if $_ {
        @cals[* - 1] += $_;
    } else {
        @cals.push: 0;
    }
}

@cals.max.say;
@cals.sort.reverse.[0..2].sum.say;
