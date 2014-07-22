#import "MZMove.h"

@interface MZMoveTurnFromTo : MZMove

@property (nonatomic, readwrite) MZFloat fromDirection;
@property (nonatomic, readwrite) MZFloat toDirection;
@property (nonatomic, readwrite) MZFloat turnDegreesPerSecond;
@property (nonatomic, readwrite) MZFloat permissibleDegreesRange;  // 防止抖動, 預設 3 ... 需要更好的方法
@property (nonatomic, readwrite) MZFloat velocity;
@property (nonatomic, readwrite) MZFloat acceleration;
@property (nonatomic, readwrite) MZFloat velocityLimited;

+ (MZFloat)degreesOutOfBoundFixWithDegree:(MZFloat)degrees
                           limitedDegrees:(MZFloat)limitedDegrees
                             increaseSign:(int)increaseSign;

@end
