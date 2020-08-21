import unittest
import parasound/dr_wav
import parasound/miniaudio
import os
import json

proc play(data: string | seq[uint8], sleepMsecs: int) =
  var
    decoder = newSeq[uint8](ma_decoder_size())
    decoderAddr = cast[ptr ma_decoder](decoder[0].addr)
    deviceConfig = newSeq[uint8](ma_device_config_size())
    deviceConfigAddr = cast[ptr ma_device_config](deviceConfig[0].addr)
    device = newSeq[uint8](ma_device_size())
    deviceAddr = cast[ptr ma_device](device[0].addr)
  when data is string:
    doAssert MA_SUCCESS == ma_decoder_init_file(data, nil, decoderAddr)
  elif data is seq[uint8]:
    doAssert MA_SUCCESS == ma_decoder_init_memory(data[0].unsafeAddr, data.len, nil, decoderAddr)

  proc data_callback(pDevice: ptr ma_device; pOutput: pointer; pInput: pointer; frameCount: ma_uint32) {.cdecl.} =
    let decoderAddr = ma_device_get_decoder(pDevice)
    discard ma_decoder_read_pcm_frames(decoderAddr, pOutput, frameCount)

  ma_device_config_init_with_decoder(deviceConfigAddr, ma_device_type_playback, decoderAddr, data_callback)
  if ma_device_init(nil, deviceConfigAddr, deviceAddr) != MA_SUCCESS:
    discard ma_decoder_uninit(decoderAddr)
    quit("Failed to open playback device.")

  if ma_device_start(deviceAddr) != MA_SUCCESS:
    ma_device_uninit(deviceAddr)
    discard ma_decoder_uninit(decoderAddr)
    quit("Failed to start playback device.")

  sleep(sleepMsecs)
  discard ma_device_stop(deviceAddr)
  ma_device_uninit(deviceAddr)
  discard ma_decoder_uninit(decoderAddr)

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
  doAssert drwav_init_file_write(wav.addr, "middle_c.wav", format.addr, nil)
  doAssert numSamples == drwav_write_pcm_frames(wav.addr, numSamples, data[0].addr)
  discard drwav_uninit(wav.addr)
  doAssert existsFile("middle_c.wav")
  sleep(1000)

test "can play wav file":
  play("tests/xylophone-sweep.wav", 2000)

test "can play mp3 file":
  play("tests/xylophone-sweep.mp3", 2000)

test "can write wav to memory and play it":
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
  var
    outputRaw: pointer
    outputSize: csize
    output: seq[uint8]
  doAssert drwav_init_memory_write_sequential(wav.addr, outputRaw.addr, outputSize.addr, format.addr, numSamples, nil)
  doAssert numSamples == drwav_write_pcm_frames(wav.addr, numSamples, data[0].addr)
  doAssert outputSize > 0
  output = newSeq[uint8](outputSize)
  copyMem(output[0].addr, outputRaw, outputSize)
  drwav_free(outputRaw, nil)
  play(output, 1000)
  discard drwav_uninit(wav.addr)
