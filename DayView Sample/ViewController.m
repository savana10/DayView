//
//  ViewController.m
//  DayView Sample
//
//  Created by Savana on 15/07/15.
//  Copyright (c) 2015 WTS. All rights reserved.
//

#import "ViewController.h"
#import "MSEvent.h"
#import "MSEventCell.h"
#import "MSCollectionViewCalendarLayout.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeGridline.h"
#import "MSCurrentTimeIndicator.h"
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"

NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MSCollectionViewDelegateCalendarLayout,MSEventCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;

@end

@implementation ViewController
NSMutableArray *events;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    events=[NSMutableArray new];
    for (int i=0;i<2;i++) {
        NSDate *eventStartDate =[NSDate dateWithTimeInterval:i*24*60*60 sinceDate:[NSDate date]];
        NSMutableArray *dayEvents =[NSMutableArray new];
        for (int j=0;j<3;j++) {
            MSEvent *event =[MSEvent new];
            event.title = [NSString stringWithFormat:@"This is test event no %i",i];
            event.location =@"Santa Cruz Mumbai";
            int r = arc4random_uniform(10);
            if (j%3 == 0) {
                event.start=[NSDate dateWithTimeInterval:(i+r)*60*60 sinceDate:eventStartDate];
                event.end =[NSDate dateWithTimeInterval:(3+j+r)*60*60 sinceDate:eventStartDate];
            }else if (j%3 == 1){
                event.start=[NSDate dateWithTimeInterval:(j+i-r)*0.5*60*60 sinceDate:eventStartDate];
                event.end =[NSDate dateWithTimeInterval:(3+j+i-r)*0.5*60*60 sinceDate:eventStartDate];
            }else{
                event.start=[NSDate dateWithTimeInterval:4.5*60*60 sinceDate:eventStartDate];
                event.end =[NSDate dateWithTimeInterval:5.5*60*60 sinceDate:eventStartDate];
            }
            
            event.eventId= [NSNumber numberWithInt:i];
            
            [dayEvents addObject:event];
        }
        
        [events addObject:dayEvents];
    }
    
    [self.eventsCollectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.eventsCollectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.eventsCollectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    self.collectionViewCalendarLayout.sectionWidth = self.view.frame.size.width-60.0f;
    [self.eventsCollectionView setCollectionViewLayout:self.collectionViewCalendarLayout];
    
    [self.eventsCollectionView setDelegate:self];
    [self.eventsCollectionView setDataSource:self];
    self.eventsCollectionView.allowsMultipleSelection= true;
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return 1;
    return events.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *eventsInDay =[events objectAtIndex:section];
    return eventsInDay.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    NSArray *daysEvent =[events objectAtIndex:indexPath.section];
    [cell setEvent:[daysEvent objectAtIndex:indexPath.section]];
    [cell setEventDelegate:self];
    return cell;
    
}
- (void)updateOfEvent:(MSEvent *)eventDetails At:(int)row
{
    
    [events replaceObjectAtIndex:row withObject:eventDetails];
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.eventsCollectionView reloadData];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view=[[UICollectionReusableView alloc] initWithFrame:CGRectZero];
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.eventsCollectionView layout:self.collectionViewCalendarLayout];
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay =currentDay;
//        [[day beginningOfDay] isEqualToDate:[currentDay beginningOfDay]];
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
    NSArray *daysEvent =[events objectAtIndex:section];
//    [cell setEvent:[daysEvent objectAtIndex:indexPath.section]];
    MSEvent *e =[daysEvent firstObject];
    return e.start;
}
- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *daysEvent =[events objectAtIndex:indexPath.section];
    MSEvent *e =[daysEvent objectAtIndex:indexPath.row];
//    NSLog(@"start date %@",e.start );
    return e.start;
}
- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MSEvent *e =[events objectAtIndex:indexPath.section];
//    NSLog(@"start date %@",e.end);
    NSArray *daysEvent =[events objectAtIndex:indexPath.section];
    MSEvent *e =[daysEvent objectAtIndex:indexPath.row];
    return e.end;
}
- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout
{
    return [NSDate date];
}


@end
