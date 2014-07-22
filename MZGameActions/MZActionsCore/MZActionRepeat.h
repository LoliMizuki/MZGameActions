#import "MZAction.h"

@interface MZActionRepeat : MZAction
+ (instancetype)newWithAction:(MZAction *)action times:(NSUInteger)times;
+ (instancetype)newWithForeverAction:(MZAction *)action;
@end
