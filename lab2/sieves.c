/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.

    Biggest number: 2 093 691 
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6
int check = 0;

void print_number(int p) {
  printf("%10d ", p);      
  check++;
  if(check >= 6) {
    printf("\n");
    check = 0;
  }
}





void print_sieves(int n){
    char arr[n];
    printf("arr: %ul, n: %d\n", sizeof(arr), n);
    
    for(int i = 0; i < n; i++) {
        arr[i] = 1;
    }
    
    for(int i = 0; i * i <= n; i++){
        if((i == 0) || (i == 1)){
            arr[i] = 0;
        }
        else if(arr[i]) {
            for(int j = i * i; j < n; j = j + i) {
                arr[j] = 0;
            }
        }
    }
 
    for(int i = 0; i < n; i++) {
        if(arr[i]) { 
            print_number(i);
        }
    }   
    printf("\n");
    
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

 
