#import "MZAction.h"

@interface MZActionsGroup : MZAction

@property (nonatomic, readonly) NSMutableArray *updatingAciotns;

// add action and immediate call start
- (id)addImmediate:(MZAction *)newAction;
- (void)removeInactives;
- (void)clear;
@end
