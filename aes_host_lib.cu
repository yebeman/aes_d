/*
 * @file aes_host_library.cu
 * @brif host library
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

/*******************************************************************************
* Private Prototypes
*******************************************************************************/

/*******************************************************************************
* Interrupt Service Routines
*******************************************************************************/

/*******************************************************************************
* Public Functions
*******************************************************************************/

aes_host_lib_status_t aes_host_lib_init()
{

    return AES_HOST_LIB_SUCCESS;
}


// Read array in from file
// with padding by one block crunchable data chunk
aes_host_lib_status_t aes_host_lib_read_file( aes_ui_file_t *aes_ui_file, bool isPadding) 
{
    
    size_t _size = 0,
           _padded_size = 0;

    FILE* _input = fopen(aes_ui_file->name, "r");
    if (_input == NULL) {

        printf("Error opening file %s\n", aes_ui_file->name);
        return AES_HOST_LIB_FAILURE;  

    }

    // find length
    fseek(_input, 0, SEEK_END);
    _size = ftell(_input);
    rewind (_input);

    // pad per block data
    // block data = BLOCK_SIZE * BYTE_PER_THREAD
    _padded_size = _size;

    if (isPadding)
     {
        _padded_size += BLOCK_SIZE * BYTE_PER_THREAD - _size % ( BLOCK_SIZE * BYTE_PER_THREAD );
     } 


    // create a location
    aes_ui_file->content = (unsigned char *) malloc( _padded_size * sizeof(unsigned char) );
    memset(aes_ui_file->content, 0x00, _padded_size * sizeof(unsigned char) );

    // read
    if (fread(aes_ui_file->content, 1, _size, _input) != _size)
    {
        printf("Unable to read all bytes from file %s\n", aes_ui_file->name);
        return AES_HOST_LIB_FAILURE;  
    }

    aes_ui_file->padded_size = _padded_size;
    aes_ui_file->size         = _size;

    fclose (_input);

    return AES_HOST_LIB_SUCCESS;

}

aes_host_lib_status_t aes_host_lib_write_file( aes_ui_file_t *aes_ui_file) 
{

    FILE* _output = fopen(aes_ui_file->name, "w");
    if (_output == NULL) {

        printf("Error opening file %s\n", aes_ui_file->name);
        return AES_HOST_LIB_FAILURE;  

    }

    fwrite(aes_ui_file->content, sizeof(unsigned char), aes_ui_file->size, _output);
    fclose (_output);

    return AES_HOST_LIB_SUCCESS;
}





/*******************************************************************************
* Private Functions
*******************************************************************************/
