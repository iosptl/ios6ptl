//
//  Chapter13_KVC_CollectionViewController.h
//  Chapter13-KVC-Collection
//
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UILabel *entryLabel;

- (IBAction)performAdd;

@end
