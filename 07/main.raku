grammar CD-arg {
    token TOP    { <root> | <parent> | <child> }
    token root   { '/' }
    token parent { '..' }
    token child  { \S+ }
}

grammar LS-out {
    rule  TOP  { <size> <name> }
    token size { dir | \d+ }
    token name { \S+ }
}

grammar Shell {
    rule  TOP     { <prompt> <command> <arg>? }
    token prompt  { '$' }
    token command { [cd | ls] }
    token arg     { \S+ }
}

class CD-arg-Actions {
    method TOP($/)    { make $<root>.made || $<parent>.made || $<child>.made }
    method root($/)   { make { '/'.IO } }
    method parent($/) { make { .dirname.IO } }
    method child($/)  { make { .add: $/ } }
}

class LS-out-Actions {
    method TOP($/)  { make $<size>.made }
    method size($/) { make $/ eq 'dir' ?? 0 !! +$/ }
}

my (%dirs, $cwd);

sub handle-input($line) {
    my $input = Shell.parse($line) // return False;
    .defined and $cwd = .made.($cwd) with CD-arg.parse: $input<arg> // '', actions => CD-arg-Actions;
    return True;
}

sub handle-output($line) {
    .defined and %dirs{$cwd} += .made with LS-out.parse: $line, actions => LS-out-Actions;
}

sub get-total-size($path) {
    %dirs{$path} + %dirs.keys.grep(/^$path.+/).map({ %dirs{$_} }).sum
}

handle-input $_ or handle-output $_ for lines;
my $unused = 70_000_000 - get-total-size '/';
say %dirs.keys.map(&get-total-size).grep(* < 100_000).sum;
say %dirs.keys.map(&get-total-size).sort.first: * + $unused >= 30_000_000;
