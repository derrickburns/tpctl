local index(x) =
  if std.endsWith(x, "]") 
  then std.parseInt(std.substr(x,0, std.length(x)-1))
  else x;

local parts(x) = std.map(index, std.flattenArrays([ std.split(y, '.') for y in std.split(x, '[') ]));

local lookup(x, y) =
  if x == null then null
  else if y == '' then x
  else if std.isNumber(y) && std.isArray(x) && std.length(x) > y && y >= 0 then x[y]
  else if std.isString(y) && std.isObject(x) && std.objectHasAll(x, y) then x[y]
  else null;
  
{
  isEnabled(x):: $.isTrue(x, 'enabled'),

  E(me, val):: if $.isEnabled(me) then val else null,

  isEnabledAt(x, prop):: $.isTrue(x, prop + '.enabled'),

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

  get(init, pattern):: std.foldl(lookup, parts(pattern), init),

  getElse(x, path, default):: (
    local found = $.get(x, path);
    if found == null then default else found
  ),

  isEq(x, path, y):: $.get(x, path) == y,

  isTrue(x, path):: $.isEq(x, path, true) || $.isEq(x, path, 'true'),

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

  withKeyAsField(o, as):: std.mapWithKey(function(name, val) val + if std.objectHas(o, as) then o else {[as]: name}, o),

  asArrayWithField(o, as):: $.values( $.withKeyAsField(o,as) ),

}
