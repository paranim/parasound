import unittest
import parasound/dr_wav
import parasound/miniaudio
import os
import json
from common import nil

test "can write wav file":
  const
    middleC = staticRead("middle_c.json")
    sampleRate = 44100
    numSamples = 1 * sampleRate
  let arr = parseJson(middleC)
  var data = newSeq[cshort]()
  for n in arr:
    data.add(n.getInt.cshort)
  common.writeFile("middle_c.wav", data, numSamples, sampleRate)
  doAssert existsFile("middle_c.wav")
  sleep(1000)

test "can write wav to memory and play it":
  const
    middleC = staticRead("middle_c.json")
    sampleRate = 44100
    numSamples = 1 * sampleRate
  let arr = parseJson(middleC)
  var data = newSeq[cshort]()
  for n in arr:
    data.add(n.getInt.cshort)
  let wav = common.writeMemory(data, numSamples, sampleRate)
  common.play(wav, 1000)

test "can play wav file":
  common.play("tests/xylophone-sweep.wav", 2000)

test "can play mp3 file":
  common.play("tests/xylophone-sweep.mp3", 2000)
