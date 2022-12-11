my $problem;
my @monkeys;
my $lcm;

class Monkey {
    has @.items;
    has &.operation;
    has $.test;
    has @.friends;
    has $.business = 0;

    method turn() {
        while @!items {
            my $item = @!items.shift;
            $item = &!operation($item);
            $item = self!manage-worry: $item;
            self!throw: $item;
            $!business++;
        }
    }

    method !manage-worry($item) {
        if $problem == 1 {
            return floor($item / 3);
        } else {
            return $item % $lcm;
        }
    }

    method !throw($item) {
        my $friend = @!friends[Int($item %% $!test)];
        @monkeys[$friend].items.push: $item;
    }
}

grammar Record {
    rule TOP {
        Monkey \d+ ':'
        Starting items ':' <level>* % ', '
        Operation ':' new '=' old <operator> <operand>
        Test ':' divisible by <test>
        If true ':' throw to monkey <friend>
        If false ':' throw to monkey <friend>
    }
    token level    { \d+ }
    token test     { \d+ }
    token operator { <[+*]> }
    token operand  { old | \d+ }
    token friend   { \d+ }
}

class Record-Actions {
    method TOP($/) {
        my @items = $<level>.map(+*).List;
        my $operand = ~$<operand>;
        my &operation = $operand eq 'old'
            ?? { $<operator>.made.($_, $_) }
            !! { $<operator>.made.($_, $operand) }
        my $test = +$<test>;
        my @friends = $<friend>.map(+*).reverse.List;
        make Monkey.new(:@items, :&operation, :$test, :@friends);
    }

    method operator($/) {
        given ~$/ {
            make { $^a + $^b } when '+';
            make { $^a * $^b } when '*';
        }
    }
}

sub MAIN($pn where $pn (elem) <1 2>) {
    $problem = +$pn;
    my $rounds = $problem == 1 ?? 20 !! 10_000;

    my @records = lines.grep(*.chars > 0).rotor(6).map(*.words.join(' '));
    @monkeys.push: Record.parse($_, actions => Record-Actions).made for @records;
    $lcm = [lcm] @monkeys.map(*.test);

    for 1 .. $rounds {
        for @monkeys {
            .turn;
        }
    }

    say [*] @monkeys.map(*.business).sort.tail(2);
}
