
sigmatch = require "sigmatch"
_G = (createElement,isValidElement) -> sigmatch (match)->
  match ".", (tagName)-> createElement tagName
  match ".,s", (tagName,text) -> createElement tagName, null, text
  match ".,o", (tagName,obj) ->
    if isValidElement obj
      createElement tagName, null, obj
    else
      createElement tagName, obj
  match ".,o?,a", (tagName, attributes, children) -> createElement tagName, attributes, children...
  match ".,o?,.", (tagName, attributes, child) -> createElement tagName, attributes, child
  match ".*", (args...) -> throw new Error("cannot handle args #{args}")


_define =(createElement, isValidElement) -> (target, tagName)->
  target[tagName] = sigmatch (match)->
    match "", -> createElement tagName
    match "s", (text) -> createElement tagName, null, text
    match "o", (obj) ->
      if isValidElement obj
        createElement tagName, null, obj
      else
        createElement tagName, obj
    match "o?,a", (attributes, children)-> createElement tagName, attributes, children...
    match "o,o+", (attributes, children)-> createElement tagName, attributes, children...
    match ".*", (args...) -> throw new Error("cannot handle args #{args}")

module.exports = ({builtins=[],createElement, isValidElement}) ->
  define = _define(createElement, isValidElement)
  dsl = G: _G createElement, isValidElement
  define dsl, tagName for tagName in builtins
  dsl

