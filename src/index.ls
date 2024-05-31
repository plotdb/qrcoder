qrcoder = (o={}) ->
  @_o = {
    size: 256, type-number: 4
    correct-level: QRErrorCorrectLevel.H
  } <<< o
  @

qrcoder.svg = (o = {}) -> qrcoder.make o
qrcoder.make = (o = {}) ->
  text = if typeof(o) == \string => o else o.text or ''
  level = if o.level? => o.level else QRErrorCorrectLevel.H
  obj = new QRCodeModel(_getTypeNumber(text, level), level)
  obj.addData text
  obj.make!
  count = (obj.get-module-count! or 1)
  list = []
  size = o.size or 256
  dim = o.view-box-size or 1000
  _ = (v) -> (v).toFixed(1).replace(/\.0$/,'')
  padding = _(o.padding or 0) * dim
  round = _(o.round or 0) * dim
  delta = (dim - count * padding) / count
  for y from 0 til count => for x from 0 til count =>
    dark = obj.is-dark y, x
    if !dark => continue
    px = _(x * delta + ((x - 1) >? 0) * padding) - 1
    py = _(y * delta + ((y - 1) >? 0) * padding) - 1
    _d = _ delta
    fill = if typeof(o.color) == \function => o.color {x:x/(count - 1), y:y/(count - 1), dark} else null
    fill = if fill => " fill=\"#fill\"" else ''
    color = if !o.color => \#000
    else if typeof(o.color) == \function => 
    else o.color
    list.push """
    <rect x="#px" y="#py"#fill/>
    """
  _fc = if !o.color => \#000 else if typeof(o.color) != \function => o.color else null
  _fc = if _fc => "fill:#_fc" else ''
  svg = """
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 #dim #dim" width="#size" height="#size">
  <style type="text/css">rect {
    width:#{_ delta + 2}px;height:#{_ delta + 2}px;rx:#{_ round}px;ry:#{_ round}px;#_fc
  }</style>
  #{list.join('')}
  </svg>
  """
  return svg

qrcoder.prototype = Object.create(Object.prototype) <<<
  make: (o={}) -> qrcoder.make (if typeof(o) == \string => {text: o} else o) <<< (@_o)
  svg: (o={}) -> @make o

if module? => module.exports = qrcoder
else if window => window.qrcoder = qrcoder
