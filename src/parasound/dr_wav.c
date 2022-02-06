#define DR_WAV_IMPLEMENTATION
#include "dr_wav.h"

size_t drwav_size() {
  return sizeof(drwav);
}

size_t drwav_data_format_size() {
  return sizeof(drwav_data_format);
}
