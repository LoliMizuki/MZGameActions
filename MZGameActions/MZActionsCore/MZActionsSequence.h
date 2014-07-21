#import "MZAction.h"
#import "MZGameDefines.h"

@interface MZActionsSequence : MZAction <MZActionsContainer>

@property (nonatomic, readonly) NSMutableArray *aciotnsSequence;

+ (instancetype)newWithActions:(NSArray *)actions;
- (id)addAction:(MZAction *)action;
- (id)removeAction:(MZAction *)action;
- (void)removeInactiveActions;
- (void)removeAllActions;
- (void)update;

@end
