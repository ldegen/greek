describe "The functor-less DSL", ->
  DSL = require "../src/dsl"
  ReactDomServer = require "react-dom/server"
  React = require "react"

  {div, ul, li,h1,p,br} = DSL builtins:Object.keys(React.DOM), createElement:React.createElement, isValidElement:React.isValidElement
  render = (element)-> ReactDomServer.renderToStaticMarkup element
    
  it "can represent elements with a single child and no attributes", ->
    element = div ul li "Hello World!"
    expect(render element).to.eql "<div><ul><li>Hello World!</li></ul></div>"

  it "can represent elements with a single child and attributes", ->
    element = div id:"div-42", className: "sonderklasse", ul li "w00t?"
    expect(render element).to.eql '<div id="div-42" class="sonderklasse"><ul><li>w00t?</li></ul></div>'
  it "can represent elements with without children or attributes",->
    expect(render br()).to.eql '<br/>'
  it "can represent elements with children but no attributes", ->
    element = div [
      h1 "tag"
      p "Ein schöner Tag"
    ]
    expect(render element).to.eql '<div><h1>tag</h1><p>Ein schöner Tag</p></div>'
  it "can represent elements with attributes but no children", ->
    element = div className: "spitzenklasse"
    expect(render element).to.eql '<div class="spitzenklasse"></div>'
  it "can represent elements with attributes and children", ->
    element = div id:"div-42", className: "test", [
      h1 "tag"
      p "Ein schöner Tag"
    ]
    expect(render element).to.eql '<div id="div-42" class="test"><h1>tag</h1><p>Ein schöner Tag</p></div>'
  it "alternatively allows you to specify children as vararg", ->
    element = div id:"div-42", className: "test", 
      h1 "tag"
      p "Ein schöner Tag"
    
    expect(render element).to.eql '<div id="div-42" class="test"><h1>tag</h1><p>Ein schöner Tag</p></div>'

  it "works with components created via React.createClass", ->
    Foo = React.createClass render: -> h1 "Works #{@props.how}!"
    Foo_ = React.createFactory Foo
    expect(render div Foo_ how:"great").to.eql '<div><h1>Works great!</h1></div>'
    expect(render Foo_ how:"great").to.eql '<h1>Works great!</h1>'


  
  it "works with components that are instances of React.Component",->
    class Foo extends React.Component
      render: -> h1 "Works #{@props.how}!"
    Foo_ = React.createFactory Foo
    expect(render div Foo_ how:"great").to.eql '<div><h1>Works great!</h1></div>'
    expect(render Foo_ how:"great").to.eql '<h1>Works great!</h1>'

  it "works with 'pure functional' components", ->
    Foo = ({how})-> h1 "Works #{how}!"
    _ = (constructor)->React.createFactory constructor
    expect(render div _(Foo) how:"great").to.eql '<div><h1>Works great!</h1></div>'
    expect(render _(Foo) how:"great").to.eql '<h1>Works great!</h1>'


