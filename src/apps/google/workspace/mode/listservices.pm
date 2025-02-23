#
# Copyright 2023 Centreon (http://www.centreon.com/)
#
# Centreon is a full-fledged industry-strength solution that meets
# the needs in IT infrastructure and application monitoring for
# service performance.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package apps::google::workspace::mode::listservices;

use base qw(centreon::plugins::mode);

use strict;
use warnings;

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options, force_new_perfdata => 1);
    bless $self, $class;

    $options{options}->add_options(arguments => {
        'filter-name:s' => { name => 'filter_name' }
    });

    return $self;
}

sub check_options {
    my ($self, %options) = @_;
    $self->SUPER::init(%options);
}

sub manage_selection {
    my ($self, %options) = @_;

    my $results = $options{custom}->get_services();
    my $services = {};
    foreach my $name (keys %$results) {
        next if (defined($self->{option_results}->{filter_name}) && $self->{option_results}->{filter_name} ne ''
            && $name !~ /$self->{option_results}->{filter_name}/);
        $services->{$name} = $name;
    }

    return $services;
}

sub run {
    my ($self, %options) = @_;

    my $services = $self->manage_selection(%options);
    foreach (sort keys %$services) {
        $self->{output}->output_add(
            long_msg => sprintf("[name = %s]", $services->{$_})
        );
    }

    $self->{output}->output_add(severity => 'OK', short_msg => 'Google workspace service:');
    $self->{output}->display(nolabel => 1, force_ignore_perfdata => 1, force_long_output => 1);
    $self->{output}->exit();
}

sub disco_format {
    my ($self, %options) = @_;

    $self->{output}->add_disco_format(elements => ['name']);
}

sub disco_show {
    my ($self, %options) = @_;

    my $services = $self->manage_selection(%options);
    foreach (sort keys %$services) {
        $self->{output}->add_disco_entry(
            name => $services->{$_}
        );
    }
}

1;

__END__

=head1 MODE

List Google Gsuite applications.

=over 8

=item B<--filter-name>

Filter application name (Can be a regexp).

=back

=cut
