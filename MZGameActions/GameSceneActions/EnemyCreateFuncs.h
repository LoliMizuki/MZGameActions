#import <Foundation/Foundation.h>

@class SKSpriteNode;
@class GameScene;
@class MZActor;



@interface EnemyCreateFuncs : NSObject

@property (nonatomic, readwrite, weak) GameScene *gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene;

- (MZActor * (^)(void))funcWithName:(NSString *)name;
- (MZActor *)newEnemyWithHP:(int)hp bodySprite:(SKSpriteNode *)bodySprite;

@end