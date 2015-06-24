package Collectd::Graphs::Roles::SourceRRDs;

use 5.014;
use strict;
use warnings FATAL => 'all';

our $VERSION = "0.001";

use File::Basename qw(fileparse);
use File::Find::Rule;
use File::Spec qw();
use List::Util qw(reduce);
use Sys::Hostname qw(hostname);

use Moo::Role;
use MooX::Options;

option source_root => (
    is => "lazy",
    doc => "",
    format => "s",
    isa => sub { -d $_[0] or die "No such directory: $_[0]" }
);

sub _build_source_root { "/var/lib/collectd" }

option source_host => (
    is => "lazy",
    doc => "",
    format => "s",
);

sub _build_source_host { hostname }

option source_dir => (
    is => "lazy",
    doc => "",
    format => "s",
);

sub _build_source_dir
{
    my $self = shift;
    my $dir = $self->source_root;
    -d File::Spec->catdir($dir, "rrd") and $dir = File::Spec->catdir($dir, "rrd");
    File::Spec->catdir($dir, $self->source_host);
}

option source_extension => (
    is => "lazy",
    doc => "",
    format => "s",
    coerce => sub { ("." eq substr $_[0],0,1) or return ".$_[0]"; $_[0] },
);

sub _build_source_extension { ".rrd" }



has source_rrds => (
    is => "lazy",
    doc => "",
    format => "s",
    init_arg => undef,
);

sub _build_source_rrds
{
    my $self = shift;
    my @rrds = File::Find::Rule->file()->relative()->name('*' . $self->source_extension)->in($self->source_dir);
    my %rrds;

    foreach my $rrd (@rrds)
    {
	my ($rrdname, $dirname) = fileparse($rrd, qr/\.[^.]*/);
	$dirname =~ s,/$,,;
	my ($collector, $device) = split '-', $dirname, 2;
	my ($sensor, $item) = split '-', $rrdname, 2;
	$collector eq $sensor and undef $sensor;
	my $dpo = reduce { defined $b ? $a->{$b} //= {} : $a } (\%rrds, $collector, $device, $sensor, $item);
	@{$dpo}{qw(collector device sensor item path)} = ($collector, $device, $sensor, $item, File::Spec->catfile($self->source_dir, $rrd));
    }

    \%rrds;
}

1;
