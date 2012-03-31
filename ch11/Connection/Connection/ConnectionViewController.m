//
//  ConnectionViewController.m
//  Connection
//
//  Created by Rob Napier on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConnectionViewController.h"

CFAbsoluteTime SecCertificateNotValidBefore(SecCertificateRef certificate);
CFAbsoluteTime SecCertificateNotValidAfter(SecCertificateRef certificate);

@implementation ConnectionViewController
@synthesize connection=connection_;

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // IP Address for encrypted.google.com
//  NSURL *url = [NSURL URLWithString:@"https://72.14.204.113"];
  NSURL *url = [NSURL URLWithString:@"https://encrypted.google.com"];

  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  self.connection = [NSURLConnection connectionWithRequest:request
                                                  delegate:self];
}

static OSStatus RNSecTrustEvaluateAsX509(SecTrustRef trust,
                                         SecTrustResultType *result
                                         )
{
  OSStatus status = errSecSuccess;

  SecPolicyRef policy = SecPolicyCreateBasicX509();
  SecTrustRef newTrust;
  CFIndex numberOfCerts = SecTrustGetCertificateCount(trust);
  CFMutableArrayRef certs;
  certs = CFArrayCreateMutable(NULL,
                               numberOfCerts,
                               &kCFTypeArrayCallBacks);
  for (NSUInteger index = 0; index < numberOfCerts; ++index) {
    SecCertificateRef cert;
    cert = SecTrustGetCertificateAtIndex(trust, index);
    CFArrayAppendValue(certs, cert);
  }

  status = SecTrustCreateWithCertificates(certs,
                                          policy,
                                          &newTrust);
  if (status == errSecSuccess) {
    status = SecTrustEvaluate(newTrust, result);
  }

  CFRelease(policy);
  CFRelease(newTrust);
  CFRelease(certs);
  
  return status;
}

- (void)connection:(NSURLConnection *)connection
  willSendRequestForAuthenticationChallenge:
  (NSURLAuthenticationChallenge *)challenge
{
  NSURLProtectionSpace *protSpace = challenge.protectionSpace;
  SecTrustRef trust = protSpace.serverTrust;
  SecTrustResultType result = kSecTrustResultFatalTrustFailure;
    
  OSStatus status = SecTrustEvaluate(trust, &result);
  if (status == errSecSuccess && 
      result == kSecTrustResultRecoverableTrustFailure) {
    SecCertificateRef cert = SecTrustGetCertificateAtIndex(trust, 
                                                           0);
    CFStringRef subject = SecCertificateCopySubjectSummary(cert);

    CFAbsoluteTime start = SecCertificateNotValidBefore(cert);
    CFAbsoluteTime end = SecCertificateNotValidAfter(cert);

    NSLog(@"Begin Date: %@", [NSDate dateWithTimeIntervalSinceReferenceDate:start]);
    NSLog(@"End Date: %@", [NSDate dateWithTimeIntervalSinceReferenceDate:end]);          
    
    NSLog(@"Trying to access %@. Got %@.", protSpace.host, 
          (__bridge id)subject);
    CFRange range = CFStringFind(subject, CFSTR(".google.com"), 
                                 kCFCompareAnchored|
                                 kCFCompareBackwards);
    if (range.location != kCFNotFound) {
      status = RNSecTrustEvaluateAsX509(trust, &result);
    }
    CFRelease(subject);
  }
  

  if (status == errSecSuccess) { 
    switch (result) {
      case kSecTrustResultInvalid:
      case kSecTrustResultDeny:
      case kSecTrustResultFatalTrustFailure:
      case kSecTrustResultOtherError:
// We've tried everything:
      case kSecTrustResultRecoverableTrustFailure:  
        NSLog(@"Failing due to result: %lu", result);
        [challenge.sender cancelAuthenticationChallenge:challenge];
        break;
        
      case kSecTrustResultProceed:
      case kSecTrustResultConfirm:
      case kSecTrustResultUnspecified: {
        NSLog(@"Successing with result: %lu", result);
        NSURLCredential *cred;
        cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred 
             forAuthenticationChallenge:challenge];  
        }
        break;
        
      default:
        NSAssert(NO, @"Unexpected result from trust evaluation:%d", 
                 result);
        break;
    }
  }
  else {
    // Something was broken
    NSLog(@"Complete failure with code: %lu", status);
    [challenge.sender cancelAuthenticationChallenge:challenge];
  }
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError:%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"didFinishLoading");
  self.connection = nil;
}

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
//
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
//
//- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request;
//- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
// totalBytesWritten:(NSInteger)totalBytesWritten
//totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
