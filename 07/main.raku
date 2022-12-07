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

my %sizes;
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
        %sizes{$cwd} += $size.made;
    }
}

sub add-subdir-sizes() {
    for %sizes.keys -> $this {
        for %sizes.keys -> $that {
            if $this ne $that and $that ~~ /^$this/ {
                %sizes{$this} += %sizes{$that};
            }
        }
    }
}

handle-input($_) or handle-output($_) for lines;
add-subdir-sizes;
say %sizes.values.grep(* < 100_000).sum;
