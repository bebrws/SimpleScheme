//
//  chickenrun.c
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/17/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

#include "chickenrun.h"
#include "chicken.h"

static int hasBeenSetup = 0;

int chickenrun(const char *strToRun) {
    if (!hasBeenSetup) {
        CHICKEN_run((void*)CHICKEN_default_toplevel);
        hasBeenSetup = 1;
    }
    int res;
    return CHICKEN_eval_string(strToRun, &res);
}
