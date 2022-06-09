/*
 * @file aes_ui.h
 * @brif user interface library
 *
 *      Author: yebeman
 */

#ifndef AES_UI_H_
#define AES_UI_H_



#ifdef __cplusplus
extern "C" {
#endif




/*******************************************************************************
* Public Definitions
*******************************************************************************/

// function status
typedef enum
{

    AES_UI_SUCCESS   =    0,    /** Successfully Completed */
    AES_UI_FAILURE   =    1     /** Successfully Completed */

} aes_ui_status_t;



typedef enum 
{

	ECB_128

} aes_ui_cipher_t;


typedef struct
{

    char* name;
	size_t size;
	size_t padded_size;
	unsigned char* content;

}aes_ui_file_t;


typedef struct 
{

	aes_ui_cipher_t aes_ui_cipher;

	bool  encrypt;     /* encrypt : 1, decrypt : 0 */

    aes_ui_file_t input_file;
	aes_ui_file_t output_file;
    aes_ui_file_t key;

	
} aes_ui_t;


//constants

//macros

//./aes_d -e -key key.txt -c CTR_256 -in clear.txt -out output.file

/*******************************************************************************
* Public Functions
*******************************************************************************/


/**
* \brief user interface init
*
* \return  aes_ui_status_t
*/
aes_ui_status_t aes_ui_init();


aes_ui_status_t aes_ui(int argc, char** argv, aes_ui_t *aes_ui);


#ifdef __cplusplus
}
#endif



#endif /* AES_UI_H_ */
