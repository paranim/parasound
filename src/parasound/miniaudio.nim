{.compile: "miniaudio.c".}

type
  ma_result* = enum
    MA_FAILED_TO_STOP_BACKEND_DEVICE = -303,
    MA_FAILED_TO_START_BACKEND_DEVICE = -302,
    MA_FAILED_TO_OPEN_BACKEND_DEVICE = -301, MA_FAILED_TO_INIT_BACKEND = -300, MA_DEVICE_NOT_STOPPED = -203, ##  Operation errors.
    MA_DEVICE_NOT_STARTED = -202, MA_DEVICE_ALREADY_INITIALIZED = -201,
    MA_DEVICE_NOT_INITIALIZED = -200, MA_LOOP = -107, ##  State errors.
    MA_INVALID_DEVICE_CONFIG = -106, MA_API_NOT_FOUND = -105, MA_NO_DEVICE = -104,
    MA_NO_BACKEND = -103, MA_SHARE_MODE_NOT_SUPPORTED = -102,
    MA_DEVICE_TYPE_NOT_SUPPORTED = -101, MA_FORMAT_NOT_SUPPORTED = -100, MA_MEMORY_ALREADY_MAPPED = -52, ##  General miniaudio-specific errors.
    MA_CANCELLED = -51, MA_IN_PROGRESS = -50, MA_NO_HOST = -49,
    MA_CONNECTION_REFUSED = -48, MA_NOT_CONNECTED = -47, MA_ALREADY_CONNECTED = -46,
    MA_CONNECTION_RESET = -45, MA_SOCKET_NOT_SUPPORTED = -44,
    MA_ADDRESS_FAMILY_NOT_SUPPORTED = -43, MA_PROTOCOL_FAMILY_NOT_SUPPORTED = -42,
    MA_PROTOCOL_NOT_SUPPORTED = -41, MA_PROTOCOL_UNAVAILABLE = -40,
    MA_BAD_PROTOCOL = -39, MA_NO_ADDRESS = -38, MA_NOT_SOCKET = -37,
    MA_NOT_UNIQUE = -36, MA_NO_NETWORK = -35, MA_TIMEOUT = -34, MA_INVALID_DATA = -33,
    MA_NO_DATA_AVAILABLE = -32, MA_BAD_MESSAGE = -31, MA_NO_MESSAGE = -30,
    MA_NOT_IMPLEMENTED = -29, MA_TOO_MANY_LINKS = -28, MA_DEADLOCK = -27,
    MA_BAD_PIPE = -26, MA_BAD_SEEK = -25, MA_BAD_ADDRESS = -24, MA_ALREADY_IN_USE = -23,
    MA_UNAVAILABLE = -22, MA_INTERRUPT = -21, MA_IO_ERROR = -20, MA_BUSY = -19,
    MA_NO_SPACE = -18, MA_AT_END = -17, MA_DIRECTORY_NOT_EMPTY = -16,
    MA_IS_DIRECTORY = -15, MA_NOT_DIRECTORY = -14, MA_NAME_TOO_LONG = -13,
    MA_PATH_TOO_LONG = -12, MA_TOO_BIG = -11, MA_INVALID_FILE = -10,
    MA_TOO_MANY_OPEN_FILES = -9, MA_ALREADY_EXISTS = -8, MA_DOES_NOT_EXIST = -7,
    MA_ACCESS_DENIED = -6, MA_OUT_OF_RANGE = -5, MA_OUT_OF_MEMORY = -4,
    MA_INVALID_OPERATION = -3, MA_INVALID_ARGS = -2, MA_ERROR = -1, ##  A generic error.
    MA_SUCCESS = 0

proc ma_engine_init*(pConfig: pointer; pEngine: pointer): ma_result {.cdecl, importc.}
proc ma_engine_uninit*(pEngine: pointer) {.cdecl, importc.}
proc ma_engine_play_sound*(pEngine: pointer; pFilePath: cstring;
                           pGroup: pointer): ma_result {.cdecl, importc.}

proc ma_decoder_init_memory*(pData: pointer; dataSize: csize_t;
                             pConfig: pointer;
                             pDecoder: pointer): ma_result {.cdecl, importc.}
proc ma_decoder_uninit*(pDecoder: pointer): ma_result {.cdecl, importc.}
proc ma_sound_init_from_data_source*(pEngine: pointer;
                                     pDataSource: pointer;
                                     flags: uint32; pGroup: pointer;
                                     pSound: pointer): ma_result {.cdecl, importc.}
proc ma_sound_uninit*(pSound: pointer) {.cdecl, importc.}
proc ma_sound_start*(pSound: pointer): ma_result {.cdecl, importc.}
proc ma_sound_stop*(pSound: pointer): ma_result {.cdecl, importc.}

proc ma_engine_size*(): csize_t {.cdecl, importc.}
proc ma_decoder_size*(): csize_t {.cdecl, importc.}
proc ma_sound_size*(): csize_t {.cdecl, importc.}
