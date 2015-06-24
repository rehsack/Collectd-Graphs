package Collectd::Graphs::Roles::RRDGraphs::Nginx;

use 5.014;
use strict;
use warnings FATAL => 'all';

our $VERSION = "0.001";

use Params::Util;
use RRDTool::OO;

use Moo::Role;

around create_graph => sub {
    my $next   = shift;
    my $self   = shift;
    my $result = $self->$next(@_);
    my $span   = shift;
    ...;
};

1;
