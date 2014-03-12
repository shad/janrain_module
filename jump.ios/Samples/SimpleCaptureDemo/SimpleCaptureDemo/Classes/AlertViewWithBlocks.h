// Thanks to http://stackoverflow.com/questions/10082383/block-for-uialertviewdelegate

@interface AlertViewWithBlocks : UIAlertView <UIAlertViewDelegate>
- (id)initWithTitle:(NSString *)title message:(NSString *)message
         completion:(void (^)(UIAlertView *, BOOL, NSInteger))completion style:(UIAlertViewStyle)style
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;


@end
