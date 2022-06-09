/*
 * @file aes_user_interface.h
 * @brif user interface
 *
 *      Author: yebeman
 */


/*******************************************************************************
* Includes
*******************************************************************************/
    
#include <stdio.h>

#include "aes_ui.h"

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
static void aes_ui_help();

/*******************************************************************************
* Interrupt Service Routines
*******************************************************************************/

/*******************************************************************************
* Public Functions
*******************************************************************************/

aes_ui_status_t aes_ui_init() 
{

    // error out if its not with in the legend 
    // else perfom

    return AES_UI_SUCCESS;
}

aes_ui_status_t aes_ui(int argc, char** argv, aes_ui_t *aes_ui)
{
    
    // argc num of arguments passed
    // argv pointer array to each argument
    switch(argc-1)
    {
        case 1: 

            if ((strncmp(argv[1], "-h", strlen( "-h" )) && strncmp(argv[1], "-help", strlen( "-help" ))) == 0)
            {
                aes_ui_help();

                return AES_UI_FAILURE;

            }         
            else
            {
                // show how to use
                aes_ui_help();

                return AES_UI_FAILURE;
            }

        break;
        case 2:
            if ((strncmp(argv[1], "-test", strlen( "-test" )) && strncmp(argv[1], "-test", strlen( "-test" ))) == 0)
            {

                if ( strncmp(argv[2], "-e", strlen( "-e" ))  == 0 )
                {
                    aes_ui->encrypt = true;
                    printf("Peforming Encryption - \n");              

                    aes_ui->input_file.name = ( char *) malloc( strlen("plaintext.file") );
                    strcpy(aes_ui->input_file.name, "plaintext.file");
                    printf("Input file : %s \n", aes_ui->input_file.name);              

                    aes_ui->output_file.name = ( char *) malloc( strlen("cipher.file") );
                    strcpy(aes_ui->output_file.name, "cipher.file");
                    printf("Output file: %s \n", aes_ui->output_file.name); 

                }
                else if ( strncmp(argv[2], "-d", strlen( "-d" ))  == 0 )
                {
                    aes_ui->encrypt = false;
                    printf("Peforming Decryption - \n");              

                    aes_ui->input_file.name = ( char *) malloc( strlen("cipher.file") );
                    strcpy(aes_ui->input_file.name, "cipher.file");
                    printf("Input file : %s \n", aes_ui->input_file.name);              

                    aes_ui->output_file.name = ( char *) malloc( strlen("plaintext.file") );
                    strcpy(aes_ui->output_file.name, "plaintext.file"); 
                    printf("Output file: %s \n", aes_ui->output_file.name); 
                } 

                aes_ui->key.name = ( char *) malloc( strlen("key.file") );
                strcpy(aes_ui->key.name, "key.file"); 
                printf("Key: %s \n\n", aes_ui->key.name); 

            }   
        break;

        case 9:

            // for now loop through all 
            // save info
            for (int _index = 0; _index <= 9; ++_index)
            {

                if ( strncmp(argv[_index], "-e", strlen( "-e" ))  == 0 )
                {
                    aes_ui->encrypt = true;
                }
                else if ( strncmp(argv[_index], "-d", strlen( "-d" ))  == 0 )
                {
                    aes_ui->encrypt = false;
                }                
                else if ( strncmp(argv[_index], "-key", strlen( "-key" )) == 0)
                {
                
                    // create and save
                    aes_ui->key.name = ( char *) malloc( strlen(argv[_index + 1]) );
                    strcpy(aes_ui->key.name, argv[_index + 1]); 

//                    memcpy(aes_ui->key.name, argv[_index + 1], strlen(argv[_index + 1]) );

                }
                else if ( strncmp(argv[_index], "-out", strlen( "-out" )) == 0)
                {
                
                    // create and save
                    aes_ui->output_file.name = ( char *) malloc( strlen(argv[_index + 1]) );
                    strcpy(aes_ui->output_file.name, argv[_index + 1]); 


                   // memcpy(aes_ui->output_file.name, argv[_index + 1], strlen(argv[_index + 1]) );

                }
                else if ( strncmp(argv[_index], "-in", strlen( "-in" )) == 0)
                {
                
                    // create and save
                    aes_ui->input_file.name = ( char *) malloc( strlen(argv[_index + 1]) );
                    strcpy(aes_ui->output_file.name, argv[_index + 1]); 

                //    memcpy(aes_ui->input_file.name, argv[_index + 1], strlen(argv[_index + 1]) );

                }
                else if ( strncmp(argv[_index], "-c", strlen( "-c" )) == 0)
                {

                    if ( strncmp(argv[_index + 1], "ECB_128", strlen( "ECB_128" )) == 0 )
                    {
                    
                        aes_ui->aes_ui_cipher = ECB_128;
                    
                    }

                }

            }


        break;

        default:

            // show how to use
            aes_ui_help();

            return AES_UI_FAILURE;
        break;

    }

    return AES_UI_SUCCESS;

}

/*******************************************************************************
* Private Functions
*******************************************************************************/

static void aes_ui_help()
{

	printf("\n\r AES on DEVICE CLI Usage:\n\r");

    printf("\t%-30s%-8s",
            "-c",
            "- cipher type\n\r");

    printf("\t%-30s%-20s",
            "-d/-e",
            "- decrypt/encrypt \n\r");

    printf("\t%-30s%-20s",
            "-in/-out",
            "- input file / output file\n\r");

    printf("\t%-30s%-14s",
            "-key",
            "- secure key file \n\r");

    printf("\t%-30s%-14s",
            "-h/other",
            "- show usage  \n\n\r");

    printf("\t%-30s%-14s",
            "-test -d/-e",
            "- will do test run of decryption/encryption\n\n\r");

    printf("\n\r eg : ./aes_d -e -key key.file -c ECB_128 -in input.file -out output.file \n\r");
}

