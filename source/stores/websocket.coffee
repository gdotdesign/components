Store = require '../store.coffee'

# WebSocket Store Adapter
class WebSocketStore extends Store
  # Generated unique identifier for transactions
  #
  # @return [String] The uid
  uid: -> '10000000-1000-0000-0000-000000000000'.replace /0/g, -> (0|Math.random()*16).toString(16)

  # Constructor
  #
  # @param [WebSocket] ws The WebSocket interface (WebSocket for browser / ws package for node)
  # @param [String] Path the path to connect to
  constructor: (ws,path,callback)->
    @map = {}
    @socket = new ws(path)
    @socket.addEventListener 'message', @route
    @socket.addEventListener 'open', -> callback()

  # Handles massages
  #
  # @param [Event] e The event
  # @private
  route: (e)=>
    {id,data} = JSON.parse e.data
    @map[id]? data
    delete @map[id]

  # Sends a constructed message trough the websocket
  #
  # @param [String] type The type of the massage
  # @param [Object] data The data to send
  # @param [Function] callback The callback to call
  # @private
  query: (type,data,callback)->
    id = @uid()
    @map[id] = callback
    @socket.send JSON.stringify {id: id, type: type, data: data}

  # Lists component names contained in this store
  #
  # @param [Function] callback The callback to run
  #
  # @return [Array] The names of the components (in the callback)
  list: (callback)->
    @query 'list', {}, callback

  # Retries a component from this store
  #
  # @param [String] name The name of the component
  # @param [Function] callback The callback to run
  #
  # @return [Object] The component (in the callback)
  get: (name,callback)->
    throw new Error "Not enough arguments" if arguments.length is 0
    return callback(null) if name is null
    @query 'get', { name: name }, (data)=>
      return callback(null) unless data
      callback @deserialize data

  # Stores a component from this store
  #
  # @param [String] name The name of the component
  # @param [Object] component The component
  # @param [Function] callback The callback to run
  set: (name,component,callback)->
    throw new Error "Not enough arguments" if arguments.length < 2
    @query 'set', { name: name, data: @serialize component }, (data)=>
      callback?()

  # Removes a component from this store
  #
  # @param [String] name The name of the component
  # @param [Function] callback The callback to run
  remove: (name,callback)->
    throw new Error "Not enough arguments" if arguments.length is 0
    @query 'remove', {name: name}, callback

module.exports = WebSocketStore