# greek

An idiomatic / DSL-based alternative to using JSX

## Disclaimer

If you are new to react, I heavily recommend using JSX. There is great
documentation, almost all examples you will find online are using jsx.  Using
`greek` when you are still trying to grasp what React is all about will only
add to your confusion and frustrate you.  I know, because I made that very
mistake myself. :-)

Also, as you may have guessed from the pre-1.0 version number: things my change
in all kinds of incompatible ways. I am still experimenting with this.

## Install

The usual `npm install greek` should do.

## Usage

```coffee
DSL = require "greek"
{div, h3, ul, li} = DSL
  builtins:Object.keys(React.DOM)
  createElement:React.createElement
  isValidElement:React.isValidElement

MyCustomComponent = React.createFactory require "my-custom-component"

renderSomething = ->
  div className: "example",
    h3 "Have a list:"
    ul [
      li "first item"
      li "second item"
    ]
    MyCustomComponent foo: bar / 2
```

## My motivation for doing this

There is -- at least in my opinion -- nothing wrong with JSX. In particular, if
you are a happy ES6 user, stick with the [Babel
transpiler](http://babeljs.io/), it should cover pretty much all you will ever
need and more.

I prefer CoffeeScript over Javascript. I know there are a couple of attempts of
doing something like JSX with Coffeescript, but then again: why?
After all, JSX compiles down to simple javascript. If you play around with the
[Babel "REPL"](http://babeljs.io/repl/), you can see that the stuff that looks
like HTML simply translates to an isomorphic structure of nested calls to
`React.createElement`. It is quite readable, even in Javascript, and even more
so if you use some short-hand name instead of `React.createElement`. 
I used `E` here:

```javascript
E("div", { className: "example" },
  E("h3", null,"Have a list:"),
  E("ul",null,
    E("li",null,"first item"),
    E("li",null,"second item")
  ),
  E(MyCustomComponent, { foo: bar / 2 })
);
```

Or, using coffeescript:

```coffee
E "div", className: "example",
  E "h3", null, "Have a list:"
  E "ul", null,
    E "li", null, "first item"
    E "li", null, "second item"
  E MyCustomComponent, foo: bar / 2
```

This is not bad, but we can do better. 

-   Is it really necessary to use string literals?

-   Maybe we can get rid of the `E` functor?

-   Having to write `null` if there are no attributes kinda sucks.
    Surely there is another way?

Clearly, we need to do some meta-programming. For all the standard HTML elements
we can predefine functions that behave like partially evaluated versions of
`React.createElement`. And this is basically what the `greek` does.



## Rough Edges and Limitations

The above example basically show what the `greek` module does right now.  I
like it, but it is not perfect.

### VarArgs-Syntax for children

If you look closely at the above example you may realize something odd: Both,
the `div`-node aswell as the `ul`-node have more than one children.  In the
first it is possible to use a vararg notation, but in the latter we need to
enclose the children in an array. This is due to a somewhat odd property of the
coffeescript syntax. (Or at least _I_ think it's a bit odd, there may be
reasons for implementing it this way). Most unfortunately, if you leave the
square brackets away the whole thing still gets parsed by coffeescript, but not
the way you want: the `li`-nodes become sibblings of the `ul` instead of
children. This can be avoided by enclosing the `li`s with parentheses, but
clearly, this is a problem. It is very easy to get this wrong.  I therefor
think it would be best to drop the support for varargs altogeteher. But I
haven't completely decided yet.

### Custom-Components require special treatment

In the above example, we cannot simply use the custom component, but instead we
need to wrap it using `React.createFactory`. This makes sense, if you think
about how the construction and rendering of the virtual dom works. In the
"normal" case, `React.createElement` takes care of this; note how the component
_is not_ called directly but instead given to `React.createElement`.  This must
work a bit different in our case, since we decided to remove the
`React.createElement` functor from our DSL in the first place.

It is not that bad once you realize what is going on.  But when you are new to
React, this is _very_ confusing, and it gets even worse if you are are working
with higher order components. 

## Since 0.2.x: the "unfancy" API

Mostly due to the two abovementioned problems, I started experimenting with
a compromise: It re-introduces an extra functor similar to`createElement`
and only adds some sugar that allows us to ommit the ugly `null` when there
are no attributes. This buys us some convenience when dealing with custom components:
we do not have to wrap them with `createFactory` first.

Another thing that is different: the syntax for children is less lenient.
When there is more than one child it *must* be put into an array.

## Breaking Changes in 0.2

I mentioned this is pre 1.0, right?
Since the 0.1.x versions, I had a look at a couple of other UI libraries
besides react that also use a virtual dom. It seems that most use very similar
APIs to create virtual dom trees. I decided I do not want this module to depend
on react. So now to use the Greek DSL, you need tell it how to use your UI library.
See example at the top.

## Previous Work

I started work on this after reading the following blog posts:

-   <http://blog.vjeux.com/2013/javascript/react-coffeescript.html>

-   <https://medium.com/tictail/replacing-jsx-with-vanilla-coffeescript-4d3ef5eccae4#.rg6cjkfvm>

The author of the second one created the module 
[`react-coffee-elements`](https://github.com/kalasjocke/react-coffee-elements)
which works very similar to mine. But I had to try it myself to realize this.
