//
//  MYStringConversion.c
//  Chapter17
//

#include <CoreFoundation/CoreFoundation.h>
#include <malloc/malloc.h> // For malloc_size()

#include "MYStringConversion.h"

char * MYCFStringCopyUTF8String(CFStringRef aString) {
  if (aString == NULL) {
    return NULL;
  }
  
  CFIndex length = CFStringGetLength(aString);
  CFIndex maxSize =
  CFStringGetMaximumSizeForEncoding(length,
                                    kCFStringEncodingUTF8);
  char *buffer = (char *)malloc(maxSize);
  if (CFStringGetCString(aString, buffer, maxSize,
                         kCFStringEncodingUTF8)) {
    return buffer;
  }
  return NULL;
}

const char * MYCFStringGetUTF8String(CFStringRef aString, 
                                     char **buffer) {
  if (aString == NULL) {
    return NULL;
  }
  
  const char *cstr = CFStringGetCStringPtr(aString, 
                                           kCFStringEncodingUTF8);
  if (cstr == NULL) {
    CFIndex length = CFStringGetLength(aString);
    CFIndex maxSize =
    CFStringGetMaximumSizeForEncoding(length,
                                      kCFStringEncodingUTF8) + 1; // +1 for NULL
    if (maxSize > malloc_size(buffer)) {
      *buffer = realloc(*buffer, maxSize);
    }
    if (CFStringGetCString(aString, *buffer, maxSize,
                           kCFStringEncodingUTF8)) {
      cstr = *buffer;
    }
  }
  return cstr;
}
