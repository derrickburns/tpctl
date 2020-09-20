#!/bin/bash
PKG_SOURCE=${PKG_SOURCE:-vendor}
pkgs=$(find $PKG_SOURCE -print)
echo "local kubecfg = import 'kubecfg.libsonnet';"
echo "{"
echo "  \"_source\":  \"$PKG_SOURCE\","
for pkg in $pkgs
do
	x=${pkg/${PKG_SOURCE}\//}
  if [[ $x == *".yaml" ]]; then
	  echo "  \"$x\": kubecfg.parseYaml(importstr \"$x\"),"
  elif [[ $x == *"yaml.jsonnet" ]]; then
	  echo "  \"$x\":: import \"$x\","
  elif [[ $x == *"yaml.helm.jsonnet" ]]; then
	  echo "  \"$x\":: import \"$x\","
  elif [[ $x == *"policy.jsonnet" ]]; then
	  echo "  \"$x\":: import \"$x\","
  fi
done
echo "}"
