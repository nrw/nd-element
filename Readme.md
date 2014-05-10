# nd-element

Stream in dom elements or html strings to add and update them as a nested
multidimensional array.

[![testling badge](https://ci.testling.com/nrw/nd-element.png)](https://ci.testling.com/nrw/nd-element)

Bundle this module with [browserify](http://browserify.org/).

## Example

```js
var ndElement = require('nd-element');
var target = document.querySelector('#content');
var n = ndElement(target);

var docs = [
  '<div data-point="0,0,1">a</div>',
  '<div data-point="0,0,2">b</div>',
  '<div data-point="2,0,2">c</div>',
  '<div data-point="0,1,3">d</div>'
]

docs.forEach(function (doc) { n.write(doc) });
```

The `#content` element will now contain this html structure (without the extra
  whitespace added here for legibility):

```html
<div data-container="0">
  <div data-container="0">
    <div data-container="1">
      <div data-point="0,0,1">a</div>
    </div>
    <div data-container="2">
      <div data-point="0,0,2">b</div>
    </div>
  </div>
  <div data-container="1">
    <div data-container="3">
      <div data-point="0,1,3">d</div>
    </div>
  </div>
</div>
<div data-container="2">
  <div data-container="0">
    <div data-container="2">
      <div data-point="2,0,2">c</div>
    </div>
  </div>
</div>
```

## Usage

### var n = ndElement(element, opts={})

Returns a new `nd-element` writable stream. Write html strings or html elements
with a comma-separated n-dimensional point path in `data-point` attribute. The
provided `element` will be modified to create the n-dimensional structure
required by the `data-point` path.

### options

- `opts.point = 'data-point'` the attribute that contains the point path
- `opts.container = 'data-container'` the attribute for container indexes
- `opts.tag = 'div'` the tag to use for containers
- `opts.id = element.id || 'nd-element-'+n` the id of the base element (the base
  element must have an id set for the `>` selector this module uses)

## Notes

You can use [`nd-point`](https://github.com/nrw/nd-point) to find a
multidimensional point for objects based on their properties.

## Contributing

Please make any changes to the `.coffee` source files and `npm build` before
sending a pull request.

## License

MIT
