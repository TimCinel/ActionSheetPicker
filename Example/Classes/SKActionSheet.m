//
// Created by Petr Korolev on 11/08/14.
//

#import "SKActionSheet.h"


static const float delay = 0.f;

static const float duration = .5f;

static const enum UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseIn;

@implementation SKActionSheet
{
    UIView *view;

}
- (void)dismissWithClickedButtonIndex:(int)i animated:(BOOL)animated
{
    UIView *origin = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    CGPoint fadeOutToPoint = CGPointMake(self.center.x,
            origin.bounds.size.height + CGRectGetHeight(self.frame) / 2.f);

    [UIView animateWithDuration:duration delay:delay
                        options:options animations:^{
         self.center = fadeOutToPoint;
     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
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
    [self showInContainerView];
}

- (void)showInContainerView
{
    UIView *origin = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    CGRect rect = CGRectMake(self.frame.origin.x, origin.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.frame = rect;
    [origin addSubview:self];

    CGPoint toPoint;
    CGFloat y = origin.bounds.size.height - CGRectGetHeight(self.frame) / 2.0f;
    toPoint = CGPointMake(self.center.x, y);

    [UIView animateWithDuration:duration delay:delay
                        options:options animations:^{
         self.center = toPoint;
     }
                     completion:^(BOOL finished) {

                     }];

}

@end