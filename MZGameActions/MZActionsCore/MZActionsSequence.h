#import "MZAction.h"
#import "MZGameDefines.h"

@interface MZActionsSequence : MZAction /*<MZActionsContainer>*/

@property (nonatomic, readonly) NSMutableArray *aciotnsSequence;

+ (instancetype)newWithActions:(NSArray *)actions;
- (void)addAciotn:(MZAction *)action;

@end
