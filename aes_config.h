/*
 * @file aes_config.h
 * @brif configuration
 *
 *      Author: yebeman
 */

#ifndef AES_CONFIG__
#define AES_CONFIG__



#ifdef __cplusplus
extern "C" {
#endif




/*******************************************************************************
* Public Definitions
*******************************************************************************/

//typedefs

// function status

//constants

//macros
#define BLOCK_SIZE         256
#define BYTE_PER_THREAD    16 

#define NUM_STREAMS        4

// GPU DEFINES
#define NUM_SM                20
#define MAX_THREAD_PER_BLOCK  1024
#define MAX_THREAD_PER_SM     2048


/*******************************************************************************
* Public Functions
*******************************************************************************/

#ifdef __cplusplus
}
#endif



#endif /* AES_CONFIG__ */
