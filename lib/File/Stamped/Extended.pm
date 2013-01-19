package File::Stamped::Extended;
use strict;
use warnings;
use POSIX qw//;
use parent 'File::Stamped';

our $VERSION = '0.02';

sub new {
    my $class = shift;

    my %args = @_ == 1 ? %{$_[0]} : @_;
    $args{extra} = '' if !exists $args{extra};

    $class->SUPER::new(%args);
}

sub _gen_filename {
    my $self  = shift;

    my $fname = *$self->{pattern};
    $fname =~ s/(\$+)/sprintf('%0'.length($1).'.'.length($1).'u', $$)/eg;
    if (*$self->{extra}) {
        $fname =~ s/(\!+)/sprintf('%s', *$self->{extra})/eg;
    }
    return POSIX::strftime($fname, localtime());
}

sub extra {
    my ($self, $key) = @_;

    if ($key && $key ne *$self->{extra}) {
        my $fh = delete *$self->{fh};
        close $fh if $fh;
        *$self->{extra} = $key;
    }
}


1;

__END__

=head1 NAME

File::Stamped::Extended - generate date/time/PID/extra-string stamped FH for log file


=head1 SYNOPSIS

    use File::Stamped::Extended;
    my $fh = File::Stamped::Extended->new(pattern => '/var/log/myapp.log.!!.$$.%Y%m%d');
    $fh->print("OK\n");

    # with Log::Minimal
    use Log::Minimal;
    my $fh = File::Stamped::Extended->new(pattern => '/var/log/myapp.log.!!.$$.%Y%m%d');
    local $Log::Minimal::PRINT = sub {
        my ( $time, $type, $message, $trace) = @_;
        $fh->extra($type);
        print {$fh} "$time [$type] $message at $trace\n";
    };


=head1 DESCRIPTION

File::Stamped::Extended is extended FH generater based on L<File::Stamped>.

In addition to the format provided by L<File::Stamped> this module also supports '$' for inserting the PID and '!' for inserting extra-string.


=head1 METHODS

=over 4

=item my $fh = File::Stamped::Extended->new(%args);

This method creates new instance of File::Stamped::Extended. The arguments are same as L<File::Stamped>. Especially, an `extra` option exists only for L<File::Stamped::Extended>.

=over 4

=item extra : Str : default ''

extra value replace `!` in the pattern of stamp.

=back

See L<File::Stamped> for other options about new method.

=item my $fh->extra('warn');

set an `extra` string for inserting the pattern.

NOTE that $fh is closed when you call `extra` method.

=back

=head1 REPOSITORY

File::Stamped::Extended is hosted on github
<http://github.com/bayashi/File-Stamped-Extended>


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<File::Stamped>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
