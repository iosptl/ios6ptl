//
//  CustomTextView.h
//  CustomText
//
//  Created by Rob Napier on 8/3/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UIView // <UITextInput>
@property (nonatomic, readwrite, copy) NSAttributedString *attributedText;
@end
