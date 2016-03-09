
# Export ocaml lib as js module

This is example project to experiment with exporting ocaml lib as js package.

It starts with simple `exports` object, but the plan is to explore smth like [CommonML](https://github.com/jordwalke/CommonML).

It uses [ppx_jsobject_conv](https://github.com/little-arhat/ppx_jsobject_conv) to generate conversion between ocaml and javascript values.

# Testing

Manual testing currently: build the project with `make` and then run `node`:

```
> var core = require('./resorces/js/core.js')
> core.tval
[1, 'test', 10]
> core.test_raise()
Error: test
```
