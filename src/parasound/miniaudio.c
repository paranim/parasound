#define MINIAUDIO_IMPLEMENTATION
#define DRWAV_IMPLEMENTATION
#include "miniaudio.h"

size_t ma_engine_size() {
  return sizeof(ma_engine);
}

size_t ma_decoder_size() {
  return sizeof(ma_decoder);
}

size_t ma_sound_size() {
  return sizeof(ma_sound);
}

void play_sound_from_file(char* file)
{
  ma_result result;
  ma_engine *engine = calloc(1, ma_engine_size());

  result = ma_engine_init(NULL, engine);
  if (result != MA_SUCCESS) {
    printf("Failed to initialize audio engine.");
    return;
  }

  ma_engine_play_sound(engine, file, NULL);

  printf("Press Enter to quit...");
  getchar();

  ma_engine_uninit(engine);
  free(engine);
}

void play_sound_from_data(void* data, int size)
{
  ma_result result;
  ma_engine *engine = calloc(1, ma_engine_size());

  result = ma_engine_init(NULL, engine);
  if (result != MA_SUCCESS) {
    printf("Failed to initialize audio engine.");
    return;
  }

  ma_decoder *decoder = calloc(1, ma_decoder_size());
  result = ma_decoder_init_memory(data, size, NULL, decoder);
  if (result != MA_SUCCESS) {
    printf("Failed to init decoder.");
    return;
  }

  ma_sound *sound = calloc(1, ma_sound_size());
  result = ma_sound_init_from_data_source(engine, decoder, 0, NULL, sound);
  if (result != MA_SUCCESS) {
    printf("Failed to load sound data.");
    return;
  }

  ma_sound_start(sound);

  printf("Press Enter to quit...");
  getchar();

  ma_sound_uninit(sound);
  free(sound);

  ma_decoder_uninit(decoder);
  free(decoder);

  ma_engine_uninit(engine);
  free(engine);
}
