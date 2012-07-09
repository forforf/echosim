root = exports ? this

class Tx
  constructor: (@channel)->
   #channel is of ChannelEmitter type

  send: (dataArray) ->
    @channel.in(dataInt) for dataInt in dataArray

root.Tx = Tx
