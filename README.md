To build the project with out debugging 
make

To build the project for debugging 
make dbg=1

Once built. issue ./aes_d -help to see all the options 

sample output:

```
[~/project]$ ./aes_d -help

 AES on DEVICE CLI Usage:
	-c                            - cipher type
	-d/-e                         - decrypt/encrypt 
	-in/-out                      - input file / output file
	-key                          - secure key file
	-h/other                      - show usage  

	-test -d/-e                   - will do test run of decryption/encryption


 eg : ./aes_d -e -key key.file -c ECB_128 -in plaintext.file -out cipher.file 
```

 for comparing output, you can use openssl

