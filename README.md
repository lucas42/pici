# pici
Continuous Integration Environment for Raspberry Pi

## Rationale
Circle CI doesn't support arm architectures for building containers on (like a raspberry pi).  This repo creates a container which can be run on an arm machine, then CI jobs can ssh in and run their build commands.

## Limitations
Host ssh keys are generated on startup, therefore won't persist between restarts.  Therefore any reference to these keys in CI config (eg `known-hosts`) must not be static.

## Client ssh key
The public key for the docker-deploy user is hardcoded into the Dockerfile config here.  In order to use it, you need to add the corresponding private key to the CI job which is trying to log into it.
Hopefully I've remembered to download this key locally to my laptop this time.  But if not, it can be retrieved using the "retry with SSH" option in circleCI on a project which already has the key associated with it.

## CI
This repo relies on a running copy of itself in order to build.  When it works, that's marvellous.  If it manages to break, it's a world of pain trying to fix.  You may need to manually do all the steps from the Dockerfile on the host you're trying to run it on (or one with the same architecture).