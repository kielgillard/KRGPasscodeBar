//
//  KRGPasscodeBar.m
//  Passcodes
//
//  Created by Kiel Gillard on 27/08/12.
//  Copyright (c) 2012 Kiel Gillard. All rights reserved.
//

#import "KRGPasscodeBar.h"

@interface KRGPasscodeField : UITextField
@end

@interface KRGPasscodeBar ()

@end

@implementation KRGPasscodeBar
@synthesize delegate = _passcodeBarDelegate;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = KRGPasscodeBarHeight;
    
    if ((self = [super initWithFrame:frame])) {
        
        self.barStyle = UIBarStyleBlack;
        self.translucent = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        unsigned i, c = 4;
        NSMutableArray *buttonItems = [[NSMutableArray alloc] initWithCapacity:(c + 2)];
        
        [buttonItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL]];
        
        for (i = 0; i < c; i++) {
            UITextField *textField = [[KRGPasscodeField alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.spellCheckingType = UITextSpellCheckingTypeNo;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.enablesReturnKeyAutomatically = NO;
            textField.keyboardAppearance = UIKeyboardAppearanceAlert;
            textField.secureTextEntry = YES;
            textField.textAlignment = UITextAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:textField];
            [buttonItems addObject:item];
        }
        
        [buttonItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL]];
        
        self.items = buttonItems;
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (BOOL)becomeFirstResponder
{
    UIBarButtonItem *item = [self.items objectAtIndex:1];
    return [(UITextField *)item.customView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    NSArray *items = self.items;
    NSUInteger count = [items count];
    NSUInteger idx;
    
    for (idx = 0; idx < count; idx++) {
        
        UIView *custom = (UIView *)((UIBarButtonItem *)[items objectAtIndex:idx]).customView;
        
        if ([custom isKindOfClass:[UITextField class]]) {
            [(UITextField *)custom resignFirstResponder];
        }
    }
    
    [super resignFirstResponder];
    
    return YES;
}

- (IBAction)textChanged:(id)sender
{
    //if no text, go back
    //if text, go forward
    //if no text and is first, stay
    //if text and is last, hit delegate
    
    NSString *text = ((UITextField *)sender).text;
    NSComparisonResult direction;
    
    if ([text length] < 1) {
        
        //next text field is before current
        direction = NSOrderedAscending;
        
    } else {
        
        //next text field is after current
        direction = NSOrderedDescending;
    }
    
    //find index of current
    NSArray *items = self.items;
    NSUInteger count = [items count];
    NSUInteger idx;
    
    for (idx = 0; idx < count; idx++) {
        
        UITextField *textField = (UITextField *)((UIBarButtonItem *)[items objectAtIndex:idx]).customView;
        
        if (textField == sender) {
            break;
        }
    }
    
    if (direction == NSOrderedAscending) {
        
        if (idx == 0) {
            
            //do nothing
            id <KRGPasscodeBarDelegate> delegate = self.delegate;
            if ([delegate respondsToSelector:@selector(passcodeBarDidClear:)]) {
                [delegate passcodeBarDidClear:self];
            }
            
        } else {
            
            UITextField *textField = (UITextField *)((UIBarButtonItem *)[items objectAtIndex:(idx - 1)]).customView;
            [textField becomeFirstResponder];
        }
        
    } else {
        
        if (idx == (count - 2)) {
            
            //did type a passcode; hit delegate
            UITextField *textField = (UITextField *)((UIBarButtonItem *)[items objectAtIndex:idx]).customView;
            [textField resignFirstResponder];
            
            [self.delegate passcodeBar:self didEnterPasscode:[self stringValue]];
            
        } else {
            
            UITextField *textField = (UITextField *)((UIBarButtonItem *)[items objectAtIndex:(idx + 1)]).customView;
            [textField becomeFirstResponder];
        }
    }
    
}

- (NSString *)stringValue
{
    NSArray *items = self.items;
    NSUInteger count = [items count];
    NSUInteger idx;
    NSString *result = @"";
    
    for (idx = 0; idx < count; idx++) {
        
        UIView *custom = (UIView *)((UIBarButtonItem *)[items objectAtIndex:idx]).customView;
        
        if ([custom isKindOfClass:[UITextField class]]) {
            result = [result stringByAppendingString:((UITextField *)custom).text];
        }
    }
    
    return result;
}

- (void)reset
{
    NSArray *items = self.items;
    NSUInteger count = [items count];
    NSUInteger idx;
    
    for (idx = 0; idx < count; idx++) {
        
        UIView *custom = (UIView *)((UIBarButtonItem *)[items objectAtIndex:idx]).customView;
        
        if ([custom isKindOfClass:[UITextField class]]) {
            [(UITextField *)custom setText:@""];
        }
    }
}

@end

@implementation KRGPasscodeField

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectZero;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    
}

- (BOOL)isTouchInside
{
    return NO;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
