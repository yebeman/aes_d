/*
 * @file aes_engine.cu
 * @brif aes engine
 *
 *      Author: yebeman
 */


/*******************************************************************************
* Includes
*******************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <chrono>

#include "aes_config.h"
#include "aes_ui.h"
#include "aes_host_lib.h"
#include "aes_device_lib.h"
#include "aes_engine.h"

/*******************************************************************************
* Definitions
*******************************************************************************/

//typedefs

//constants


//macros

/*******************************************************************************
* Public Variables
*******************************************************************************/

/*******************************************************************************
* Private Variables
*******************************************************************************/
//  -- data stream
static cudaStream_t cudaStream[NUM_STREAMS];

static unsigned char *input_memory_pool[NUM_STREAMS],
                     *output_memory_pool[NUM_STREAMS];

static unsigned char *d_key;

// set up timer
static cudaEvent_t start[NUM_STREAMS], stop[NUM_STREAMS];
static float elapsed_time  = 0.0f;

static int seg_size = 0;

// Setup the execution configuration
static dim3 dimBlock, dimGrid;

/*******************************************************************************
* Private Prototypes
*******************************************************************************/
aes_engine_status_t aes_engine_encrypt(aes_ui_t *aes_ui);
aes_engine_status_t aes_engine_decrypt(aes_ui_t *aes_ui);

/*******************************************************************************
* Interrupt Service Routines
*******************************************************************************/

/*******************************************************************************
* Public Functions
*******************************************************************************/

aes_engine_status_t aes_engine_init()
{

    for (int _index = 0; _index < NUM_STREAMS; _index ++)
    {

        cudaEventCreate(&start[_index]);
        cudaEventCreate(&stop[_index]);
        cudaStreamCreate(&cudaStream[_index]);
    }

    return AES_ENGINE_SUCCESS;
}



aes_engine_status_t aes_engine(aes_ui_t *aes_ui)
{

    // read input
    if ( AES_HOST_LIB_SUCCESS != aes_host_lib_read_file(&aes_ui->input_file, true) )
    {    
        // error
        return AES_ENGINE_FAILURE;
    }

    // read key
    if ( AES_HOST_LIB_SUCCESS != aes_host_lib_read_file(&aes_ui->key, false) )
    {    
        // error
        return AES_ENGINE_FAILURE;
    }

    // create memory pool for output
    // on AES - ECB padding is up to the user
    aes_ui->output_file.content = (unsigned char *) malloc(aes_ui->input_file.padded_size * sizeof(unsigned char) );
    memset(aes_ui->output_file.content, 0x00,  aes_ui->input_file.padded_size * sizeof(unsigned char));
    aes_ui->output_file.size    = aes_ui->input_file.padded_size; // output will be have padd ending 

    // 6 block/sm * 256 thread/ block * 20 = 30720 threads
    // 30720 threads * 16 byte = 491,520 byte = 491Kbyte
    // aes_ui->input_file.padded_size is a multiple of 4096 or 256*16
    seg_size = aes_ui->input_file.padded_size / NUM_STREAMS ;

    // create memory
    for (int _index = 0; _index < NUM_STREAMS; _index ++)
    {
        cudaMalloc((void**) &input_memory_pool[_index],  seg_size * sizeof(unsigned char));
        cudaMemset(input_memory_pool[_index],   0x00, seg_size * sizeof(unsigned char));

        cudaMalloc((void**) &output_memory_pool[_index], seg_size * sizeof(unsigned char));
        cudaMemset(output_memory_pool[_index],  0x00, seg_size * sizeof(unsigned char));
    }

    cudaMalloc((void**) &d_key, 16 * sizeof(unsigned char));
    cudaMemcpy(d_key, 
               aes_ui->key.content,  
               16 * sizeof(unsigned char), 
               cudaMemcpyHostToDevice);

    // set block size
    dimBlock.x = BLOCK_SIZE;   
    dimBlock.y = 1;
    dimBlock.z = 1;

    // set grid size
    dimGrid.x = ceil( float (seg_size)  / float (BLOCK_SIZE * 16) );
    dimGrid.y = 1;
    dimGrid.z = 1;

    if (aes_ui->encrypt)
    {
        aes_engine_encrypt(aes_ui);
    }
    else 
    {
        aes_engine_decrypt(aes_ui);
    }

    cudaDeviceSynchronize();

    // add time take in all the streams
    float _elapsed = 0.0f;
    for (int _index = 0; _index < NUM_STREAMS; _index ++)
    {

        cudaEventSynchronize(stop[_index]);

        cudaEventElapsedTime(&_elapsed, start[_index], stop[_index]);

        elapsed_time+=_elapsed;
    }

    printf("\nElapsed time: %f ms\n\n", elapsed_time);

       // write file
    aes_host_lib_write_file(&aes_ui->output_file);

    return AES_ENGINE_SUCCESS;
}



/*******************************************************************************
* Private Functions
*******************************************************************************/

aes_engine_status_t aes_engine_encrypt(aes_ui_t *aes_ui)
{

    for (int _index = 0; _index < NUM_STREAMS; _index++)
    {

        cudaEventRecord(start[_index], cudaStream[_index]);

        cudaMemcpyAsync(input_memory_pool[_index], 
                        aes_ui->input_file.content + _index * seg_size,
                        seg_size * sizeof(unsigned char),
                        cudaMemcpyHostToDevice,
                        cudaStream[_index]);

        aes_device_lib_encrypt<<<dimGrid,dimBlock,0,cudaStream[_index]>>>(input_memory_pool[_index],
                                                                          output_memory_pool[_index],
                                                                          d_key,
                                                                          seg_size);

        cudaMemcpyAsync(aes_ui->output_file.content + _index * seg_size,
                                output_memory_pool[_index],
                                seg_size * sizeof(unsigned char),
                                cudaMemcpyDeviceToHost,
                                cudaStream[_index]);

        cudaEventRecord(stop[_index], cudaStream[_index]);

    }

    return AES_ENGINE_SUCCESS;

}


aes_engine_status_t aes_engine_decrypt(aes_ui_t *aes_ui)
{
    for (int _index = 0; _index < NUM_STREAMS; _index++)
    {

        cudaEventRecord(start[_index], cudaStream[_index]);

        cudaMemcpyAsync(input_memory_pool[_index],
                        aes_ui->input_file.content + _index * seg_size,
                        seg_size * sizeof(unsigned char),
                        cudaMemcpyHostToDevice,
                        cudaStream[_index]);

        aes_device_lib_decrypt<<<dimGrid,dimBlock,0,cudaStream[_index]>>>(input_memory_pool[_index],
                                                                          output_memory_pool[_index],
                                                                          d_key,
                                                                          seg_size);

        cudaMemcpyAsync(aes_ui->output_file.content + _index * seg_size,
                        output_memory_pool[_index],
                        seg_size * sizeof(unsigned char),
                        cudaMemcpyDeviceToHost,
                        cudaStream[_index]);

        cudaEventRecord(stop[_index], cudaStream[_index]);
    }

    return AES_ENGINE_SUCCESS;
}