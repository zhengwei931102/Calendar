//
//  RangePickerCell.h
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "FSCalendar/FSCalendar.h"
typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};
@interface RangePickerCell : FSCalendarCell

// The start/end of the range
@property (weak, nonatomic) CAShapeLayer *selectionLayer;

// The middle of the range
@property (weak, nonatomic) CAShapeLayer *middleLayer;

@property (assign, nonatomic) SelectionType selectionType;

@end
