#import "MZMove.h"

@interface MZMoveTurnToDirection : MZMove

@property (nonatomic, readwrite) MZFloat turnToDirection;
@property (nonatomic, readwrite) MZFloat turnDegreesPerSecond;
@property (nonatomic, readwrite) MZFloat permissibleDegreesRange;  // 防止抖動, 預設 3 ... 需要更好的方法
@property (nonatomic, readwrite) MZFloat velocity;
@property (nonatomic, readwrite) MZFloat direction;
@property (nonatomic, readwrite) MZFloat acceleration;
@property (nonatomic, readwrite) MZFloat velocityLimited;

+ (MZFloat)degreesOutOfBoundFixWithDegree:(MZFloat)degrees
                           limitedDegrees:(MZFloat)limitedDegrees
                             increaseSign:(int)increaseSign;

@end
