Utils = require './utils.coffee'

class Store
  list   : -> console.warn Object.getPrototypeOf(@).constructor.name+'::list not implemented!'
  get    : -> console.warn Object.getPrototypeOf(@).constructor.name+'::get not implemented!'
  set    : -> console.warn Object.getPrototypeOf(@).constructor.name+'::set not implemented!'
  remove : -> console.warn Object.getPrototypeOf(@).constructor.name+'::remove not implemented!'

  # Deserialize component
  deserialize: (component)->
    # Deserialize ports
    if component.ports
      for key,value of component.ports
        component.ports[key] = Function('value','create',value)

    # Deserialize events
    if component.events
      for key,value of component.events
        component.events[key] = Function('e','create',value)

    component

  # Serialize component
  serialize: (component)->
    newComponent = {}

    # Copy 'static' properties
    newComponent.css = component.css.toString() if component.css
    newComponent.components = component.components if component.components

    # Serialize ports
    if component.ports
      newComponent.ports = {}
      for key, value of component.ports
        newComponent.ports[key] = Utils.getBody value

    # Serialize Events
    if component.events
      newComponent.events = {}
      for key, value of component.events
        newComponent.events[key] = Utils.getBody value

    newComponent

module.exports = Store