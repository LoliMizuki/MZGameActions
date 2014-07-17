#import "MZAction.h"

@interface MZActionsSequence : MZAction

@property (nonatomic, readonly) NSMutableArray *aciotnsSequence;

+ (instancetype)newWithActions:(NSArray *)actions;
- (void)addAciotn:(MZAction *)action;

@end
