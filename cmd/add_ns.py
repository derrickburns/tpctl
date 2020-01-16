#!/usr/local/bin/python3

import yaml
import sys

for manifest in yaml.load_all(sys.stdin):
    if manifest:
        if 'metadata' in manifest and 'namespace' not in manifest['metadata']:
            manifest['metadata']['namespace'] = sys.argv[1]
        print('---')
        print(yaml.dump(manifest))
