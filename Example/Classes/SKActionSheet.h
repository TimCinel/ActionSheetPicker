//
// Created by Petr Korolev on 11/08/14.
//

#import <Foundation/Foundation.h>


@interface SKActionSheet : UIView
- (void)dismissWithClickedButtonIndex:(int)i animated:(BOOL)animated;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

- (id)initWithView:(UIView *)view;

- (void)showFromInView:(UIView *)uiView;

- (void)showInContainerView:(UIView *)containerView;
@end