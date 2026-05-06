#!/usr/bin/env sh
# NYOA session-start nudge.
# Surfaces a one-line message only when the working directory has NYOA state
# that needs attention. Otherwise stays silent so it doesn't pollute
# non-NYOA sessions.
#
# Rules:
#   - POSIX shell only. No bashisms (no [[, no local, no arrays, no pipefail).
#   - Use grep for version checks (never assume jq is installed).
#   - Stay silent if detection is ambiguous.
#   - Never print unconditionally.

# Check 1: NYOA state detected but profile.md is missing.
# This means the agent has started using NYOA here without running /nyoa-setup.
if { [ -d nyoa-context ] || [ -d nyoa-workspace ]; } && [ ! -f nyoa-context/profile.md ]; then
  echo "NYOA: workspace detected here, but nyoa-context/profile.md is missing. Run /nyoa-setup to populate your profile."
fi

# Check 2: _meta.json exists but schema_version is not 0.6.0 (stale v0.5.x workspace).
# grep -q returns 0 (success) if the pattern matches. If it returns non-zero,
# either the file doesn't have schema_version 0.6.0 or the file is absent.
# We only nudge when _meta.json is present AND the version is stale.
if [ -f nyoa-context/_meta.json ]; then
  if ! grep -q '"schema_version".*"0.6.0"' nyoa-context/_meta.json; then
    echo "NYOA: your workspace predates v0.6.0. Run /nyoa-setup migrate to upgrade — non-destructive, under a minute."
  fi
fi
