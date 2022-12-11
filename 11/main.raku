my @monkeys;

class Monkey {
    has @.items;
    has &.operation;
    has $.operand;
    has &.test;
    has @.friends;
    has $.business = 0;

    method turn() {
        while @!items {
            my $item = @!items.shift;
            $item = &!operation($item);
            $item = floor($item / 3);
            self.throw: $item, @!friends[Int(&!test($item))];
            $!business++;
        }
    }

    method throw($item, $i) {
        @monkeys[$i].items.push: $item;
    }
}

grammar Record {
    rule TOP {
        Monkey \d+ ':'
        Starting items ':' <level>* % ', '
        Operation ':' new '=' old <operator> <operand>
        Test ':' divisible by <factor>
        If true ':' throw to monkey <friend>
        If false ':' throw to monkey <friend>
        .*
    }
    token level    { \d+ }
    token factor   { \d+ }
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
        my &test = { $_ %% $<factor> }
        my @friends = $<friend>.map(+*).reverse.List;
        make Monkey.new(:@items, :&operation, :$operand, :&test, :@friends);
    }

    method operator($/) {
        given ~$/ {
            make { $^a + $^b } when '+';
            make { $^a * $^b } when '*';
        }
    }
}

my @records = lines.grep(*.chars > 0).map(*.trim).rotor(6).map(*.join(' '));
@monkeys.push: Record.parse($_, actions => Record-Actions).made for @records;

for 1 .. 20 {
    for @monkeys {
        .turn;
    }
}

say [*] @monkeys.map(*.business).sort.tail(2);
