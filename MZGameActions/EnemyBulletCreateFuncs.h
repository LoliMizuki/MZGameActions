#import <Foundation/Foundation.h>

@class GameScene;
@class MZActor;



@interface EnemyBulletCreateFuncs : NSObject

@property (nonatomic, readwrite, weak) GameScene *gameScene;

+ (instancetype)newWithScene:(GameScene *)gameScene;

- (MZActor * (^)(void))funcWithName:(NSString *)name;


@end
