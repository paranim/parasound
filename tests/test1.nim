# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest
import parasound/dr_wav
import parasound/miniaudio
import os
import json

test "can write wav file":
  const
    middleC = staticRead("middle_c.json")
    sampleRate = 44100
    numSamples = 1 * sampleRate
  let arr = parseJson(middleC)
  var
    data = newSeq[cshort]()
    wav: drwav
    format: drwav_data_format
  for n in arr:
    data.add(n.getInt.cshort)
  format.container = drwav_container_riff
  format.format = DR_WAVE_FORMAT_PCM
  format.channels = 1
  format.sampleRate = sampleRate
  format.bitsPerSample = 16
  doAssert drwav_init_file_write(wav.addr, "middle_c.wav", addr(format), nil)
  doAssert numSamples == drwav_write_pcm_frames(wav.addr, numSamples, data[0].addr)
  discard drwav_uninit(wav.addr)
  doAssert existsFile("middle_c.wav")
  sleep(1000)

test "can play wav file":
  var
    res: ma_result
    decoder = newSeq[uint8](ma_decoder_size())
    decoderAddr = cast[ptr ma_decoder](decoder[0].addr)
    deviceConfig = newSeq[uint8](ma_device_config_size())
    deviceConfigAddr = cast[ptr ma_device_config](deviceConfig[0].addr)
    device = newSeq[uint8](ma_device_size())
    deviceAddr = cast[ptr ma_device](device[0].addr)
  res = ma_decoder_init_file("tests/xylophone-sweep.wav", nil, decoderAddr)
  doAssert res == MA_SUCCESS

  proc data_callback(pDevice: ptr ma_device; pOutput: pointer; pInput: pointer; frameCount: ma_uint32) {.cdecl.} =
    discard ma_decoder_read_pcm_frames(decoderAddr, pOutput, frameCount)

  ma_device_config_init_with_decoder(deviceConfigAddr, ma_device_type_playback, decoderAddr, data_callback)
  if ma_device_init(nil, deviceConfigAddr, deviceAddr) != MA_SUCCESS:
    discard ma_decoder_uninit(decoderAddr)
    quit("Failed to open playback device.")

  if ma_device_start(deviceAddr) != MA_SUCCESS:
    #ma_device_uninit(deviceAddr)
    discard ma_decoder_uninit(decoderAddr)
    quit("Failed to start playback device.")

  sleep(2000)
  #discard ma_device_stop(deviceAddr)
  #ma_device_uninit(deviceAddr)
  discard ma_decoder_uninit(decoderAddr)
