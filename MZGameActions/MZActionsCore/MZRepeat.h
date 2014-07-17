#import "MZAction.h"

@interface MZRepeat : MZAction
+ (instancetype)newWithAction:(MZAction *)action times:(NSUInteger)times;

@end
