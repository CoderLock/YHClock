//
//  YHDate.h
//  ClockView
//
//  Created by yuanheng on 2018/7/25.
//  Copyright © 2018年 ryan. All rights reserved.
//

#import "ClockView.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"

static const CGFloat kMargin = 8.0;

@interface ClockView ()

/** 中心灰点 */
@property (nonatomic, strong) CALayer *centerGrayDotLayer;
/** 中心红点 */
@property (nonatomic, strong) CALayer *centerRedDotLayer;
/** 时针 */
@property (nonatomic, strong) CALayer *hourLayer;
/** 分针 */
@property (nonatomic, strong) CALayer *minuteLayer;
/** 时针旋转后的角度 */
@property (nonatomic, assign) double hoursAngles;
/** 分针旋转后的角度 */
@property (nonatomic, assign) double minutesAngles;
/** 时针的初始角度 */
@property (nonatomic, assign) double originHoursAngles;
/** 分针的初始角度 */
@property (nonatomic, assign) double originMinutesAngles;

@property (nonatomic, assign, readwrite) NSInteger hours;
@property (nonatomic, assign, readwrite) NSInteger minutes;

@end

@implementation ClockView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.date = [NSDate date];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self customUI];
}

- (void)customUI {
    self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"icon_clock"].CGImage);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.centerGrayDotLayer.position = center;
    self.centerGrayDotLayer.bounds = CGRectMake(0, 0, 9, 9);
    self.centerGrayDotLayer.cornerRadius = 9/2.0;
    
    self.centerRedDotLayer.position = center;
    self.centerRedDotLayer.bounds = CGRectMake(0, 0, 4, 4);
    self.centerRedDotLayer.cornerRadius = 4/2.0;
    
    self.hourLayer.position = center;
    self.hourLayer.bounds = CGRectMake(0, 0, 3.8, CGRectGetHeight(self.bounds)/2 - 3.3*kMargin);
    self.hourLayer.anchorPoint = CGPointMake(0.5, 1);
    self.hourLayer.cornerRadius = 4/2;
    
    self.minuteLayer.position = center;
    self.minuteLayer.bounds = CGRectMake(0, 0, 3.8, CGRectGetHeight(self.bounds)/2 - 2.5*kMargin);
    self.minuteLayer.anchorPoint = CGPointMake(0.5, 1);
    self.minuteLayer.cornerRadius = 4/2;
    
    [self.layer addSublayer:self.centerGrayDotLayer];
    [self.layer addSublayer:self.hourLayer];
    [self.layer addSublayer:self.minuteLayer];
    [self.layer addSublayer:self.centerRedDotLayer];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint currentTouchPoint = [touch locationInView:self];
    CGPoint previousTouchPoint = [touch previousLocationInView:self];
    
    double angle = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
    
    /** 修正反三角函数的数值, 避免时针来回跳动 */
    if (angle > M_PI) {
        angle -= 2*M_PI;
    }
    if (angle < -M_PI) {
        angle += 2*M_PI;
    }
    
    _minutesAngles += angle;
    _hoursAngles   += angle/12;
    
    [self rotateClock];
    [self computeHoursAndMinutes];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *dateText = [NSString stringWithFormat:@"2017-01-01 %ld:%ld", _hours, _minutes];
    self.date = [NSDate dateFromString:dateText dateFormat:@"yyyy-MM-dd HH:mm"];
}

/** 旋转指针 */
- (void)rotateClock {
    [self rotateHourLayerWithAngle:_hoursAngles];
    [self rotateMinuteLayerWithAngle:_minutesAngles];
}

/** 设置分针的旋转角度 */
- (void)rotateMinuteLayerWithAngle:(double)angle {
    NSInteger number = angle/((M_PI*2)/60);
    self.minuteLayer.affineTransform = CGAffineTransformMakeRotation((double)number * ((M_PI*2)/60));
}

/** 设置时针的旋转角度 */
- (void)rotateHourLayerWithAngle:(double)angle {
    self.hourLayer.affineTransform = CGAffineTransformMakeRotation(angle);
}

/** 获取分针的旋转角度 */
- (double)fetchMinuteAngleWithMinutes:(NSInteger)minutes {
    double angle = (double)minutes*((M_PI*2)/60);
    return angle;
}

/** 获取时针的旋转角度 */
- (double)fetchHoursAngleWithHours:(NSInteger)hours minute:(NSInteger)minute {
    double angle = (double)hours*((M_PI*2)/12) + (double)minute*(((M_PI*2)/12)/60) + 10000*(M_PI*2);
    return angle;
}

/** 计算小时和分钟 */
- (void)computeHoursAndMinutes
{
    _minutes = _minutesAngles/((M_PI*2)/60);

    /** 当旋转后的时间小于初始时间时, 需要加上 ((M_PI*2)/12)/60), 用于修正角度，避免计算的小时不准确 */
    if (_hoursAngles < _originHoursAngles) {
        _hours = (_hoursAngles + ((M_PI*2)/12)/60)/((M_PI*2)/12);
    } else {
        _hours = _hoursAngles/((M_PI*2)/12);
    }
    
    _hours = _hours%24;
    _minutes = _minutes%60;
    
    if (_minutes < 0) {
        _minutes += 60;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(clock:hours:minutes:)]) {
        [_delegate clock:self hours:_hours minutes:_minutes];
    }
}

/** 根据日期获取小时 */
- (NSInteger)fetchHoursWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    return components.hour;
}

/** 根据日期获取分钟 */
- (NSInteger)fetchMinutesWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    return components.minute;
}

#pragma mark - Setter

- (void)setDate:(NSDate *)date {
    _date = date;
    
    _hours    = [self fetchHoursWithDate:_date];
    _minutes  = [self fetchMinutesWithDate:_date];
    
    _originHoursAngles   = [self fetchHoursAngleWithHours:_hours minute:_minutes];
    _originMinutesAngles = [self fetchMinuteAngleWithMinutes:_minutes];
    
    _hoursAngles = _originHoursAngles;
    _minutesAngles = _originMinutesAngles;
    
    [self rotateClock];
}

#pragma mark - Getter

- (CALayer *)hourLayer {
    if (!_hourLayer) {
        _hourLayer = [CALayer layer];
        _hourLayer.backgroundColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        _hourLayer.allowsEdgeAntialiasing = YES;
        _hourLayer.speed = 100;
    }
    return _hourLayer;
}

- (CALayer *)minuteLayer {
    if (!_minuteLayer) {
        _minuteLayer = [CALayer layer];
        _minuteLayer.backgroundColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        _minuteLayer.allowsEdgeAntialiasing = YES;
        _minuteLayer.speed = 100;
    }
    return _minuteLayer;
}

- (CALayer *)centerGrayDotLayer {
    if (!_centerGrayDotLayer) {
        _centerGrayDotLayer = [CALayer layer];
        _centerGrayDotLayer.backgroundColor = [UIColor colorWithHexString:@"#707070"].CGColor;
        _centerGrayDotLayer.allowsEdgeAntialiasing = YES;
    }
    return _centerGrayDotLayer;
}

- (CALayer *)centerRedDotLayer {
    if (!_centerRedDotLayer) {
        _centerRedDotLayer = [CALayer layer];
        _centerRedDotLayer.backgroundColor = [UIColor colorWithHexString:@"#EB6E5D"].CGColor;
        _centerRedDotLayer.allowsEdgeAntialiasing = YES;
    }
    return _centerRedDotLayer;
}

@end
