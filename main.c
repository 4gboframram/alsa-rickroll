#include <alsa/asoundlib.h>
#include <stdio.h>


#define PCM_DEVICE "default"
// #define SAMPLE_RATE 18000
// #define CHANNEL_CNT 1
// #define DATA_START _binary_rickcomp_raw_start
// #define DATA_END _binary_rickcomp_raw_end
extern const int DATA_START[];
extern const int DATA_END[];

int main(int argc, char **argv) {
	snd_pcm_t *pcm;
	snd_pcm_open(&pcm, "default", SND_PCM_STREAM_PLAYBACK, 0);
		
	snd_pcm_hw_params_t *hw_params;
	snd_pcm_hw_params_alloca(&hw_params);
	
	snd_pcm_hw_params_any(pcm, hw_params);
	snd_pcm_hw_params_set_access(pcm, hw_params, SND_PCM_ACCESS_RW_INTERLEAVED);
	snd_pcm_hw_params_set_format(pcm, hw_params, SND_PCM_FORMAT_S16_LE);
	snd_pcm_hw_params_set_channels(pcm, hw_params, CHANNEL_CNT);
	snd_pcm_hw_params_set_rate(pcm, hw_params, SAMPLE_RATE, 0);
	snd_pcm_hw_params_set_periods(pcm, hw_params, 10, 0);
	snd_pcm_hw_params_set_period_time(pcm, hw_params, 100000, 0); // 0.1 seconds
	
	snd_pcm_hw_params(pcm, hw_params);
	
	// write
	snd_pcm_writei(pcm, DATA_START, DATA_END - DATA_START);
	
	snd_pcm_drain(pcm);
	snd_pcm_close(pcm);
	
	return 0;
}

