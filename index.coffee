through = require 'through2'
domify = require 'domify'

_count = 0

module.exports = (elem, opts = {}) ->
  opts.point or= 'data-point'
  opts.container or= 'data-container'
  opts.tag or= 'div'
  opts.id = opts.id or elem.getAttribute('id') or "nd-element-#{_count++}"

  # need id for > selector
  elem.setAttribute 'id', opts.id

  cmp = (a, b) ->
    ka = parseInt a.getAttribute(opts.container), 10
    kb = parseInt b.getAttribute(opts.container), 10
    if ka < kb then -1 else 1

  through.obj (chunk, enc, cb) ->
    el = domify(chunk)

    return cb() unless steps = el.getAttribute(opts.point)

    search = elem
    steps = steps.split(',')

    if id = el.getAttribute('id')
      if found = elem.querySelector('#'+id)
        parent = found.parentNode
        parent.removeChild found
        clear(elem, parent)

    str = '#' + opts.id
    for step in steps
      str += "> [#{opts.container}=\"#{step}\"]"

      match = search.querySelector(str)

      if match is null
        match = domify("<#{opts.tag} #{opts.container}=\"#{step}\"></#{opts.tag}>")
        search.appendChild match

      sorted = [].slice.call(search.children)
      sorted.sort cmp

      for child, i in sorted
        continue if child is search.childNodes[i]
        search.removeChild child
        search.insertBefore child, search.childNodes[i]

      search = match
    search.appendChild(el)
    @push chunk
    cb()

clear = (base, el) ->
  return if base is el # don't ax the root element
  return unless el?.innerHTML is ''
  parent = el.parentNode
  parent.removeChild el
  clear(base, parent)
