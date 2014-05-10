test = require 'tape'
concat = require 'concat-stream'
domify = require 'domify'
ndelement = require '../'

write = (stream, objs) ->
  stream.write obj for obj in objs
  stream.end()

clear = ->
  elem = document.querySelector('#content')
  elem.innerHTML = ''
  elem

test 'setup', (t) ->
  document.body.appendChild domify('<div id="content"></div>'); t.end()

test 'basic', (t) ->
  elem = clear()
  stream = ndelement(elem, {container: 'd'})

  stream.pipe concat ->
    t.same elem.innerHTML, '<div d="0"><div d="0"><div d="1"><div data-point="0,0,1">a</div></div><div d="2"><div data-point="0,0,2">b</div></div></div><div d="1"><div d="3"><div data-point="0,1,3">d</div></div></div></div><div d="2"><div d="0"><div d="2"><div data-point="2,0,2">c</div></div></div></div>'
    t.end()

  write stream, [
    '<div data-point="0,0,1">a</div>'
    '<div data-point="0,0,2">b</div>'
    '<div data-point="2,0,2">c</div>'
    '<div data-point="0,1,3">d</div>'
  ]

test 'overwrites elements with ids', (t) ->
  elem = clear()
  stream = ndelement(elem, {container: 'd'})

  stream.pipe concat ->
    t.same elem.innerHTML, '<div d="0"><div d="0"><div d="1"><div id="a" data-point="0,0,1">c</div></div></div></div>'
    t.end()

  write stream, [
    '<div id="a" data-point="0,0,1">a</div>'
    '<div id="a" data-point="0,0,1">b</div>'
    '<div id="a" data-point="0,0,1">c</div>'
  ]

test 'removes empty nodes', (t) ->
  elem = clear()
  stream = ndelement(elem)

  stream.pipe concat ->
    t.same elem.innerHTML, '<div data-container="0"><div data-container="0"><div data-container="1"><div id="a" data-point="0,0,1">c</div></div></div></div>'
    t.end()

  write stream, [
    '<div id="a" data-point="0,0,2">a</div>'
    '<div id="a" data-point="2,9,3">b</div>'
    '<div id="a" data-point="0,0,1">c</div>'
  ]
