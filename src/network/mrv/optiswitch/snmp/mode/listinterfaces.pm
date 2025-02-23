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

package network::mrv::optiswitch::snmp::mode::listinterfaces;

use base qw(snmp_standard::mode::listinterfaces);

use strict;
use warnings;

sub set_oids_status {
    my ($self, %options) = @_;
    
    $self->{oid_linkstatus} = '.1.3.6.1.4.1.6926.2.1.2.1.5';
    $self->{oid_linkstatus_mapping} = {
        1 => 'true', 2 => 'false',
    };
    $self->{oid_adminstatus} = '.1.3.6.1.4.1.6926.2.1.2.1.10';
    $self->{oid_adminstatus_mapping} = {
        1 => 'other', 2 => 'enable', 3 => 'disableByMgmt',
    };
    $self->{oid_opstatus} = '.1.3.6.1.4.1.6926.2.1.2.1.11';
    $self->{oid_opstatus_mapping} = {
        1 => 'other', 2 => 'enabled', 3 => 'disabledByMgmt', 4 => 'disabledByReboot', 5 => 'isolatedByLinkFlapGuard',
        6 => 'isolatedByLinkReflection', 7 => 'isolatedByLinkProtection', 8 => 'isolatedByStpLinkReflection',
        9 => 'isolatedByHotSwap', 10 => 'isolatedByHa', 11 => 'isolatedByStpPortLoop', 12 => 'isolatedByStpOverRate',
        13 => 'isolatedByEthoamOverRate', 14 => 'isolatedByEfmOverRate', 15 => 'isolatedByDot1xOverRate',
        16 => 'isolatedByDot1agOverRate', 17 => 'isolatedByLacpOverRate', 18 => 'isolatedByAhOverRate',
        19 => 'isolatedByUdld', 20 => 'isolatedByShdslLinkDown',
    };
}

my $oid_speed64 = '.1.3.6.1.4.1.6926.2.1.2.1.7';

sub is_admin_status_down {
    my ($self, %options) = @_;
    
    if (defined($self->{option_results}->{use_adminstatus}) && defined($options{admin_status}) && 
        $self->{oid_adminstatus_mapping}->{$options{admin_status}} ne 'enabled') {
        return 1;
    }
    return 0;
}

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    
    bless $self, $class;    
    return $self;
}

1;

__END__

=head1 MODE

=over 8

=item B<--interface>

Set the interface (number expected) ex: 1,2,... (empty means 'check all interfaces').

=item B<--name>

Allows you to define the interface (in option --interface) by name instead of OID index. The name matching mode supports regular expressions.

=item B<--speed>

Set interface speed (in Mb).

=item B<--skip-speed0>

Don't display interface with speed 0.

=item B<--filter-status>

Display interfaces matching the filter (example: 'enabled').

=item B<--use-adminstatus>

Display interfaces with AdminStatus 'enabled'.

=item B<--oid-filter>

Define the OID to be used to filter interfaces (default: atrConnCepGenDescr) (values: atrConnIngDescr, atrConnCepGenDescr).

=item B<--oid-display>

Define the OID that will be used to name the interfaces (default: atrConnCepGenDescr) (values: atrConnIngDescr, atrConnCepGenDescr).

=item B<--display-transform-src> B<--display-transform-dst>

Modify the interface name displayed by using a regular expression.

Eg: adding --display-transform-src='eth' --display-transform-dst='ens'  will replace all occurrences of 'eth' with 'ens'

=item B<--add-extra-oid>

Display an OID. Example: --add-extra-oid='alias,.1.3.6.1.2.1.31.1.1.1.18'

=back

=cut
