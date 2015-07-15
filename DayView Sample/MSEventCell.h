//
//  MSEventCell.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSEvent;


@protocol MSEventCellDelegate  <NSObject>

@required
-(void) updateOfEvent:(MSEvent *)eventDetails At:(int) row;
@end

@interface MSEventCell : UICollectionViewCell

@property (nonatomic, weak) MSEvent *event;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSNumber *updateFrames;
@property (nonatomic,strong) NSNumber *selectedCellTag;
@property id<MSEventCellDelegate> eventDelegate;

//@property (nonatomic,strong) NSNumber *tag;
@end
