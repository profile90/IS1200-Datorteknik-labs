/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6


void print_sieves(int n){
    printf("Running!\n  ");
    int * arr = (int*) malloc(n * (sizeof(int)));
    printf("Running!\n  ");
    
    for(int i = 0; i < n; i++) {
        arr[i] = 1;
        printf("%d", arr[i]);
    }
    printf("Running!\n  ");
    
    for(int i = 2; i * i < n; i++){
        if(arr[i]) {
            for(int j = i * i + 1; j < n; j = j + i) {
                arr[j] = 0;
            }
        }
    }
    printf("Running!\n  ");

    int formatting = 0;
    
    for(int i = 0; i < n; i++) {
        
        if(arr[i]) {
            printf("%10d ", i);
        }

        formatting++;
        if(formatting == 6) {
            printf("\n");
            formatting = 0;
        }

    }   

    free(arr);
}



// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}

 
