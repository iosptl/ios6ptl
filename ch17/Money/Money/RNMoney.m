#import "RNMoney.h"

@implementation RNMoney

@synthesize amount=amount_;
@synthesize currencyCode=currencyCode_;

static NSString * const kRNMoneyAmountKey = @"amount";
static NSString * const kRNMoneyCurrencyCodeKey =
                                           @"currencyCode";

- (RNMoney *)initWithAmount:(NSDecimalNumber *)anAmount 
               currencyCode:(NSString *)aCode {
  if ((self = [super init])) {
    amount_ = anAmount;
    if (aCode == nil) {
      NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
      currencyCode_ = [formatter currencyCode];
    }
    else {
      currencyCode_ = aCode;
    }
  }
  return self;
}

- (RNMoney *)initWithAmount:(NSDecimalNumber *)anAmount {
  return [self initWithAmount:anAmount
                 currencyCode:nil];
}

- (RNMoney *)initWithIntegerAmount:(NSInteger)anAmount
                      currencyCode:(NSString *)aCode {
    return [self initWithAmount:
            [NSDecimalNumber decimalNumberWithDecimal:
             [[NSNumber numberWithInteger:anAmount]
              decimalValue]]
                   currencyCode:aCode];
}

- (RNMoney *)initWithIntegerAmount:(NSInteger)anAmount {
  return [self initWithIntegerAmount:anAmount
                        currencyCode:nil];
}

- (id)init {
  return [self initWithAmount:[NSDecimalNumber zero]];
}

- (id)initWithCoder:(NSCoder *)coder {
  
  NSDecimalNumber *amount = [coder decodeObjectForKey:
                             kRNMoneyAmountKey];
  NSString *currencyCode = [coder decodeObjectForKey:
                            kRNMoneyCurrencyCodeKey];
  return [self initWithAmount:amount
                 currencyCode:currencyCode];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:amount_ forKey:kRNMoneyAmountKey];
  [aCoder encodeObject:currencyCode_
                forKey:kRNMoneyCurrencyCodeKey];
}

- (NSString *)localizedStringForLocale:(NSLocale *)aLocale 
{
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] 
                                  init];
  [formatter setLocale:aLocale];
  [formatter setCurrencyCode:self.currencyCode];
  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  return [formatter stringFromNumber:self.amount];
}

- (NSString *)localizedString {
  return [self localizedStringForLocale:
          [NSLocale currentLocale]];
}

- (NSString *)description {
  return [self localizedString];
}

@end
