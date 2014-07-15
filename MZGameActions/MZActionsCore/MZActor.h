#import "MZAction.h"
#import "MZGameDefines.h"

@interface MZActor : MZAction <MZTransform>

@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, readwrite) CGPoint scaleXY;
@property (nonatomic, readwrite) MZFloat scale;
@property (nonatomic, readwrite) MZFloat rotation;

- (id)addAction:(MZAction *)action name:(NSString *)name;
- (id)addActionWithClass:(Class)actionClass name:(NSString *)name;

- (id)actionWithName:(NSString *)name;
- (NSArray *)actionsWithClass:(Class)actionClass;

- (id)removeAction:(MZAction *)action;
- (id)removeActionWithName:(NSString *)name;
- (NSArray *)removeActionsWithClass:(Class)actionClass;



@end

// action 用備份 dict 備份一下
// remove with name
// actionsWithClass
