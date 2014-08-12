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

    CGRect rect = CGRectMake(_origin.frame.origin.x, _origin.frame.origin.y, _origin.frame.size.width, _origin.frame.size.height + aView.frame.size.height);
    self = [super initWithFrame:rect];
    if ( self )
    {
        view = aView;
        CGRect cgRect = CGRectMake(view.frame.origin.x, _origin.frame.size.height, view.frame.size.width, view.frame.size.height);
        view.frame = cgRect;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
        _bgView = [[UIView alloc] initWithFrame:view.frame];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [self addSubview:aView];

    }

    return self;
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

@end