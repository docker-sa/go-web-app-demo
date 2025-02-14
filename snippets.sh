#!/bin/bash
docker run \
    -v $(pwd)/code/snippets:/code/snippets \
    --rm botsgarden/snippets:0.0.1  \
    ./snippets generate \
    --input code/snippets/docker.yml \
    --output code/snippets/docker.code-snippets 