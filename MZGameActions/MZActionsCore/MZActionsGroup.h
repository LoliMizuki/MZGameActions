#import "MZAction.h"

@interface MZActionsGroup : MZAction <MZActionsContainer>

@property (nonatomic, readonly) NSArray *updatingAciotns;

- (id)addAction:(MZAction *)newAction;
- (id)addActionLate:(MZAction *)newAction;
- (void)removeInactiveActions;
- (void)removeAllActions;
@end
