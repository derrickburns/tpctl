#!/usr/bin/env bash
PKG_SOURCE=${PKG_SOURCE:-vendor}
pkgs=$(find $PKG_SOURCE -print)
echo "local kubecfg = import 'kubecfg.libsonnet';"
echo "{"
echo "  \"_source\":  \"$PKG_SOURCE\","
for pkg in $pkgs
do
	x=${pkg/${PKG_SOURCE}\//}
  if [[ $x == *".yaml" ]]; then
	  target=${pkg/\.yaml/\.jsonnet}
	  yq r $pkg -j | jq | jsonnetfmt - >$target
	  #echo "  \"$x\": kubecfg.parseYaml(importstr \"$x\"),"
	  echo "  \"$x\":: import \"${target/{PKG_SOURCE}\//\","
  elif [[ $x == *"yaml.jsonnet" ]]; then
	  echo "  \"$x\":: import \"$x\","
  elif [[ $x == *"yaml.helm.jsonnet" ]]; then
	  echo "  \"$x\":: import \"$x\","
  elif [[ $x == *"policy.jsonnet" ]]; then
	  echo "  \"$x\":: import \"$x\","
  fi
done
echo "}"
