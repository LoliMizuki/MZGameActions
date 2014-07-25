#import <SpriteKit/SpriteKit.h>
#import "MZGameDefines.h"

#define LAYER_DEBUG false

@class MZSpritesLayer;
@class MZActionTime;
@class MZActionsGroup;
@class MZActor;
@class PlayerBulletCreateFuncs, EnemyCreateFuncs, EnemyBulletCreateFuncs;
@class ActorCreateFuncs;
@class ActorUpdaters;
@class GUILayer;



@interface GameScene : SKScene <MZTouchNotifier>
@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGRect gameBound;

@property (nonatomic, readonly) MZActionTime *playerActionTime;

@property (nonatomic, readonly) ActorCreateFuncs *actorCreateFuncs;
@property (nonatomic, readonly) ActorUpdaters *actorUpdaters;
@property (nonatomic, readonly) MZActionsGroup *eventsExecutor;
@property (nonatomic, readonly) MZActor *player;

@property (nonatomic, readonly) GUILayer *guiLayer;
@property (nonatomic, readonly) SKNode *debugLayer;

- (void)addSpritesLayer:(MZSpritesLayer *)layer name:(NSString *)name;
- (MZSpritesLayer *)spritesLayerWithName:(NSString *)name;
@end
