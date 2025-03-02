#!/usr/bin/env bats

#
# Verify running a fluentd container inside a sys container
#

load ../../helpers/run
load ../../helpers/docker
load ../../helpers/sysbox-health

function teardown() {
  sysbox_log_check
}

@test "rpm in redhat container" {

   local syscont=$(docker_run --rm registry.access.redhat.com/ubi8/ubi:8.2-347 tail -f /dev/null)

   docker exec "$syscont" sh -c "dnf install filesystem -y --downloadonly"
   [ "$status" -eq 0 ]

   docker exec "$syscont" sh -c "rpm -Uvh /var/cache/dnf/ubi-8-baseos-53c30a88cff3796c/packages/filesystem-3.8-6.el8.x86_64.rpm --force"
   [ "$status" -eq 0 ]

   docker_stop "$syscont"
}
