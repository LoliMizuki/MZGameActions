#import <SpriteKit/SpriteKit.h>
#import "MZGameDefines.h"

@class MZPool;

@interface MZSpritesLayer : SKNode

@property (nonatomic, readonly) SKTextureAtlas *textureAtlas;
@property (nonatomic, readonly) MZPool *nodesPool;
@property (nonatomic, readonly) NSArray *animationNames;

+ (instancetype)newWithAtlas:(SKTextureAtlas *)atlas nodesNumber:(NSUInteger)nodesNumber;
+ (instancetype)newWithAtlasName:(NSString *)name nodesNumber:(NSUInteger)nodesNumber;

- (void)addAnimationWithTextureNames:(NSArray *)names name:(NSString *)name oneLoopTime:(MZFloat)oneLoopTime;

- (SKTexture *)textureWithName:(NSString *)name;
- (SKAction *)animationWithName:(NSString *)name;

- (SKSpriteNode *)spriteWithTextureName:(NSString *)name;
- (SKSpriteNode *)spriteWithAnimationName:(NSString *)name;
- (SKSpriteNode *)spriteWithRepeatTimesAnimationName:(NSString *)name times:(NSUInteger)times;
- (SKSpriteNode *)spriteWithForeverAnimationName:(NSString *)name;

@end
