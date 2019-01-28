/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6

int is_prime(int n){
  if(n <= 3) {
    return (n > 1);
  }
  else if((n % 2) == 0 || (n % 3) == 0) {
    return 0;
  }

  int i = 5;

  while(i * i <= n) {
    if(n % i ==  0 || n % (i + 2) == 0)
      return 0; 
    i += 6;
  }

  return 1;
}


void print_primes(int n){
  // Should print out all prime numbers less than 'n'
  // with the following formatting. Note that
  // the number of columns is stated in the define
  // COLUMNS
  int formatting = 0;

  for(int i = 0; i < n; i++) {
    if(is_prime(i) == 1) {
      printf("%10d ", i);

      formatting++;
      if(formatting == 6) {
        printf("\n");
        formatting = 0;
      }
    }

  }
  printf("\n");
}



// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_primes(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}

 
