SAMPLE_RATE=48000
CHANNELS=2
COMP_SAMPLE_RATE=1000
COMP_CHANNELS=1
rick: rickmain.o rick.o
	${CC} rickmain.o rick.o  -lasound -o rick

rickcomp: rickcompmain.o rickcomp.o
	${CC} rickcompmain.o rickcomp.o  -lasound -o rickcomp

all: rick rickcomp

rick.o: rick.raw
	objcopy -I binary -O default rick.raw rick.o

rickcomp.o: rickcomp.raw
	objcopy -I binary -O default rickcomp.raw rickcomp.o
	
rickmain.o:
	${CC} main.c ${CC_FLAGS} -c -o rickmain.o -DSAMPLE_RATE=${SAMPLE_RATE} -DDATA_START=_binary_rick_raw_start -DDATA_END=_binary_rick_raw_end -DCHANNEL_CNT=${CHANNELS}

rickcompmain.o:
	${CC} main.c ${CC_FLAGS} -c -o rickcompmain.o -DSAMPLE_RATE=${COMP_SAMPLE_RATE} -DDATA_START=_binary_rickcomp_raw_start -DDATA_END=_binary_rickcomp_raw_end -DCHANNEL_CNT=${COMP_CHANNELS}

rick.raw:
	ffmpeg -y -i rick.mp3  -acodec pcm_s16le -f s16le -ac 2 -ar ${SAMPLE_RATE} rick.raw
	
rickcomp.raw:
	ffmpeg -y -i rick.mp3  -acodec pcm_s16le -f s16le -ac 1 -ar ${COMP_SAMPLE_RATE} rickcomp.raw
    
.PHONY=clean
clean:
	rm -f *.o rick rickcomp rick.raw rickcomp.raw
