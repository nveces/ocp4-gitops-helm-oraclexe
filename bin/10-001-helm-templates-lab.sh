#!/bin/bash
#
# ============================================================
#
#
# ============================================================
# Description---:
#
#
# ============================================================
#
# chmod 774 *.sh
#
#
# EOH

set -euo pipefail
#set -uo pipefail

# Step 1: Set current DIR and default variables:
V_ADMIN_DIR=$(dirname $0)
PREFIX_PRJ=lab
${V_ADMIN_DIR}/10-000-helm-template.sh -e ${PREFIX_PRJ} \
    -o ${V_ADMIN_DIR}/../target/${PREFIX_PRJ}-output


exit 0
#
# EOF