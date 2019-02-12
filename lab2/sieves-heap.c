/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.

 max under 2s: 23920000
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6
int check = 0;
char * arr;
void print_number(int p) {
  printf("%10d +", p);      
  check++;
  if(check >= COLUMNS) {
    printf("\n");
    check = 0;
  }
}

char * sieve(int n) {
    char * arr = (char*) malloc((n - 1) * sizeof(char));
    for(int i = 2; i < n; i++) {
        arr[i] = 1;
    }
    
    for(int i = 2; i * i <= n; i++){
        if(arr[i]) {
            for(int j = i * i; j < n; j = j + i) {
                arr[j] = 0;
            }
        }
    }
    return arr;
}


void print_mean(int N) {
    char * arr = sieve(N);
    int c = 0; 
    int sum = 0;
    for(int i = 2; i < N; i++) {
        if(arr[i]){
            c++;
            sum += i;
        }
    }

    double mean = ((double) sum / c);
    printf("Mean: %.6f", mean);
    free(arr);
}


void print_sieves(int n){
    char * arr = sieve(n);
    

    int c = 0;
    for(int i = 0; i < n; i++) {
        if(arr[i]) { 
            c++;
            print_number(i);
        }
    }   
    printf("\ncount  = %d\n", c);
    free(arr);
}



// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2) {
    print_sieves(atoi(argv[1]));
    print_mean(atoi(argv[1]));
    }
  else
    printf("Please state an interger number.\n");
  return 0;
}

 
