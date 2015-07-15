//
//  MSGridlineCollectionReusableView.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGridline.h"
#import "UIColor+HexString.h"
@implementation MSGridline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        d7d7d7
//        self.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        self.backgroundColor=[UIColor colorWithRed:0.083 green:0.044 blue:0.154 alpha:0.640];
    }
    return self;
}

@end
