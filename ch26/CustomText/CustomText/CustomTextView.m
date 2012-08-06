//
//  CustomTextView.m
//  CustomText
//
//  Created by Rob Napier on 8/3/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "CustomTextView.h"
#import <CoreText/CoreText.h>

static const CFIndex kColumnCount = 3;

@interface CustomTextPosition : UITextPosition
@property (nonatomic, readwrite, assign) NSUInteger index;
@end

@implementation CustomTextPosition
@end

@interface CustomTextView ()
@property (nonatomic, readwrite, assign) CFIndex mode;
@end

@implementation CustomTextView

- (CGRect *)copyColumnRects {
  CGRect bounds = CGRectInset([self bounds], 20.0, 20.0);
  
  int column;
  CGRect* columnRects = (CGRect*)calloc(kColumnCount,
                                        sizeof(*columnRects));
  
  // Start by setting the first column to cover the entire view.
  columnRects[0] = bounds;
  // Divide the columns equally across the frame's width.
  CGFloat columnWidth = CGRectGetWidth(bounds) / kColumnCount;
  for (column = 0; column < kColumnCount - 1; column++) {
    CGRectDivide(columnRects[column], &columnRects[column],
                 &columnRects[column + 1], columnWidth,
                 CGRectMinXEdge);
  }
  
  // Inset all columns by a few pixels of margin.
  for (column = 0; column < kColumnCount; column++) {
    columnRects[column] = CGRectInset(columnRects[column],
                                      10.0, 10.0);
  }
  return columnRects;
}

- (CFArrayRef)copyPaths
{
  CFMutableArrayRef
  paths = CFArrayCreateMutable(kCFAllocatorDefault,
                               kColumnCount,
                               &kCFTypeArrayCallBacks);
  
  switch (self.mode) {
    case 0: // 3 columns
    {
      CGRect *columnRects = [self copyColumnRects];
      // Create an array of layout paths, one for each column.
      for (int column = 0; column < kColumnCount; column++) {
        CGPathRef
        path = CGPathCreateWithRect(columnRects[column], NULL);
        CFArrayAppendValue(paths, path);
        CGPathRelease(path);
      }
      free(columnRects);
      break;
    }
      
    case 1: // 3 columns as a single path
    {
      CGRect *columnRects = [self copyColumnRects];
      
      // Create a single path that contains all columns
      CGMutablePathRef path = CGPathCreateMutable();
      for (int column = 0; column < kColumnCount; column++) {
        CGPathAddRect(path, NULL, columnRects[column]);
      }
      free(columnRects);
      CFArrayAppendValue(paths, path);
      CGPathRelease(path);
      break;
    }
      
    case 2: // two columns with box
    {
      CGMutablePathRef path = CGPathCreateMutable();
      CGPathMoveToPoint(path, NULL, 30, 30);  // Bottom left
      CGPathAddLineToPoint(path, NULL, 344, 30);  // Bottom right
      
      CGPathAddLineToPoint(path, NULL, 344, 400);
      CGPathAddLineToPoint(path, NULL, 200, 400);
      CGPathAddLineToPoint(path, NULL, 200, 800);
      CGPathAddLineToPoint(path, NULL, 344, 800);
      
      CGPathAddLineToPoint(path, NULL, 344, 944); // Top right
      CGPathAddLineToPoint(path, NULL, 30, 944);  // Top left
      CGPathCloseSubpath(path);
      CFArrayAppendValue(paths, path);
      CFRelease(path);
      
      path = CGPathCreateMutable();
      CGPathMoveToPoint(path, NULL, 700, 30); // Bottom right
      CGPathAddLineToPoint(path, NULL, 360, 30);  // Bottom left
      
      CGPathAddLineToPoint(path, NULL, 360, 400);
      CGPathAddLineToPoint(path, NULL, 500, 400);
      CGPathAddLineToPoint(path, NULL, 500, 800);
      CGPathAddLineToPoint(path, NULL, 360, 800);
      
      CGPathAddLineToPoint(path, NULL, 360, 944); // Top left
      CGPathAddLineToPoint(path, NULL, 700, 944); // Top right
      CGPathCloseSubpath(path);
      CFArrayAppendValue(paths, path);
      CGPathRelease(path);
      break;
    }
    case 3: // ellipse
    {
      CGPathRef
      path = CGPathCreateWithEllipseInRect(CGRectInset([self bounds],
                                                       30,
                                                       30),
                                           NULL);
      CFArrayAppendValue(paths, path);
      CGPathRelease(path);
      break;
    }
  }
  return paths;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Flip the view's context. Core Text runs bottom to top, even
    // on iPad, and the view is much simpler if we do everything in
    // Mac coordinates.
    //    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    //    CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
    //    self.transform = transform;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  if (self.attributedText == nil)
  {
    return;
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Flip the context (and always initialize your text matrix)
  CGContextSetTextMatrix( context, CGAffineTransformIdentity );
  CGContextTranslateCTM( context, rect.origin.x, rect.origin.y );
  CGContextScaleCTM( context, 1.0f, -1.0f );
  CGContextTranslateCTM( context, rect.origin.x, - ( rect.origin.y + rect.size.height ) );
  
  CFAttributedStringRef
  attrString = (__bridge CFTypeRef)self.attributedText;
  
  CTFramesetterRef
  framesetter = CTFramesetterCreateWithAttributedString(attrString);
  
  CFArrayRef paths = [self copyPaths];
  CFIndex pathCount = CFArrayGetCount(paths);
  CFIndex charIndex = 0;
  for (CFIndex pathIndex = 0; pathIndex < pathCount; ++pathIndex) {
    CGPathRef path = CFArrayGetValueAtIndex(paths, pathIndex);
    
    CTFrameRef
    frame = CTFramesetterCreateFrame(framesetter,
                                     CFRangeMake(charIndex, 0),
                                     path,
                                     NULL);
    CTFrameDraw(frame, context);
    CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    charIndex += frameRange.length;
    CFRelease(frame);
  }
  
  CFRelease(paths);
  CFRelease(framesetter);
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//  self.mode = (self.mode + 1 ) % 4;
//  [self setNeedsDisplay];
//}

@end


//#pragma mark UITextInput
//- (NSString *)textInRange:(UITextRange *)range
//{
//
//}
//- (void)replaceRange:(UITextRange *)range withText:(NSString *)text;
//
///* Text may have a selection, either zero-length (a caret) or ranged.  Editing operations are
// * always performed on the text from this selection.  nil corresponds to no selection. */
//
//@property (readwrite, copy) UITextRange *selectedTextRange;
//
///* If text can be selected, it can be marked. Marked text represents provisionally
// * inserted text that has yet to be confirmed by the user.  It requires unique visual
// * treatment in its display.  If there is any marked text, the selection, whether a
// * caret or an extended range, always resides witihin.
// *
// * Setting marked text either replaces the existing marked text or, if none is present,
// * inserts it from the current selection. */
//
//@property (nonatomic, readonly) UITextRange *markedTextRange;                       // Nil if no marked text.
//@property (nonatomic, copy) NSDictionary *markedTextStyle;                          // Describes how the marked text should be drawn.
//- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange;  // selectedRange is a range within the markedText
//- (void)unmarkText;
//
///* The end and beginning of the the text document. */
//@property (nonatomic, readonly) UITextPosition *beginningOfDocument;
//@property (nonatomic, readonly) UITextPosition *endOfDocument;
//
///* Methods for creating ranges and positions. */
//- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition;
//- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset;
//- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset;
//
///* Simple evaluation of positions */
//- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other;
//- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition;
//
///* A system-provied input delegate is assigned when the system is interested in input changes. */
//@property (nonatomic, assign) id <UITextInputDelegate> inputDelegate;
//
///* A tokenizer must be provided to inform the text input system about text units of varying granularity. */
//@property (nonatomic, readonly) id <UITextInputTokenizer> tokenizer;
//
///* Layout questions. */
//- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction;
//- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction;
//
///* Writing direction */
//- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction;
//- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range;
//
///* Geometry used to provide, for example, a correction rect. */
//- (CGRect)firstRectForRange:(UITextRange *)range;
//- (CGRect)caretRectForPosition:(UITextPosition *)position;
//- (NSArray *)selectionRectsForRange:(UITextRange *)range NS_AVAILABLE_IOS(6_0);       // Returns an array of UITextSelectionRects
//
///* Hit testing. */
//- (UITextPosition *)closestPositionToPoint:(CGPoint)point;
//- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range;
//- (UITextRange *)characterRangeAtPoint:(CGPoint)point;
//
//
//@end
