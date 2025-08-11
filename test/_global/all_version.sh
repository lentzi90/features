#!/bin/bash

# The 'test/_global' folder is a special test folder that is not tied to a single feature.
#
# This test file is executed against a running container constructed
# from the value of 'all_version' in the tests/_global/scenarios.json file.
#
# The value of a scenarios element is any properties available in the 'devcontainer.json'.
# Scenarios are useful for testing specific options in a feature, or to test a combination of features.
#
# This test can be run with the following command (from the root of this repo)
#    devcontainer features test --global-scenarios-only .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "clusterctl version" clusterctl version | grep "v1.10.4"
check "kubeadm version" kubeadm version -o short | grep "v1.33.3"
check "kwok version" kwok --version | grep "v0.5.2"
check "tilt version" tilt version | grep "v0.35.0"
check "yamlfmt version" yamlfmt -version | grep "0.17.2"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
