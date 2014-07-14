#import <SpriteKit/SpriteKit.h>
#import "MZGameDefines.h"

@class MZSpritesLayer;
@class MZActionTime;
@class MZActionsGroup;
@class PlayerBulletCreateFuncs, EnemyCreateFuncs, EnemyBulletCreateFuncs;
@class ActorCreateFuncs;
@class ActorUpdaters;



@interface GameScene : SKScene <MZTouchNotifier>

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGRect gameBound;

@property (nonatomic, readonly) MZActionTime *playerActionTime;
@property (nonatomic, readonly) ActorCreateFuncs *actorCreateFuncs;
@property (nonatomic, readonly) ActorUpdaters *actorUpdaters;
@property (nonatomic, readonly) SKNode *debugLayer;


- (void)addSpritesLayer:(MZSpritesLayer *)layer name:(NSString *)name;
- (MZSpritesLayer *)spritesLayerWithName:(NSString *)name;
@end
