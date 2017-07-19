describe "The unfancy DSL", ->
  DSL = require "../src/dsl"
  ReactDomServer = require "react-dom/server"
  React = require "react"

  {G} = DSL builtins:Object.keys(React.DOM), createElement:React.createElement, isValidElement:React.isValidElement
  render = (element)-> ReactDomServer.renderToStaticMarkup element
    
  it "can represent elements with a single child and no attributes", ->
    element = G "div", G "ul", G "li", "Hello World!"
    expect(render element).to.eql "<div><ul><li>Hello World!</li></ul></div>"

  it "can represent elements with a single child and attributes", ->
    element = G "div", id:"div-42", className: "sonderklasse", G "ul", G "li", "w00t?"
    expect(render element).to.eql '<div id="div-42" class="sonderklasse"><ul><li>w00t?</li></ul></div>'

  it "can represent elements with without children or attributes",->
    expect(render G "br").to.eql '<br/>'

  it "can represent elements with children but no attributes", ->
    element = G "div", [
      G "h1", "tag"
      G "p", "Ein schöner Tag"
    ]
    expect(render element).to.eql '<div><h1>tag</h1><p>Ein schöner Tag</p></div>'

  it "can represent elements with attributes but no children", ->
    element = G "div", className: "spitzenklasse"
    expect(render element).to.eql '<div class="spitzenklasse"></div>'

  it "can represent elements with attributes and children", ->
    element = G "div", id:"div-42", className: "test", [
                G "h1", "tag"
                G "p", "Ein schöner Tag"
              ]
    expect(render element).to.eql '<div id="div-42" class="test"><h1>tag</h1><p>Ein schöner Tag</p></div>'

  it "works with components created via React.createClass", ->
    Foo = React.createClass render: -> G "h1", "Works #{@props.how}!"
    expect(render G "div", G Foo, how:"great").to.eql '<div><h1>Works great!</h1></div>'
    expect(render G Foo, how:"great").to.eql '<h1>Works great!</h1>'


  
  it "works with components that are instances of React.Component",->
    class Foo extends React.Component
      render: -> G "h1", "Works #{@props.how}!"
    expect(render G "div", G Foo, how:"great").to.eql '<div><h1>Works great!</h1></div>'
    expect(render G Foo, how:"great").to.eql '<h1>Works great!</h1>'

  it "works with 'pure functional' components", ->
    Foo = ({how})-> G "h1", "Works #{how}!"
    expect(render G "div", G Foo, how:"great").to.eql '<div><h1>Works great!</h1></div>'
    expect(render G Foo, how:"great").to.eql '<h1>Works great!</h1>'


