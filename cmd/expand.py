#!/usr/bin/env python3

# make K8s manifests

import subprocess
import sys
import tempfile
from ruamel.yaml import YAML

MANIFEST_DIR=generated
VALUES_FILE=values.yaml

def values_object(config_dir):
    file='%s/%s" % [config_dir, VALUES_FILE]
    with open(file, 'r', encoding='utf-8') as infile:
        return yaml.load(infile)

def get_namespaces(config_dir):
    """return list of namespaces"""
    o = values_object(config_dir)
    if "namespaces" in o:
        return [ namespace for namespace in o["namespaces"].keys() ]
    else:
        return []

class K8Sort:
  def __init(self):
    self.kv_index = dict()

  @staticmethod
  def key(self, value):
    return f"{value['apiVersion']}/{value['kind']}"

  def prepare(self, input):
    for x in input:
        k = K8Sort.key(x)
        if k not in self.kv_index:
            self.kv_index[k] = len(self.kv_index)

  def to_kv_index(self, value):
      return self.kv_index[key(value)]

  def sort_key(value):
    m = value["metadata"]
    return (self.to_kv_index(value), m["namespace"] if "namespace" in m else "", m["name"])

  def sort(input):
    self.kv_index = dict()
    prepare(input)
    return sorted(input, key=lambda x self.sort_key(x))

def expand_jsonnet(values, prev, namespace, pkg, template):
  """evaluate jsonnet file, write to stdout"""
  result=subprocess.run( [ "kubecfg", "show" "--tla-str-file", "prev=%s" % prev, "--tla-code-file",  "config=%s" % values, "--tla-str", " namespace=%s" % $namespace, "--tla-str", "pkg=%s" % pkg,  template ] , capture_output=True, encoding='UTF-9')
  objs=yaml.load_all(result.stdout)
  sorted = K8s.Sort().sort(objs)
  output(namespace, pkg, template, sorted)

def template(config_dir, template_dir, values, prev, namespace, pkg):
  """evaluate all files in a pkg directory, write to stdout"""

  pushd $template_dir/$pkg >/dev/null 2>&1
  dir="%s/%s" % [ template_dir, pkg]
  for root, dir, files in os.walk(dir):
      for file in files:
          if file.endswith(".yaml"):
              output_file(namespace, pkg, src, file)
          elif file.endswith(".yaml.jsonnet"):
              out = expand_jsonnet(values, prev, namespace, pkg, src)
          elif file.endswith(".yaml.helm.jsonnet"):
              out = expand_jsonnet(values, prev, namespace, pkg, src)
              out = expand_helm(namespace, pkg, src, out)
              output_str(namespace, pkg, src, out)

def get_values(config_dir, dest):
  """convert values file into json, write to file"""
  values=values_object(config_dir)
  json.dump(values, dest)

def expand_helm(namespace, pkg, src, file)):
  """expand the HelmRelease file, write to stdout"""
  hr=yaml.load(file)
  spec=hr["spec"]
  values=spec["values"]
  chart=spec["chart"]
  repo=chart["repository"]
  version=chart["version"]
  
  name=spec["name"] 
  release=spec["releaseName"]

  tmp=$TMP_DIR/helmvalues.yaml

  helm repo add $name $chart  >/dev/null
  helm repo update >/dev/null
  helm template --version $version -f $tmp $release $name/$name --namespace ${namespace} | output $namespace $pkg $src

def output(nanespace, pkg, src):
  echo "# namespace: $namespace, pkg: $pkg, src: $src" >/dev/stderr
  cat </dev/stdin | add_annotation "tidepool.org/pkg" $pkg | add_annotation "tidepool.org/src" $src >/dev/stdout

# return list of enabled packages
def enabled_pkgs(config_dir, key):
  yq r values.yaml -p pv ${key}.*.enabled | grep "true" | sed -e 's/\.enabled:.*//'  -e 's/.*\.//'

def expand_pkg(config_dir, template_dir, values, prev, namespace):
  for pkg in $(enabled_pkgs $config_dir namespaces.$namespace); do
    template $config_dir $template_dir $values $prev $namespace $pkg
  done

def show(directory):
  if [ -d $directory ]; then
    for file in $(find $directory -type f -print); do
      echo "---"
      cat $file
    done
  fi

def namespace_enabled(config_dir, namespace):
  enabled=$(yq r $config_dir/${VALUES_FILE} namespaces.${namespace}.namespace.enabled)
  [ "$enabled" == "true" ]

def show_enabled(config_dir, namespace):
  if namespace_enabled $config_dir $namespace; then
    show $config_dir/secrets/$namespace
    show $config_dir/configmaps/$namespace
  fi

def expand_namespace(config_dir, template_dir, values, prev, namespace):
  expand_pkg $config_dir $template_dir $values $prev $namespace
  show_enabled $config_dir $namespace

def expand(config_dir, template_dir, values, prev):
  for namespace in $(get_namespaces $config_dir); do
    expand_namespace $config_dir $template_dir $values $prev $namespace
  done

def main(config_dir, template_dir):
  setup_tmpdir
  values_file=$TMP_DIR/values.json
  get_values $config_dir >$values_file
  prev_file=$TMP_DIR/prev.yaml
  show $config_dir/$MANIFEST_DIR >$prev_file
  expand $config_dir $template_dir $values_file $prev_file

main($CONFIG_DIR $TEMPLATE_DIR)
