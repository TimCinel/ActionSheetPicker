//
// Created by Petr Korolev on 11/08/14.
//

#import "SWActionSheet.h"


static const float delay = 0.f;

static const float duration = .3f;

static const enum UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseIn;

@implementation SWActionSheet
{
    UIView *view;

    UIView *_origin;
    UIView *_bgView;
}
- (void)dismissWithClickedButtonIndex:(int)i animated:(BOOL)animated
{
    CGPoint fadeOutToPoint = CGPointMake(view.center.x,
            self.center.y + CGRectGetHeight(view.frame));

    [UIView animateWithDuration:duration delay:delay
                        options:options animations:^{
         self.center = fadeOutToPoint;
         self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (instancetype)initWithView:(UIView *)aView
{
    _origin = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];

    CGRect rect = [self getRectForPicker:aView];
    self = [super initWithFrame:rect];
    if ( self )
    {
        view = aView;
        CGRect cgRect = CGRectMake(view.bounds.origin.x, _origin.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.frame = cgRect;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
        _bgView = [[UIView alloc] initWithFrame:view.frame];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [self addSubview:aView];

    }

    return self;
}

- (CGRect)getRectForPicker:(UIView *)aView
{
    CGRect rect;
        rect = CGRectMake(_origin.bounds.origin.x, _origin.bounds.origin.y, _origin.bounds.size.width, _origin.bounds.size.height + aView.bounds.size.height);
    return rect;
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    [self showInContainerView];
}

- (void)showInContainerView
{
    [_origin addSubview:self];
    CGPoint toPoint;
    CGFloat y = self.center.y - CGRectGetHeight(view.frame);
    toPoint = CGPointMake(self.center.x, y);

    [UIView animateWithDuration:duration delay:delay
                        options:options animations:^{
         self.center = toPoint;
         self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
     }
                     completion:^(BOOL finished) {

                     }];

}

- (BOOL)isViewPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

@end