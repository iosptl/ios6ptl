//
//  RNCryptManager.h
//  CryptPic
//
//  Created by Rob Napier on 8/9/11.
//  Copyright (c) 2011 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

extern NSString * const kRNCryptManagerErrorDomain;

@interface RNCryptManager : NSObject
+ (BOOL)encryptFromStream:(NSInputStream *)fromStream
                 toStream:(NSOutputStream *)toStream
                 password:(NSString *)password
                    error:(NSError **)error;

+ (BOOL)decryptFromStream:(NSInputStream *)fromStream
                 toStream:(NSOutputStream *)toStream
                 password:(NSString *)password
                    error:(NSError **)error;

+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                              iv:(NSData **)iv
                            salt:(NSData **)salt
                           error:(NSError **)error;

+ (NSData *)decryptedDataForData:(NSData *)data
                        password:(NSString *)password 
                              iv:(NSData *)iv
                            salt:(NSData *)salt
                           error:(NSError **)error;
@end
