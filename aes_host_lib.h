/*
 * @file aes_host_lib.h
 * @brif host library
 *
 *      Author: yebeman
 */

#ifndef AES_HOST_LIB_H_
#define AES_HOST_LIB_H_



#ifdef __cplusplus
extern "C" {
#endif




/*******************************************************************************
* Public Definitions
*******************************************************************************/

//typedefs

// function status
typedef enum
{

    AES_HOST_LIB_SUCCESS   =    0,   /** Successfully Completed */
    AES_HOST_LIB_FAILURE   =    1   

} aes_host_lib_status_t;


//constants

//macros
#define BLOCK_SIZE 256

/*******************************************************************************
* Public Functions
*******************************************************************************/


/**
* \brief device init
*
* \return  aes_host_lib_status_t
*/
aes_host_lib_status_t aes_host_lib_init();

aes_host_lib_status_t aes_host_lib_read_file(aes_ui_file_t *aes_ui_file, bool isPadding);
aes_host_lib_status_t aes_host_lib_write_file( aes_ui_file_t *aes_ui_file);



#ifdef __cplusplus
}
#endif



#endif /* AES_HOST_LIB_H_ */
