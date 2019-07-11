//
//  ViewController.m
//  Calendar
//
//  Created by zw on 2019/7/1.
//  Copyright © 2019 zw. All rights reserved.
//

#import "ViewController.h"
#import "FSCalendar/FSCalendar.h"
#import "LunarFormatter.h"
#import "RangePickerCell.h"
@interface ViewController ()<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>
@property (retain, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) LunarFormatter *lunarFormatter;

// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.lunarFormatter = [[LunarFormatter alloc] init];
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0,  88, self.view.frame.size.width, 350)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.allowsMultipleSelection = YES;
    calendar.scrollEnabled = NO;
    
    
    //    calendar.calendarHeaderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    //    calendar.calendarWeekdayView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    //    calendar.appearance.eventSelectionColor = [UIColor whiteColor];
    //    calendar.appearance.eventOffset = CGPointMake(0, -7);
    calendar.today = nil; // Hide the today circle
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    calendar.locale = locale;  // 设置周次是中文显示
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.adjustsBoundingRectWhenChangingMonths = YES;
    //    calendar.firstWeekday = 2;//周一在最前面
    calendar.scope = FSCalendarScopeMonth;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    calendar.appearance.titleDefaultColor = [UIColor blackColor];
    
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    //zw默认选今天
    [self.calendar selectDate:[NSDate date] scrollToDate:NO];
    self.date1 = [NSDate date];
    //
    //左右按钮
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 88+5, 95, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-95, 88+5, 95, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
}
- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}
#pragma mark - FSCalendarDataSource
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    return [self.lunarFormatter stringFromDate:date];

}
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}
#pragma mark - FSCalendarDelegate
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSLog(@"did change page %@",[dateFormatter stringFromDate:calendar.currentPage]);
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = date;
        }
    } else {
        if (self.date2) {
            //            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            //            self.date1 = date;
            self.date2 = date;
        } else if (!self.date1) {
            self.date1 = date;
        } else {
            self.date2 = date;
        }
    }
    
    [self configureVisibleCells];
}
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    [self configureVisibleCells];
}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if([[NSDate dateWithTimeIntervalSinceNow:-24*60*60] compare:date]==1){
        return NO;
    }
    return monthPosition == FSCalendarMonthPositionCurrent;
}
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}


#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    //zw
    SelectionType selectionType = SelectionTypeNone;
    //
    if (self.date1 && self.date2) {
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
        rangeCell.middleLayer.hidden = !isMiddle;
        //zw
        if(isMiddle){
            selectionType = SelectionTypeMiddle;
        }
        if([self.gregorian isDate:date inSameDayAsDate:self.date1]){
            rangeCell.middleLayer.hidden = NO;
        }
        //
    }else {
       rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
    
    //zw
    if(!rangeCell.selectionLayer.hidden){
        if(self.date1 &&self.date2){
            if([self.date1 compare:self.date2]==-1){
                if([self.gregorian isDate:date inSameDayAsDate:self.date1]){
                    selectionType = SelectionTypeLeftBorder;
                }else if([self.gregorian isDate:date inSameDayAsDate:self.date2]){
                    selectionType = SelectionTypeRightBorder;
                }
                
            }else if([self.date1 compare:self.date2]==1){
                if([self.gregorian isDate:date inSameDayAsDate:self.date1]){
                    selectionType = SelectionTypeRightBorder;
                }else if([self.gregorian isDate:date inSameDayAsDate:self.date2]){
                    selectionType = SelectionTypeLeftBorder;
                }
                
            }
        }else{
            selectionType = SelectionTypeSingle;
        }
    }
    
    rangeCell.selectionType = selectionType;
    
    //
}
@end


