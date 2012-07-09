
#Envelope is based on exp(-t^2)
#Waveform is based on sin(t)
class DiscreteImpulse
  Max = 32767
  
  constructor: (duration)->
    @expDenom = @exponentDenominator(duration)
    #check if duration is odd
    @dur = parseInt duration
    console.log "WARNING: Need to figure out what duration really means and apply here accordingly"
    if (duration%2 is 1)
      @dur = duration + 1
    timeIntervals = [-@dur/2..@dur/2]
    impulseIntervals = (@impulseWaveform(t) for t in timeIntervals)
    maxImpulseAmplitude = Math.max.apply(Math, impulseIntervals)
    scaleFactor = Max/maxImpulseAmplitude
    floatData = (scaleFactor*t for t in impulseIntervals)
    @data = (Math.round(t) for t in floatData)

  filterMask: ->
    #create 0 filled array of same length as data
    filter = []
    maxVal = Math.max.apply(Math, @data)
    minVal = Math.min.apply(Math, @data)
    for val in @data
      match = 1
      noMatch = 0
      switch val
        when maxVal then filter.push(match)
        when minVal then filter.push(match)
        else filter.push(noMatch)
    filter

  exponentDenominator: (dur) ->
    d8 = dur/8
    d8sq = d8*d8
    expDenom = d8sq*Math.E

  exponentNumerator: (t) ->
    -(t*t)

  envelopeExponent: (t) ->
    @exponentNumerator(t)/@expDenom

  envelope: (t) ->
    2*@dur*Math.exp(@envelopeExponent(t))

  modulatingWaveform: (t) ->
    Math.sin(Math.PI*t/@dur)

  impulseWaveform: (t) ->
    console.log @envelope(t)
    @envelope(t) * @modulatingWaveform(t)

imp = new DiscreteImpulse(20)
console.log "wkg?", imp.data
console.log "filter", imp.filterMask()
#x = new DiscreteImpulse(params)

EnvelopeExponentFn = (dur) ->
  envFn = (t) ->
    -(t*t)/(((dur/8)^2)*Math.E)

testFn = EnvelopeExponentFn(5)
#-(x^2)/(((0.25*2)^2)*2.72)

expdenom = (d) ->
  d8 = d/8
  dfacsq = Math.pow(d8, 2)
  dfacsq*Math.E

expnum = (t) -> -(t*t)

dur = 4
thisDenom = expdenom(dur)
envExpFn = (t) ->
  expnum(t) / thisDenom

envFn = (t) ->
  2*dur * Math.exp(envExpFn(t))

sinFn = (t) ->
  Math.sin(Math.PI*t/dur)

impFn = (t) ->
  envFn(t)*sinFn(t)

imps = (impFn(t) for t in [-5..5])
console.log imps
maxImpulseAmplitude = Math.max.apply(Math, imps)
maxAmplitude = 32767
scaleFactor = maxAmplitude/maxImpulseAmplitude

discreteImpulse = (Math.round(scaleFactor*i) for i in imps)

console.log discreteImpulse

