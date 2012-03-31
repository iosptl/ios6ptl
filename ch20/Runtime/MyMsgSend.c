//
//  MyMsgSend.c
//  Runtime
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include <objc/runtime.h>
#include "MyMsgSend.h"

static const void *myMsgSend(id receiver, const char *name) {
  SEL selector = sel_registerName(name);
  IMP methodIMP =
  class_getMethodImplementation(object_getClass(receiver),
                                selector);
  return methodIMP(receiver, selector);
}

void RunMyMsgSend() {
  // NSObject *object = [[NSObject alloc] init];
  Class class = (Class)objc_getClass("NSObject");
  id object = class_createInstance(class, 0);
  myMsgSend(object, "init");
  
  // id description = [object description];
  id description = (__bridge id)myMsgSend(object, "description");
  
  // const char *cstr = [description UTF8String];
  const char *cstr = myMsgSend(description, "UTF8String");
  
  printf("%s\n", cstr);
}
