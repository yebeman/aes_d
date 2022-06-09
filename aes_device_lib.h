/*
 * @file aes_device_lib.h
 * @brif device library
 *
 *      Author: yebeman
 */

#ifndef AES_DEVICE_LIB_H_
#define AES_DEVICE_LIB_H_



#ifdef __cplusplus
extern "C" {
#endif




/*******************************************************************************
* Public Definitions
*******************r************************************************************/

//typedefs

// function status
typedef enum
{

    AES_DEVICE_LIB_SUCCESS   =    0    /** Successfully Completed */

} aes_device_lib_status_t;




/*******************************************************************************
* Public Functions
*******************************************************************************/


/**
* \brief device init
*
* \return  aes_device_lib_status_t
*/
aes_device_lib_status_t aes_device_lib_init();


__global__ void aes_device_lib_decrypt(unsigned char *message, unsigned char *encMessage, unsigned char *key, size_t size);
__global__ void aes_device_lib_encrypt(unsigned char *message, unsigned char *encMessage, unsigned char *key, size_t size);


#ifdef __cplusplus
}
#endif



#endif /* AES_DEVICE_LIB_H_ */
