/*
 * @file aes_engine.h
 * @brif aes engine
 *
 *      Author: yebeman
 */

#ifndef AES_ENGINE_H_
#define AES_ENGINE_H_



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

    AES_ENGINE_SUCCESS   =    0,   /** Successfully Completed */
    AES_ENGINE_FAILURE   =    1   

} aes_engine_status_t;



//constants


//macros

/*******************************************************************************
* Public Functions
*******************************************************************************/


/**
* \brief device init
*
* \return  aes_host_lib_status_t
*/
aes_engine_status_t aes_engine_init();

aes_engine_status_t aes_engine(aes_ui_t *aes_ui);


#ifdef __cplusplus
}
#endif



#endif /* AES_ENGINE_H_ */
