package Collectd::Graphs::Roles::RRDGraphs;

use 5.014;
use strict;
use warnings FATAL => 'all';

our $VERSION = "0.001";

use Moo::Role;
use MooX::Options;
use MooX::Roles::Pluggable search_path => __PACKAGE__;

option image_dir => (
    is     => "lazy",
    doc    => "",
    format => "s",
    isa    => sub { -d $_[0] or die "No such directory: $_[0]" }
);

sub _build_image_dir { "." }

my %image_type2ext = (
    PNG => ".png",
    SVG => ".svg",
);

option image_type => (
    is     => "lazy",
    doc    => "",
    format => "s",
    isa    => sub {
        defined $image_type2ext{ $_[0] } or die "Unsupported type, only " . join( ", ", map { "'$_'" } keys %image_extension );
    },
);

sub _build_image_type { "PNG" }

option image_extension => (
    is     => "lazy",
    doc    => "",
    format => "s",
);

sub _build_image_extension { $image_type2ext{ $_[0]->image_type } }

=head2 create_graph($span)

Creates a graph for given span for all found rrd's

Returns hash of

=cut

sub create_graph
{
    my $self = shift;
    my $span = shift;
    ...;
}

1;
