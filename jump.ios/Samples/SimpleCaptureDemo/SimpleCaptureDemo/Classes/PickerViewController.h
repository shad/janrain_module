//
// Created by nathan on 10/9/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PickerViewController : UIViewController
{
    UIDatePicker *myDatePicker;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)slidePickerUp;
- (void)slidePickerDown;
- (void)pickerChanged;
- (void)pickerDone;
@end