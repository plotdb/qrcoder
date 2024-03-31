require! <[ldcolor]>
qrcoder = require '../dist/index.js'

ret = qrcoder.make {
  text: 'hello world'
  color: ({x, y}) -> ldcolor.web {r: x * 256, g: y * 256, b: 0}
}

console.log ret
