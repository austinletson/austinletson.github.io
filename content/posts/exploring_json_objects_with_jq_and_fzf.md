---
title: "Exploring json with jq and fzf"
date: "2025-06-14" 
draft: true
build:
  render: never
  list: never
  publishResources: false
---


```sh
jq -r '.[] | .sorry.repo.remote + "\u0001" + .debug_info.post_processed_response + "\u0000"' proofs.json \
| fzf --read0 --with-nth=1 --delimiter='\x01' \
      --preview 'echo {2}'
```

