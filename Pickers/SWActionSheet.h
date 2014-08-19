//
// Created by Petr Korolev on 11/08/14.
//

#import <Foundation/Foundation.h>


@interface SWActionSheet : UIView
@property(nonatomic, strong) UIView *origin;

@property(nonatomic, strong) UIView *bgView;

- (void)dismissWithClickedButtonIndex:(int)i animated:(BOOL)animated;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

- (id)initWithView:(UIView *)view;

- (void)showInContainerView;
@end