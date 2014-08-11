//
// Created by Petr Korolev on 11/08/14.
//

#import "SKActionSheet.h"


@implementation SKActionSheet
{
    UIView *view;

}
- (void)dismissWithClickedButtonIndex:(int)i animated:(BOOL)animated
{

    [self removeFromSuperview];
}

- (instancetype)initWithView:(UIView *)aView
{
    self = [super initWithFrame:aView.frame];
    if ( self )
    {
        view = aView;
        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)showFromInView:(UIView *)uiView
{
    NSLog(@"%s", sel_getName(_cmd));
    [self showInContainerView:uiView];

}

- (void)showInContainerView:(UIView *)containerView
{
    UIView *origin = nil;
    origin = (containerView.superview ? containerView.superview : containerView);
    CGRect rect = CGRectMake(self.frame.origin.x, origin.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.frame = rect;
    [origin addSubview:self];
}

-(void)actionPickerDone:(id)val
{
    NSLog(@"val = %@", val);
    assert(NO);
}
@end