{ChannelEmitter} = require './channel.iced.coffee'
{Tx}             = require './tx.iced.coffee'
{Rx}             = require './rx.iced.coffee'

channelData = 
  noise: 0
  delay: 0
  gain: 0

ch = new ChannelEmitter(channelData)
tx = new Tx(ch)
rx = new Rx(ch)

data = [1,2,3,4]

#send data to channel
tx.send data

#rx will recieve any data through channel


