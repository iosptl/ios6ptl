//
//  ZipTextView.m
//  ZipText
//
//  Created by Rob Napier on 7/16/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//


#import "ZipTextView.h"

#if REVISION == 2

#import "RNTimer.h"

static const CGFloat kFontSize = 16.0;

@interface ZipTextView ()
@property (nonatomic) NSUInteger index;
@property (nonatomic) RNTimer *timer;
@property (nonatomic) NSString *text;
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
  }
  return self;
}

- (void)appendNextCharacter {
  NSUInteger i = self.index;
  if (i < self.text.length) {
    UILabel *label = [[UILabel alloc] init];
    label.text = [self.text substringWithRange:NSMakeRange(i,1)];
    label.opaque = NO;
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin = [self originAtIndex:i
                              fontSize:label.font.pointSize];
    label.frame = frame;
    [self addSubview:label];
  }
  self.index++;
}

- (CGPoint)originAtIndex:(NSUInteger)index
                fontSize:(CGFloat)fontSize {
  if (index == 0) {
    return CGPointZero;
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
    return origin;
  }
}

@end
#endif