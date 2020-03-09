{
  isEnabled(x):: $.isTrue(x, 'enabled'),

  withDefault(obj, field, default)::
    if obj == null || std.objectHas(obj, field)
    then obj
    else obj { [field]: default },

  // add a default name to an object if it does not have one
  withName(obj, default):: $.withDefault(obj, 'name', default),

  // add a default namespace to an object if it does not have one
  withNamespace(obj, default):: $.withDefault(obj, 'namespace', default),

  // add namespace field to each object under a map if it does not already have one
  addNamespace(map, ns):: std.mapWithKey(function(n, v) $.withNamespace(v, ns), map),

  // add a name field to each entry of a map, where the name is the key
  addName(map):: std.mapWithKey(function(n, v) $.withName(v, n), map),

  matches(labels, selector)::
    std.foldl(function(a, b) a && b, [$.getElse(labels, x, false) == selector[x] for x in std.objectFields(selector)], true),

  contains(list, value):: std.foldl(function(a, b) (a || (b == value)), list, false),

  pruneList(list):: std.foldl(function(a, b) if b == null || b == {} then a else a + [b], list, []),

  // return a list of the fields of the object given
  values(obj):: [obj[field] for field in std.objectFields(obj)],

  // return a clone without the given field
  ignore(x, exclude):: { [f]: x[f] for f in std.objectFieldsAll(x) if f != exclude },

  present(x, path):: $.get(x, path) != null,

  manifestJsonFields(obj):: {
    [k]: std.manifestJson(obj[k])
    for k in std.objectFields(obj)
  },

  remapKey(x, remap, key='resources')::
    if $.present(x, key)
    then { [key]+: std.mapWithKey(remap, x[key]) }
    else {},

  get(x, path, sep='.'):: (
    local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
    std.foldl(foldFunc, std.split(path, sep), x)
  ),

  getElse(x, path, default):: (
    local found = $.get(x, path);
    if found == null then default else found
  ),

  isEq(x, path, y):: $.get(x, path) == y,

  isTrue(x, path):: $.isEq(x, path, true) || $.isEq(x, path, "true"),

  mergeList(list):: std.foldl($.merge, list, {}),

  // merge two objects recursively, choose b for non-object parameters
  merge(a, b)::
    if (std.isObject(a) && std.isObject(b))
    then (
      {
        [x]: a[x]
        for x in std.objectFieldsAll(a)
        if !std.objectHas(b, x)
      } + {
        [x]: b[x]
        for x in std.objectFieldsAll(b)
        if !std.objectHas(a, x)
      } + {
        [x]: $.merge(a[x], b[x])
        for x in std.objectFieldsAll(b)
        if std.objectHas(a, x)
      }
    )
    else b,

  // strip the object of any field or subfield whose name is in given list
  strip(obj, list)::
    { [k]: obj[k] for k in std.objectFieldsAll(obj) if !$.contains(list, k) && !std.isObject(obj[k]) } +
    { [k]: $.strip(obj[k], list) for k in std.objectFieldsAll(obj) if !$.contains(list, k) && std.isObject(obj[k]) },

  isUpper(c):: (
    local cp = std.codepoint(c);
    cp >= 65 && cp <= 90
  ),

  capitalize(word):: (
    assert std.isString(word) : 'can only capitalize string';
    assert std.length(word) > 0 : 'cannot capitalize empty string';
    local chars = std.stringChars(word);
    std.asciiUpper(chars[0]) + std.foldl(function(a, b) a + b, chars[1:std.length(chars)], '')
  ),

  kebabCase(camelCaseWord):: (
    local merge(a, b) = {
      local isUpper = $.isUpper(b),
      word: (if (isUpper && !a.wasUpper) then '%s-%s' else '%s%s') % [a.word, std.asciiLower(b)],
      wasUpper: isUpper,
    };
    std.foldl(merge, std.stringChars(camelCaseWord), { word: '', wasUpper: true }).word
  ),

  camelCase(kebabCaseWord, initialUpper=false):: (
    local merge(a, b) = {
      local isHyphen = (b == '-'),
      word: if isHyphen then a.word else a.word + (if a.toUpper then std.asciiUpper(b) else b),
      toUpper: isHyphen,
    };
    std.foldl(merge, std.stringChars(kebabCaseWord), { word: '', toUpper: initialUpper }).word
  ),

  pascalCase(kebabCaseWord):: $.camelCase(kebabCaseWord, true),
}
