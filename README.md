# pici
Continuous Integration Environment for Raspberry Pi

## Rationale
Circle CI doesn't support arm architectures for building containers on (like a raspberry pi).  This repo creates a container which can be run on an arm machine, then CI jobs can ssh in and run their build commands.

## Limitations
ssh-keys are generated on startup, therefore won't persist between restarts.  Therefore any reference to keys in CI config (eg `known-hosts`) must not be static.