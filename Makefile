
NVCC        = nvcc

NVCC_FLAGS  = -I/usr/local/cuda/include -std=c++11  -gencode=arch=compute_50,code=\"sm_50,compute_50\"
ifdef dbg
	NVCC_FLAGS  += -g -G
else
	NVCC_FLAGS  += -O3 
endif

LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64
EXE         = aes_d
OBJ         = main.o aes_device_lib.o aes_host_lib.o aes_ui.o aes_engine.o


default: $(EXE)

main.o :  main.cu 
	$(NVCC) -c -o $@ main.cu $(NVCC_FLAGS)

aes_device_lib.o :  aes_device_lib.cu 
	$(NVCC) -c -o $@ aes_device_lib.cu  $(NVCC_FLAGS)

aes_host_lib.o :  aes_host_lib.cu 
	$(NVCC) -c -o $@ aes_host_lib.cu $(NVCC_FLAGS)

aes_ui.o : aes_ui.cu
	$(NVCC) -c -o $@ aes_ui.cu $(NVCC_FLAGS)

aes_engine.o : aes_engine.cu
	$(NVCC) -c -o $@ aes_engine.cu $(NVCC_FLAGS)

# COMBINE OBJECT --
$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE) $(LD_FLAGS) $(NVCC_FLAGS)

clean:
	rm -rf *.o $(EXE)
