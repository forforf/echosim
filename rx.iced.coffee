root = exports ? this

class Rx
  constructor: (@channel)->
    #channel is of ChannelEmitter type
    @channel.on 'output', (data) ->
      console.log data

root.Rx = Rx
