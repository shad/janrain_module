// Thanks to http://stackoverflow.com/questions/10082383/block-for-uialertviewdelegate

#import "AlertViewWithBlocks.h"

@interface AlertViewWithBlocks ()
@property (copy, nonatomic) void (^completion)(UIAlertView *, BOOL, NSInteger);
@end

@implementation AlertViewWithBlocks

@synthesize completion=_completion;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
         completion:(void (^)(UIAlertView *alertView, BOOL cancelled, NSInteger buttonIndex))completion
              style:(UIAlertViewStyle)style
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{

    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:nil];

    if (self)
    {
        self.alertViewStyle = style;
        _completion = completion;

        va_list _arguments;
        va_start(_arguments, otherButtonTitles);

        for (NSString *key = otherButtonTitles; key != nil; key = va_arg(_arguments, NSString *))
        {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.completion(alertView, buttonIndex == self.cancelButtonIndex, buttonIndex);
}
@end