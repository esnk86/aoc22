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
    rule TOP      { <prompt> <command> <arg>? }
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

my %dirs;
my $cwd;

sub handle-input($line) {
    my $input = Shell.parse($line);
    return False unless defined $input;

    if $input<command> eq 'cd' {
        my $arg = CD-arg.parse: $input<arg>, :actions(CD-arg-Actions);
        $cwd = $arg.made.($cwd);
    }

    return True;
}

sub handle-output($line) {
    if my $size = LS-out.parse: $line, :actions(LS-out-Actions) {
        %dirs{$cwd} += $size.made;
    }
}

sub get-total-size($path) {
    my $total = %dirs{$path};

    for %dirs.keys {
        if $_ ne $path and /^$path/ {
            $total += %dirs{$_};
        }
    }

    $total
}

handle-input($_) or handle-output($_) for lines;

say %dirs.keys.map(&get-total-size).grep(* < 100_000).sum;

my $used = get-total-size '/';
my $unused = 70_000_000 - $used;

say min gather for %dirs.keys -> $path {
    my $total = get-total-size $path;
    take $total if $unused + $total >= 30_000_000;
}
