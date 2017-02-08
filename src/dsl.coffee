
{DOM,createElement, isValidElement} = require "react"
sigmatch = require "sigmatch"

define = (tagName)->
  module.exports[tagName] = sigmatch (match)->
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

define tagName, tagImpl for tagName, tagImpl of DOM
