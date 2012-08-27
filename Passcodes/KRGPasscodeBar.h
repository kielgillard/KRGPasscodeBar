//
//  KRGPasscodeBar.h
//  Passcodes
//
//  Created by Kiel Gillard on 27/08/12.
//  Copyright (c) 2012 Kiel Gillard. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KRGPasscodeBarHeight        75.0

@class KRGPasscodeBar;

@protocol KRGPasscodeBarDelegate <NSObject>

@required
- (void)passcodeBar:(KRGPasscodeBar *)passcodeBar didEnterPasscode:(NSString *)passcode;

@optional
- (void)passcodeBarDidClear:(KRGPasscodeBar *)passcodeBar;

@end

@interface KRGPasscodeBar : UIToolbar

- (void)reset;

@property (nonatomic, weak) id <KRGPasscodeBarDelegate> delegate;
@end
