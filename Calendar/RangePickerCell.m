//
//  RangePickerCell.m
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"

@implementation RangePickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        //        selectionLayer.backgroundColor = [UIColor orangeColor].CGColor;
        selectionLayer.fillColor = [UIColor orangeColor].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        CAShapeLayer *middleLayer = [[CAShapeLayer alloc] init];
        middleLayer.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor;
        middleLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
        self.middleLayer = middleLayer;
        
        // Hide the default selection layer
        self.shapeLayer.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //    self.titleLabel.frame = self.contentView.bounds;
    self.selectionLayer.frame = self.contentView.bounds;
    self.middleLayer.frame = self.contentView.bounds;
    if (self.selectionType == SelectionTypeMiddle) {
        
        self.middleLayer.path = [UIBezierPath bezierPathWithRect:self.middleLayer.bounds].CGPath;
        
    } else if (self.selectionType == SelectionTypeLeftBorder) {
        CGFloat diameter = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width);
        self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter/2, self.contentView.fs_height/2-diameter/2, diameter, diameter)].CGPath;
        self.middleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.contentView.fs_width/2-diameter/2, self.contentView.fs_height/2-diameter/2, self.contentView.fs_width-(self.contentView.fs_width/2-diameter/2), self.contentView.fs_height-(self.contentView.fs_height/2-diameter/2)) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(diameter, diameter)].CGPath;
        
        
    } else if (self.selectionType == SelectionTypeRightBorder) {
        CGFloat diameter = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width);
        self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter/2, self.contentView.fs_height/2-diameter/2, diameter, diameter)].CGPath;
        self.middleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.contentView.fs_width-(self.contentView.fs_width/2-diameter/2), self.contentView.fs_height-(self.contentView.fs_height/2-diameter/2)) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(diameter, diameter)].CGPath;
        
    } else if (self.selectionType == SelectionTypeSingle) {
        
        CGFloat diameter = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width);
        self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter/2, self.contentView.fs_height/2-diameter/2, diameter, diameter)].CGPath;
        
    }
}

//- (void)layoutSublayersOfLayer:(CALayer *)layer
//{
//    [super layoutSublayersOfLayer:layer];
//
//}
- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}
@end

