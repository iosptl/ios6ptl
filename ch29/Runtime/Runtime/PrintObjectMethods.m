//
//  PrintObjectMethods.m
//  Runtime
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PrintObjectMethods.h"

void PrintObjectMethods() {
  unsigned int count = 0;
  Method *methods = class_copyMethodList([NSObject class],
                                         &count);
  for (unsigned int i = 0; i < count; ++i) {
    SEL sel = method_getName(methods[i]);
    const char *name = sel_getName(sel);
    printf("%s\n", name);
  }
  free(methods);
}
