
//
//  MSEventCell.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSEventCell.h"
#import "MSEvent.h"
#import "UIColor+HexString.h"
#import "View+MASAdditions.h"
#import "UIView+MASShorthandAdditions.h"

@interface MSEventCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *borderView;
@property (strong,nonatomic) UILongPressGestureRecognizer *longPress;
@end

@implementation MSEventCell

#pragma mark - UIView
UIPinchGestureRecognizer *pinch;
UIPanGestureRecognizer *panGesutre;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 4.0);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.0;
        
        self.borderView = [UIView new];
        //        self.borderView.frame= self.frame;
        [self.contentView addSubview:self.borderView];
        
        self.title = [UILabel new];
        //        [self.title setFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        self.title.numberOfLines = 0;
        self.title.backgroundColor = [UIColor clearColor];
        [self.title setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.title];
        
        self.location = [UILabel new];
        //        [self.location setFrame:CGRectMake(0, 30, self.frame.size.width, 120)];
        self.location.numberOfLines = 0;
        self.location.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.location];
        [self.location setTextColor:[UIColor whiteColor]];
        self.imageView =[UIImageView new];
        UIImage *image=[UIImage imageNamed:@"event3.jpg"];
//        [self.imageView setBackgroundColor:[UIColor lightGrayColor]];
        [self.imageView setImage:image];
        [self insertSubview:self.imageView atIndex:0];
        
        CGFloat borderWidth = 2.0;
        CGFloat contentMargin = 2.0;
        UIEdgeInsets contentPadding = UIEdgeInsetsMake(1.0, (borderWidth + 4.0), 1.0, 4.0);
        
        
        [self.borderView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.height);
            make.width.equalTo(@(borderWidth));
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
        }];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(contentPadding.top);
            make.left.equalTo(self.left).offset(contentPadding.left);
            make.right.equalTo(self.right).offset(-contentPadding.right);
        }];
        //
        
        [self.location makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.bottom).offset(contentMargin);
            make.left.equalTo(self.left).offset(contentPadding.left);
            make.right.equalTo(self.right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.bottom).offset(-contentPadding.bottom);
        }];
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];

        _updateFrames =[NSNumber numberWithInt:0];
        
    }
    return self;
}



-(void) handlePan:(UIPanGestureRecognizer *) gesture
{
    UIWindow *mainWindow =[[UIApplication sharedApplication ] keyWindow];
    CGPoint locationPoint = [gesture locationInView:mainWindow];
    CGPoint cellCenter = self.center;
    
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        
        
    }else if (gesture.state  == UIGestureRecognizerStateChanged){
        //        NSLog(@"Pan changed");
        NSLog(@"new location %0.2f oldCenter %0.2f",locationPoint.y,cellCenter.y);
        self.center = CGPointMake(cellCenter.x, locationPoint.y);
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        NSLog(@"Pan ended");
        
    }
}


#pragma mark - UICollectionViewCell

//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected]; // Must be here for animation to fire
//    
//    if (selected && (self.selected != selected)) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.transform = CGAffineTransformMakeScale(1.025, 1.025);
//            self.layer.shadowOpacity = 0.2;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                self.transform = CGAffineTransformIdentity;
//            }];
//        }];
//    } else if (selected) {
//        _updateFrames= [NSNumber numberWithInt:1];
//        self.layer.shadowOpacity = 0.2;
//        //        pinch =[[UIPinchGestureRecognizer alloc]  initWithTarget:self action:@selector(pinch:)];
//        //        [pinch setDelaysTouchesBegan:false];
//        //        [pinch setDelaysTouchesEnded:false];
//        //        [self addGestureRecognizer:pinch];
//        
//        
//    } else {
//        
//        //        [self removeGestureRecognizer:pinch];
//        if (_updateFrames.intValue == 1) {
//            NSDate *endDate = self.event.end;
//            endDate =[NSDate dateWithTimeInterval:1*60*60 sinceDate:endDate];
//            [self.event setEnd:endDate];
//            [self.eventDelegate updateOfEvent:self.event At:self.tag];
//            _updateFrames =[NSNumber numberWithInt:0];
//        }
//        
//        [self removeGestureRecognizer:panGesutre];
//        self.layer.shadowOpacity = 0.0;
//    }
//    [self updateColors];
//}
-(void) pinch:(UIPinchGestureRecognizer*)pinched
{
    NSLog(@"Pinch ratio %0.2f",pinched.scale);
    if(pinched.scale > 0.90f){
        CGRect tempFrame = self.frame;
        tempFrame.size = CGSizeMake(tempFrame.size.width, tempFrame.size.height*pinched.scale);
        self.frame = tempFrame;
    }
    
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (self.selected) {
//        NSLog(@"touches began");
//    }
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (self.selected) {
//        NSLog(@"touches moved");
//    }
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (self.selected) {
//        NSLog(@"touches ended");
//    }
//}
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (self.selected) {
//        NSLog(@"touches cancelled");
//    }
//}



#pragma mark - MSEventCell

- (void)setEvent:(MSEvent *)event
{
    _event = event;
    self.title.text = event.title;
    self.location.text = event.location;
    //    self.title.attributedText = [[NSAttributedString alloc] initWithString:event.title attributes:[self titleAttributesHighlighted:self.selected]];
    //    self.location.attributedText = [[NSAttributedString alloc] initWithString:event.location attributes:[self subtitleAttributesHighlighted:self.selected]];;
    self.tag = event.eventId.integerValue;
    if (event.eventImage != nil) {
    [self.imageView setImage:event.eventImage];    
    }
    
}

- (void)updateColors
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected];
    self.borderView.backgroundColor = [self borderColor];
    self.title.textColor = [self textColorHighlighted:self.selected];
    self.location.textColor = [self textColorHighlighted:self.selected];
}

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
             NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0],
             NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
             NSParagraphStyleAttributeName : paragraphStyle
             };
}

- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:12.0],
             NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
             NSParagraphStyleAttributeName : paragraphStyle
             };
}

- (UIColor *)backgroundColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor colorWithHexString:@"35b1f1"] : [[UIColor colorWithHexString:@"35b1f1"] colorWithAlphaComponent:0.2];
}

- (UIColor *)textColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"21729c"];
}

- (UIColor *)borderColor
{
    return [[self backgroundColorHighlighted:NO] colorWithAlphaComponent:1.0];
}

@end

