#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'tilt' feature with no options.
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "tilt": {}
#    }
# }
#
# Thus, the value of all options,
# will fall back to the default value in the feature's 'devcontainer-feature.json'
#
# This test can be run with the following command (from the root of this repo)
#    devcontainer features test \
#               --features tilt \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "version" tilt version | grep 'v0.33.4'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
