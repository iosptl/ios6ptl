//
//  ZipTextView.m
//  ZipText
//
//  Created by Rob Napier on 7/16/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//


#import "ZipTextView.h"

#if REVISION == 4

#import "RNTimer.h"

static const CGFloat kFontSize = 16.0;

@interface ZipTextView ()
@property (nonatomic) NSUInteger index;
@property (nonatomic) RNTimer *timer;
@property (nonatomic) NSString *text;
@property (nonatomic) NSMutableArray *locations;
@end

@implementation ZipTextView

- (id)initWithFrame:(CGRect)frame text:(NSString *)text {
  self = [super initWithFrame:frame];
  if (self) {
    __weak ZipTextView *weakSelf = self;
    _timer = [RNTimer
              repeatingTimerWithTimeInterval:0.01
              block:^{
                [weakSelf appendNextCharacter];
              }];
    _text = [text copy];
    self.backgroundColor = [UIColor whiteColor];
    _locations = [NSMutableArray
                  arrayWithObject:[NSValue
                                   valueWithCGPoint:CGPointZero]];
  }
  return self;
}

- (void)appendNextCharacter {
  self.index++;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  for (NSUInteger i = 0; i <= self.index; i++) {
    if (i < self.text.length) {
      NSString *character = [self.text substringWithRange:
                             NSMakeRange(i, 1)];
      CGPoint origin = [self originAtIndex:i fontSize:kFontSize];
      [character drawAtPoint:origin
                    withFont:[UIFont systemFontOfSize:kFontSize]];
    }
  }
}

- (CGPoint)originAtIndex:(NSUInteger)index
                fontSize:(CGFloat)fontSize {
  if ([self.locations count] > index) {
    return [self.locations[index] CGPointValue];
  }
  else {
    CGPoint origin = [self originAtIndex:index-1 fontSize:fontSize];
    NSString *
    prevCharacter = [self.text
                     substringWithRange:NSMakeRange(index-1,1)];
    CGSize
    prevCharacterSize = [prevCharacter sizeWithFont:
                         [UIFont systemFontOfSize:fontSize]];
    origin.x += prevCharacterSize.width;
    if (origin.x > CGRectGetWidth(self.bounds)) {
      origin.x = 0;
      origin.y += prevCharacterSize.height;
    }
    self.locations[index] = [NSValue valueWithCGPoint:origin];
    return origin;
  }
}

@end
#endif