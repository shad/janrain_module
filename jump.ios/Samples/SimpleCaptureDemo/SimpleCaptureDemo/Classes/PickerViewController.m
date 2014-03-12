//
// Created by nathan on 10/9/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PickerViewController.h"


@implementation PickerViewController
{
    UIView *myPickerViewGroup;
    UIToolbar *pickerToolbar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    myPickerViewGroup = [[UIView alloc] initWithFrame:CGRectZero];
    myPickerViewGroup.backgroundColor = [UIColor whiteColor];
    myPickerViewGroup.opaque = YES;

    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                      style:UIBarButtonItemStyleDone target:self
                                                     action:@selector(pickerDone)]];
    [pickerToolbar setItems:items animated:NO];
    [pickerToolbar sizeToFit];

    myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickerToolbar.frame.size.height, 0, 0)];
    myDatePicker.datePickerMode = UIDatePickerModeDate;
    [myDatePicker addTarget:self action:@selector(pickerChanged) forControlEvents:UIControlEventValueChanged];

    [myPickerViewGroup addSubview:myDatePicker];
    [myPickerViewGroup addSubview:pickerToolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    myPickerViewGroup.frame = CGRectMake(0, self.view.window.frame.size.height, pickerToolbar.frame.size.width,
            myDatePicker.frame.size.height + pickerToolbar.frame.size.height);
}

- (void)slidePickerUp
{
    if (myPickerViewGroup.superview == nil)
   	{
   		[self.view.window addSubview:myPickerViewGroup];

        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
   		CGSize pickerSize = myPickerViewGroup.frame.size;
   		CGRect startRect = CGRectMake(0.0,
   									  screenRect.origin.y + screenRect.size.height,
   									  pickerSize.width, pickerSize.height);
   		myPickerViewGroup.frame = startRect;

   		// compute the end frame
   		CGRect pickerRect = CGRectMake(0.0,
   									   screenRect.origin.y + screenRect.size.height - pickerSize.height,
   									   pickerSize.width,
   									   pickerSize.height);

   		// start the slide up animation
        [UIView beginAnimations:@"slidePickerUp" context:nil];
   			[UIView setAnimationDuration:0.3];
   			myPickerViewGroup.frame = pickerRect;
   		[UIView commitAnimations];
   	}
}

- (void)slideDownDidStop
{
	[myPickerViewGroup removeFromSuperview];
}

- (void)slidePickerDown
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
   	CGRect endFrame = myPickerViewGroup.frame;
   	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;

   	// start the slide down animation
    [UIView beginAnimations:@"slidePickerDown" context:nil];
   		[UIView setAnimationDuration:0.3];

   		// we need to perform some post operations after the animation is complete
   		[UIView setAnimationDelegate:self];
   		[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];

   		myPickerViewGroup.frame = endFrame;
   	[UIView commitAnimations];
}

- (void)pickerChanged { }

- (void)pickerDone { }

@end