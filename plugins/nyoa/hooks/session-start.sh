#!/usr/bin/env sh
# NYOA session-start nudge.
# Surfaces a one-line message only when the working directory has NYOA state
# but profile.md is missing — i.e. the agent has started using NYOA here
# without running /nyoa-setup. Otherwise stays silent so it doesn't pollute
# non-NYOA sessions.

if { [ -d nyoa-context ] || [ -d nyoa-workspace ]; } && [ ! -f nyoa-context/profile.md ]; then
  echo "NYOA: workspace detected here, but nyoa-context/profile.md is missing. Run /nyoa-setup to populate your profile."
fi
