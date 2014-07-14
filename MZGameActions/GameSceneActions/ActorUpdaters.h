#import <Foundation/Foundation.h>

@class MZActionsGroup;
@class GameScene;



@interface ActorUpdaters : NSObject

@property (nonatomic, readwrite, weak) GameScene *gameScene;
@property (nonatomic, readonly) MZActionsGroup *playersUpdater;
@property (nonatomic, readonly) MZActionsGroup *playerBulletsUpdater;
@property (nonatomic, readonly) MZActionsGroup *enemiesUpdater;
@property (nonatomic, readonly) MZActionsGroup *enemyBulletsUpdater;

+ (instancetype)newWithGameScene:(GameScene *)gameScene;
- (void)update;
- (void)clear;

@end
