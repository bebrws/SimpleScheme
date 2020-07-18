//
//  chickenrun.c
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/17/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

#include "chickenrun.h"
#include "chicken.h"

#include <assert.h>

static int hasBeenSetup = 0;

C_word k = C_SCHEME_UNDEFINED;


int chickenrunread(const char *readstr) {
    
    if (!hasBeenSetup) {
        C_word rs = CHICKEN_run((void*)CHICKEN_default_toplevel);
        printf("\nrs: %l\n", rs);
        hasBeenSetup = 1;
    }

    C_word resess;
    C_word readess = CHICKEN_read(readstr, &resess);
//    printf("\readess: %s\n", readess);
    
    return 0;
}

int chickenrunfile(const char *filename) {
    
    if (!hasBeenSetup) {
        C_word rs = CHICKEN_run((void*)CHICKEN_default_toplevel);
        printf("\nrs: %l\n", rs);
        hasBeenSetup = 1;
    }

    
    C_word ess = CHICKEN_load(filename);
//    printf("\nfileess: %s\n", ess);
    
    return 0;
}

int chickenrun(const char *strToRun) {
    
    if (!hasBeenSetup) {
        C_word rs = CHICKEN_run((void*)CHICKEN_default_toplevel);
        printf("\nrs: %l\n", rs);
        hasBeenSetup = 1;
    }
    
//    k = CHICKEN_continue(k);
//    print("k: " + String(k))
    char resultstr[10000];
    C_word ess = CHICKEN_eval_string_to_string(strToRun, &resultstr, 999);
//    printf("\ness: %s\n", resultstr);
    
    CHICKEN_yield();
    
//    k = CHICKEN_continue(k);
    return 0;
}
