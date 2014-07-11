#import "MZSpritesLayer.h"
#import "MZGameHeader.h"

@interface MZSpritesLayer (_)
- (void)_setNodesPoolWithAtlas:(SKTextureAtlas *)atlas number:(NSUInteger)number;
@end



@implementation MZSpritesLayer {
    NSMutableDictionary *_animationDict;
}

+ (instancetype)newWithAtlas:(SKTextureAtlas *)atlas nodesNumber:(NSUInteger)nodesNumber {
    MZSpritesLayer *layer = [MZSpritesLayer new];

    [layer _setNodesPoolWithAtlas:atlas number:nodesNumber];

    return layer;
}

+ (instancetype)newWithAtlasName:(NSString *)name nodesNumber:(NSUInteger)nodesNumber {
    return [MZSpritesLayer newWithAtlas:[SKTextureAtlas atlasNamed:name] nodesNumber:nodesNumber];
}

@synthesize textureAtlas, nodesPool, animationNames;

- (instancetype)init {
    self = [super init];
    _animationDict = [NSMutableDictionary new];
    return self;
}

- (void)dealloc {
    for (SKNode *s in nodesPool.elements) {
        [s removeFromParent];
    }

    [nodesPool clearPool];
    textureAtlas = nil;
}

- (NSArray *)animationNames {
    return _animationDict.allKeys;
}

- (SKTexture *)textureWithName:(NSString *)name {
    return [textureAtlas textureNamed:name];
}

- (SKAction *)animationWithName:(NSString *)name {
    return _animationDict[name];
}

- (void)addAnimationWithTextureNames:(NSArray *)names name:(NSString *)name oneLoopTime:(MZFloat)oneLoopTime {
    NSMutableArray *textures = [NSMutableArray new];
    for (NSString *tname in names) {
        [textures addObject:[textureAtlas textureNamed:tname]];
    }

    _animationDict[name] =
        [SKAction animateWithTextures:textures timePerFrame:oneLoopTime / textures.count resize:true restore:false];
}

- (SKSpriteNode *)spriteWithTextureName:(NSString *)name {
    SKTexture *texture = [textureAtlas textureNamed:name];
    MZAssertIfNilWithMessage(texture, @"can not find texture with name(%@)", name);

    SKSpriteNode *sprite = [nodesPool getElement];
    if (sprite == nil) return nil;

    sprite.size = texture.size;
    sprite.hidden = false;
    sprite.texture = texture;

    return sprite;
}

- (SKSpriteNode *)spriteWithAnimationName:(NSString *)name {
    SKSpriteNode *sprite = [nodesPool getElement];
    if (sprite == nil) return nil;

    [sprite runAction:[self animationWithName:name]];

    return sprite;
}

- (SKSpriteNode *)spriteWithRepeatTimesAnimationName:(NSString *)name times:(NSUInteger)times {
    SKSpriteNode *sprite = [nodesPool getElement];
    if (sprite == nil) return nil;

    SKAction *forever = [SKAction repeatAction:[self animationWithName:name] count:times];
    [sprite runAction:forever];

    return sprite;
}

- (SKSpriteNode *)spriteWithForeverAnimationName:(NSString *)name {
    SKSpriteNode *sprite = [nodesPool getElement];
    if (sprite == nil) return nil;

    SKAction *anim = [self animationWithName:name];
    MZAssertIfNilWithMessage(anim, @"can not found animation(%@)", name);

    SKAction *forever = [SKAction repeatActionForever:anim];
    [sprite runAction:forever];

    return sprite;
}

@end

@implementation MZSpritesLayer (_)

- (void)_setNodesPoolWithAtlas:(SKTextureAtlas *)atlas number:(NSUInteger)number {
    MZAssertIfNilWithMessage(atlas, @"atlas is nil");

    textureAtlas = atlas;

    SKTexture *firstTexture = ^{
        NSString *firstTexName = [atlas.textureNames firstObject];
        MZAssertIfNil(firstTexName);

        return [atlas textureNamed:firstTexName];
    }();

    SKSpriteNode * (^genFunc)(void) = ^{
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:firstTexture];
        [self addChild:sprite];

        sprite.hidden = true;

        return sprite;
    };

    MZPoolElementAction getAction = ^(SKSpriteNode *s) {
        s.hidden = false;
        [s setScale:1];
        s.color = [UIColor whiteColor];
    };

    MZPoolElementAction returnAction = ^(SKSpriteNode *s) {
        s.hidden = true;
    };

    nodesPool = [MZPool newWithNumber:number elementGenFunc:genFunc onGetAction:getAction onReturnAction:returnAction];
}

@end
