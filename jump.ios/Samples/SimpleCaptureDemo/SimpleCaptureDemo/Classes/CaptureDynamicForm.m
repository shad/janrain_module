#import "CaptureDynamicForm.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "JRCaptureError.h"
#import "JRCaptureUser+Extras.h"
#import "debug_log.h"

static NSMutableDictionary *identifierMap = nil;

@interface CaptureDynamicForm ()
@property(nonatomic, strong) JRCaptureUser *captureUser;
@property(nonatomic, strong) UIBarButtonItem *registerButton;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UILabel *disclaimer;
@property(nonatomic, strong) UIView *formView;
@end

/**
 * This form is a too-complicated sample form, which uses autolayout to programmatically build a view
 * hierarchy for a statically known set of form fields.
 */
@implementation CaptureDynamicForm
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.captureUser = [JRCaptureUser captureUser];
}

- (void)loadView
{
    [self buildFormView];

    CGRect scrollFrame = [[UIScreen mainScreen] applicationFrame];
    CGSize formSize = [self.formView sizeThatFits:scrollFrame.size];
    
    self.title = @"DEMO";
    [self setupToolbar];
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    //scrollView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0,
    //        self.navigationController.toolbar.frame.size.height, 0);
    self.scrollView.contentSize = formSize;
    [self.scrollView addSubview:self.formView];

    self.view = self.scrollView;
}

- (void)buildFormView
{
    self.formView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.formView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    //"email","displayName","firstName","lastName","password","password_confirm"
    [self addTitleLabel:@"Traditional Registration" view:self.formView];
    [self addTextFieldFormLabeled:@"Email" forAttrName:@"email" view:self.formView];
    [self addTextFieldFormLabeled:@"Display Name" forAttrName:@"displayName" view:self.formView];
    [self addTextFieldFormLabeled:@"First" forAttrName:@"givenName" view:self.formView];
    [self addTextFieldFormLabeled:@"Last" forAttrName:@"familyName" view:self.formView];
    [self addTextFieldFormLabeled:@"Password" forAttrName:@"password" view:self.formView];
    NSString *disclaimerText = @"This is just a sample form, it is NOT stock user experience.";
    self.disclaimer = [self addTitleLabel:disclaimerText view:self.formView];
    self.disclaimer.lineBreakMode = NSLineBreakByWordWrapping;
    self.disclaimer.numberOfLines = 0;
    [self.disclaimer setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisVertical];
    //[self addTextFieldFormLabeled:@"Confirm" forAttrName:@"password" view:formView];
    //CGSize formSize = [formView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];DLog(@"formSize: %@", NSStringFromCGSize(formSize));
    DLog(@"disclaimer: %@", self.disclaimer);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^(){
        self.navigationController.toolbarHidden = YES;
    }];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.disclaimer.preferredMaxLayoutWidth = self.view.bounds.size.width - 40;
}

- (void)setupToolbar
{
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:self action:nil];
    self.registerButton = [[UIBarButtonItem alloc] initWithTitle:@"Register"
                                                           style:UIBarButtonItemStyleDone
                                                          target:self action:@selector(registerUser)];
    self.toolbarItems = @[flex, self.registerButton, flex];
    [UIView animateWithDuration:0.3 animations:^(){
        self.navigationController.toolbarHidden = NO;
    }];
}

- (void)registerUser
{
    [JRCapture registerNewUser:self.captureUser socialRegistrationToken:nil forDelegate:self];
    self.registerButton.enabled = NO;
}

- (void)registerUserDidSucceed:(JRCaptureUser *)registeredUser
{
    appDelegate.captureUser = registeredUser;
    [Utils handleSuccessWithTitle:@"Registration Complete" message:nil forVc:self];
}

- (void)captureDidSucceedWithCode:(NSString *)code {
    DLog(@"Authorization Code: %@",code);
}

- (void)registerUserDidFailWithError:(NSError *)error
{
    self.registerButton.enabled = YES;
    if ([error isJRFormValidationError])
    {
        NSDictionary *invalidFieldLocalizedFailureMessages = [error JRValidationFailureMessages];
        [Utils handleFailureWithTitle:@"Invalid Form Submission"
                              message:[invalidFieldLocalizedFailureMessages description]];

    }
    else
    {
        [Utils handleFailureWithTitle:@"Registration Failed" message:[error localizedDescription]];
    }
}

- (UILabel *)addTitleLabel:(NSString *)titleText view:(UIView *)view
{
    UIView *lastSubView = [[view subviews] lastObject];
    UILabel *label = [self addLabelWithText:titleText toSuperView:view];
    NSDictionary *views = NSDictionaryOfVariableBindings(label);

    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|"
                                                                 options:NSLayoutFormatAlignAllTop
                                                                 metrics:nil views:views]];
    [self appendViewToVerticalLayout:label view:view lastSubView:lastSubView];
    return label;
}

- (void)appendViewToVerticalLayout:(UIView *)v view:(UIView *)view lastSubView:(UIView *)lastSubView
{
    NSDictionary *views = lastSubView ? NSDictionaryOfVariableBindings(v, lastSubView)
            : NSDictionaryOfVariableBindings(v);

    if (lastSubView)
    {
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastSubView]-[v]"
                                                                     options:(NSLayoutFormatOptions) 0
                                                                     metrics:nil views:views]];
    }
    else
    {
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[v]"
                                                                     options:(NSLayoutFormatOptions) 0
                                                                     metrics:nil views:views]];
    }
}

- (UITextField *)addTextFieldToSuperView:(UIView *)superview identifier:(NSString *)identifier
                                hintText:(NSString *)hintText
{
    UITextField *textField = [[UITextField alloc] init];
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    textField.placeholder = hintText;
    [superview addSubview:textField];
    textField.tag = [self intTagForIdentifier:identifier];
    return textField;
}

- (NSInteger)intTagForIdentifier:(NSString *)string
{
    static NSInteger index = 0;
    if (!identifierMap) identifierMap = [NSMutableDictionary dictionary];
    if ([identifierMap objectForKey:string]) return [[identifierMap objectForKey:string] integerValue];
    else [identifierMap setObject:[NSNumber numberWithInteger:index] forKey:string];
    return index++;
}

- (NSString *)identifierForIntTag:(NSInteger)i
{
    return [[identifierMap allKeysForObject:[NSNumber numberWithInteger:i]] lastObject];
}

- (void)addTextFieldFormLabeled:(NSString *)labelText forAttrName:(NSString *)attrName view:(UIView *)view
{
    UIView *lastSubView = [view.subviews lastObject];
    UILabel *label = [self addLabelWithText:labelText toSuperView:view];
    UITextField *field = [self addTextFieldToSuperView:view identifier:attrName hintText:labelText];

    NSDictionary *views = NSDictionaryOfVariableBindings(label, field);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label(100)]-[field]-|"
                                                                 options:NSLayoutFormatAlignAllBaseline
                                                                 metrics:nil views:views]];

    [self appendViewToVerticalLayout:field view:view lastSubView:lastSubView];
}

- (UILabel *)addLabelWithText:(NSString *)labelText toSuperView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:label];
    label.text = labelText;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

static CGPoint oldContentOffset;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    oldContentOffset = [self.scrollView contentOffset];
    CGRect rect = textField.frame;
    [self.scrollView scrollRectToVisible:[self.view convertRect:rect fromView:textField] animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *identifier = [self identifierForIntTag:textField.tag];
    [self.captureUser setValue:textField.text forKey:identifier];
    [UIView animateWithDuration:0.3 animations:^(){
        self.scrollView.contentOffset = oldContentOffset;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end