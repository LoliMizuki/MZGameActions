#import <SpriteKit/SpriteKit.h>
#import "MZGameDefines.h"

@class MZSpritesLayer;
@class MZActionTime;
@class MZActionsGroup;
@class EnemyCreateFuncs;
@class EnemyBulletCreateFuncs;



@interface GameScene : SKScene <MZTouchNotifier>

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGRect gameBound;

@property (nonatomic, readonly) MZActionTime *playerActionTime;

@property (nonatomic, readonly) EnemyCreateFuncs *enemiesCreateFuncs;
@property (nonatomic, readonly) EnemyBulletCreateFuncs *enemyBulletCreateFuncs;

@property (nonatomic, readonly) MZActionsGroup *playersUpdater;
@property (nonatomic, readonly) MZActionsGroup *enemiesUpdater;
@property (nonatomic, readonly) MZActionsGroup *enemyBulletsUpdater;

@property (nonatomic, readonly) SKNode *debugLayer;


- (void)addSpritesLayer:(MZSpritesLayer *)layer name:(NSString *)name;
- (MZSpritesLayer *)spritesLayerWithName:(NSString *)name;
@end
