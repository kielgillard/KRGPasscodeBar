//
//  KRGPasscodeViewController.m
//  Passcodes
//
//  Created by Kiel Gillard on 27/08/12.
//  Copyright (c) 2012 Kiel Gillard. All rights reserved.
//

#import "KRGPasscodeViewController.h"
#import "KRGPasscodeBar.h"

@interface KRGPasscodeViewController ()
@property (nonatomic, strong) KRGPasscodeBar *passcodeBar;
@end

@implementation KRGPasscodeViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
    
    KRGPasscodeBar *passcodeBar = [[KRGPasscodeBar alloc] initWithFrame:CGRectZero];
    [view addSubview:passcodeBar];
    
    self.passcodeBar = passcodeBar;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    KRGPasscodeBar *passcodeBar = self.passcodeBar;
    CGRect frame = passcodeBar.frame;
    frame.origin.x = 0.0;
    frame.origin.y = CGRectGetHeight(bounds) - KRGPasscodeBarHeight;
    passcodeBar.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self beginObservingKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.passcodeBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self endObservingKeyboard];
}

#pragma mark - Working With Keyboards -

- (void)beginObservingKeyboard
{
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [dc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)endObservingKeyboard
{
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [dc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0
                        options:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         CGRect frame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                         frame = [self.view convertRect:frame fromView:nil];
                         CGRect f = self.passcodeBar.frame;
                         f = CGRectApplyAffineTransform(f, CGAffineTransformMakeTranslation(0.0, -CGRectGetHeight(frame)));
                         self.passcodeBar.frame = f;
                     } completion:nil];
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0
                        options:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         CGRect frame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
                         frame = [self.view convertRect:frame fromView:nil];
                         CGRect f = self.passcodeBar.frame;
                         f = CGRectApplyAffineTransform(f, CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(frame)));
                         self.passcodeBar.frame = f;
                     } completion:nil];
}


#pragma mark - Orientation Support -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
