root = exports ? this

events = require 'events'

#assumes signed 16bit integers (from PCM) -32768 <-> 32767
class ChannelEmitter extends events.EventEmitter
  constructor: (model) ->
    model = if model then model else {}
    @delay = if model.delay then parseInt(model.delay) else 0
    #noise is pk-pk noise centered at 0
    @noise = if model.noise then parseInt(Math.abs(model.noise)) else 0
    @gain = if model.gain then parseFloat(model.gain) else 0
    if typeof(model) is "function"
      @channelModelFn = model

  #just reverses the arguments so timeouts have cleaner code
  myTimeout: (delay, fn)->
   setTimeout(fn, delay)

  calculateGain: (sigIn, gain)->
    linGain = Math.pow(10, (gain/20))
    sigOut = linGain*sigIn

  calculateNoise: (sigIn, noise)->
    additiveNoise = (Math.random() * noise) - noise/2.0
    sigNoise = sigIn + additiveNoise

  in: (sig) ->
    sig = parseFloat(sig)
    sigPlusNoise = sig #if noise is 0
    if Math.abs(@noise)>0
      sigPlusNoise = @calculateNoise(sig, @noise)
    sigPlusNoiseGain = @calculateGain(sigPlusNoise, @gain)
    sigOut = parseInt(sigPlusNoiseGain)
    @.myTimeout @delay, =>
      @.emit('output', sigOut)
    
root.ChannelEmitter = ChannelEmitter

#Ch = ChannelEmitter
#console.log Ch

#channelData = 
#  noise: 0
#  delay: 0
#  gain: 0

#console.log channelData

#ch = new Ch(channelData)


#channelEmitter = new ChannelEmitter({delay: 1000, noise:3, gain:-6})

#channelEmitter.on 'output', (data) ->
#  console.log data

#channelEmitter.in('-12')
