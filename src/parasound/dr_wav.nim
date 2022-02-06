{.compile: "dr_wav.c".}

const
  DRWAV_SUCCESS* = 0
  DRWAV_ERROR* = -1
  DRWAV_INVALID_ARGS* = -2
  DRWAV_INVALID_OPERATION* = -3
  DRWAV_OUT_OF_MEMORY* = -4
  DRWAV_OUT_OF_RANGE* = -5
  DRWAV_ACCESS_DENIED* = -6
  DRWAV_DOES_NOT_EXIST* = -7
  DRWAV_ALREADY_EXISTS* = -8
  DRWAV_TOO_MANY_OPEN_FILES* = -9
  DRWAV_INVALID_FILE* = -10
  DRWAV_TOO_BIG* = -11
  DRWAV_PATH_TOO_LONG* = -12
  DRWAV_NAME_TOO_LONG* = -13
  DRWAV_NOT_DIRECTORY* = -14
  DRWAV_IS_DIRECTORY* = -15
  DRWAV_DIRECTORY_NOT_EMPTY* = -16
  DRWAV_END_OF_FILE* = -17
  DRWAV_NO_SPACE* = -18
  DRWAV_BUSY* = -19
  DRWAV_IO_ERROR* = -20
  DRWAV_INTERRUPT* = -21
  DRWAV_UNAVAILABLE* = -22
  DRWAV_ALREADY_IN_USE* = -23
  DRWAV_BAD_ADDRESS* = -24
  DRWAV_BAD_SEEK* = -25
  DRWAV_BAD_PIPE* = -26
  DRWAV_DEADLOCK* = -27
  DRWAV_TOO_MANY_LINKS* = -28
  DRWAV_NOT_IMPLEMENTED* = -29
  DRWAV_NO_MESSAGE* = -30
  DRWAV_BAD_MESSAGE* = -31
  DRWAV_NO_DATA_AVAILABLE* = -32
  DRWAV_INVALID_DATA* = -33
  DRWAV_TIMEOUT* = -34
  DRWAV_NO_NETWORK* = -35
  DRWAV_NOT_UNIQUE* = -36
  DRWAV_NOT_SOCKET* = -37
  DRWAV_NO_ADDRESS* = -38
  DRWAV_BAD_PROTOCOL* = -39
  DRWAV_PROTOCOL_UNAVAILABLE* = -40
  DRWAV_PROTOCOL_NOT_SUPPORTED* = -41
  DRWAV_PROTOCOL_FAMILY_NOT_SUPPORTED* = -42
  DRWAV_ADDRESS_FAMILY_NOT_SUPPORTED* = -43
  DRWAV_SOCKET_NOT_SUPPORTED* = -44
  DRWAV_CONNECTION_RESET* = -45
  DRWAV_ALREADY_CONNECTED* = -46
  DRWAV_NOT_CONNECTED* = -47
  DRWAV_CONNECTION_REFUSED* = -48
  DRWAV_NO_HOST* = -49
  DRWAV_IN_PROGRESS* = -50
  DRWAV_CANCELLED* = -51
  DRWAV_MEMORY_ALREADY_MAPPED* = -52
  DRWAV_AT_END* = -53

  DR_WAVE_FORMAT_PCM* = 0x00000001
  DR_WAVE_FORMAT_ADPCM* = 0x00000002
  DR_WAVE_FORMAT_IEEE_FLOAT* = 0x00000003
  DR_WAVE_FORMAT_ALAW* = 0x00000006
  DR_WAVE_FORMAT_MULAW* = 0x00000007
  DR_WAVE_FORMAT_DVI_ADPCM* = 0x00000011
  DR_WAVE_FORMAT_EXTENSIBLE* = 0x0000FFFE

type
  drwav_int8* = char
  drwav_uint8* = uint8
  drwav_int16* = cshort
  drwav_uint16* = cushort
  drwav_int32* = cint
  drwav_uint32* = cuint
  drwav_int64* = int64
  drwav_uint64* = uint64
  drwav_bool32* = bool
  drwav_result* = drwav_int32
  wchar_t* = cshort

  drwav_seek_origin* = enum
    drwav_seek_origin_start, drwav_seek_origin_current

  drwav_read_proc* = proc (pUserData: pointer; pBufferOut: pointer; bytesToRead: csize_t): csize_t {.cdecl.}
  drwav_write_proc* = proc (pUserData: pointer; pData: pointer; bytesToWrite: csize_t): csize_t {.cdecl.}
  drwav_seek_proc* = proc (pUserData: pointer; offset: cint; origin: drwav_seek_origin): drwav_bool32 {.cdecl.}

  drwav_chunk_proc* = proc (pChunkUserData: pointer; onRead: drwav_read_proc;
                         onSeek: drwav_seek_proc; pReadSeekUserData: pointer;
                         pChunkHeader: pointer;
                         container: drwav_container; pFMT: pointer): drwav_uint64 {.cdecl.}
  drwav_allocation_callbacks* {.bycopy.} = object
    pUserData*: pointer
    onMalloc*: proc (sz: csize_t; pUserData: pointer): pointer {.cdecl.}
    onRealloc*: proc (p: pointer; sz: csize_t; pUserData: pointer): pointer {.cdecl.}
    onFree*: proc (p: pointer; pUserData: pointer) {.cdecl.}

  drwav_container* = enum
    drwav_container_riff, drwav_container_w64

  drwav_data_format* {.bycopy.} = object
    container*: drwav_container ##  RIFF, W64.
    format*: drwav_uint32      ##  DR_WAVE_FORMAT_*
    channels*: drwav_uint32
    sampleRate*: drwav_uint32
    bitsPerSample*: drwav_uint32

proc drwav_data_format_size*(): csize_t {.cdecl, importc.}
proc drwav_init_file_write*(pWav: pointer; filename: cstring;
                            pFormat: ptr drwav_data_format; pAllocationCallbacks: ptr drwav_allocation_callbacks): drwav_bool32 {.cdecl, importc.}
proc drwav_init_file_write_sequential*(pWav: pointer; filename: cstring;
                                       pFormat: ptr drwav_data_format;
                                       totalSampleCount: drwav_uint64;
                                       pAllocationCallbacks: ptr drwav_allocation_callbacks): drwav_bool32 {.cdecl, importc.}
proc drwav_init_memory_write*(pWav: pointer; ppData: ptr pointer;
                              pDataSize: ptr csize_t; pFormat: ptr drwav_data_format;
                              pAllocationCallbacks: ptr drwav_allocation_callbacks): drwav_bool32 {.cdecl, importc.}
proc drwav_init_memory_write_sequential*(pWav: pointer; ppData: ptr pointer;
                                         pDataSize: ptr csize_t;
                                         pFormat: ptr drwav_data_format;
                                         totalSampleCount: drwav_uint64;
                                         pAllocationCallbacks: ptr drwav_allocation_callbacks): drwav_bool32 {.cdecl, importc.}
proc drwav_write_pcm_frames*(pWav: pointer; framesToWrite: drwav_uint64;
                             pData: pointer): drwav_uint64 {.cdecl, importc.}
proc drwav_uninit*(pWav: pointer): drwav_result {.cdecl, importc.}
proc drwav_free*(p: pointer; pAllocationCallbacks: ptr drwav_allocation_callbacks) {.cdecl, importc.}

proc drwav_size*(): csize_t {.cdecl, importc.}
