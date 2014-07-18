#import "MZAction.h"
#import "MZGameDefines.h"

@interface MZActor : MZAction <MZTransform, MZActionsContainer>

@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, readwrite) CGPoint scaleXY;
@property (nonatomic, readwrite) MZFloat scale;
@property (nonatomic, readwrite) MZFloat rotation;

- (void)addActiveCondition:(bool (^)(void))activeCondition;

- (id)addAction:(MZAction *)action name:(NSString *)name;
- (id)addAction:(MZAction *)action;
- (id)addActionWithClass:(Class)actionClass name:(NSString *)name;

- (id)actionWithName:(NSString *)name;
- (NSArray *)actionsWithClass:(Class)actionClass;

- (id)removeAction:(MZAction *)action;
- (id)removeActionWithName:(NSString *)name;
- (NSArray *)removeAllActionsWithClass:(Class)actionClass;

- (void)refresh;

- (void)removeInactiveActions;
- (void)removeAllActions;

@end

// TODO:
// action 用備份 dict cache 一下
