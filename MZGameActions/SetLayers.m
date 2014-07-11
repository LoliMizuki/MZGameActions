#import "SetLayers.h"
#import "GameScene.h"
#import "MZGameHeader.h"

@interface SetLayers (_)
- (NSDictionary *)_layerDatas;
@end



@implementation SetLayers {
    GameScene *_gameScene;
}

+ (MZSpritesLayer *)spritesLayerFromData:(NSDictionary *)layerData {
    MZSpritesLayer *layer =
        [MZSpritesLayer newWithAtlasName:layerData[@"atlas"] nodesNumber:[layerData[@"number"] intValue]];

    if (layerData[@"animations"] != nil) {
        NSDictionary *animationDatas = layerData[@"animations"];
        for (NSString *aniKey in animationDatas.allKeys) {
            NSDictionary *aniData = animationDatas[aniKey];

            [layer addAnimationWithTextureNames:aniData[@"frames"]
                                           name:aniKey
                                    oneLoopTime:[aniData[@"time"] doubleValue]];
        }
    }

    return layer;
}

+ (instancetype)newWithScene:(GameScene *)scene {
    SetLayers *sl = [self new];
    sl->_gameScene = scene;
    [sl setLayersFromDatas];

    return sl;
}

- (void)dealloc {
    _gameScene = nil;
}

- (void)setLayersFromDatas {
    NSDictionary *data = [self _layerDatas];

    NSArray *orderKeys = data[@"order-keys"];
    NSDictionary *layersData = data[@"layers"];

    for (NSString *k in orderKeys) {
        MZSpritesLayer *layer = [SetLayers spritesLayerFromData:layersData[k]];
        [_gameScene addSpritesLayer:layer name:k];
    }
}

@end

@implementation SetLayers (_)

- (NSDictionary *)_layerDatas {
    NSMutableDictionary *playerLayerData = [NSMutableDictionary new];
    playerLayerData[@"type"] = @"sprites";
    playerLayerData[@"atlas"] = @"player";
    playerLayerData[@"number"] = @(10);
    playerLayerData[@"animations"] = @{
        @"fairy-walk-down" : @{
            @"frames" :
            @[ @"fairy-walk-down-001", @"fairy-walk-down-002", @"fairy-walk-down-003", @"fairy-walk-down-002" ],
            @"time" : @(0.5)
        },
        @"fairy-walk-left" : @{
            @"frames" :
            @[ @"fairy-walk-left-001", @"fairy-walk-left-002", @"fairy-walk-left-003", @"fairy-walk-left-002" ],
            @"time" : @(0.5)
        },
        @"fairy-walk-right" : @{
            @"frames" :
            @[ @"fairy-walk-right-001", @"fairy-walk-right-002", @"fairy-walk-right-003", @"fairy-walk-right-002" ],
            @"time" : @(0.5)
        },
        @"fairy-walk-up" : @{
            @"frames" : @[ @"fairy-walk-up-001", @"fairy-walk-up-002", @"fairy-walk-up-003", @"fairy-walk-up-002" ],
            @"time" : @(0.5)
        },
    };

    NSMutableDictionary *enemiesLayerData = [NSMutableDictionary new];
    enemiesLayerData[@"type"] = @"sprites";
    enemiesLayerData[@"atlas"] = @"enemies";
    enemiesLayerData[@"number"] = @(50);
    enemiesLayerData[@"animations"] = @{
        @"Bow" : @{
            @"frames" : @[
                @"Bow_normal0001",
                @"Bow_normal0002",
                @"Bow_normal0003",
                @"Bow_normal0004",
                @"Bow_normal0005",
                @"Bow_normal0006",
                @"Bow_normal0007",
                @"Bow_normal0008",
                @"Bow_normal0009",
                @"Bow_normal0010",
                @"Bow_normal0011",
                @"Bow_normal0012"
            ],
            @"time" : @(0.1)
        },
        @"monster_blue" : @{
            @"frames" : @[ @"monster_blue_0001", @"monster_blue_0002", @"monster_blue_0003", @"monster_blue_0004" ],
            @"time" : @(0.1)
        },
        @"monster_green" :
        @{
           @"frames" : @[ @"monster_green_0001", @"monster_green_0002", @"monster_green_0003", @"monster_green_0004" ],
           @"time" : @(0.1)
        },
        @"monster_red" : @{
            @"frames" : @[ @"monster_red_0001", @"monster_red_0002", @"monster_red_0003", @"monster_red_0004" ],
            @"time" : @(0.1)
        },
        @"ship" : @{
            @"frames" : @[
                @"ship_0001",
                @"ship_0002",
                @"ship_0003",
                @"ship_0004",
                @"ship_0005",
                @"ship_0006",
                @"ship_0007",
                @"ship_0008",
                @"ship_0009",
                @"ship_0010"
            ],
            @"time" : @(0.1)
        },
    };

    NSMutableDictionary *enemyBulletsLayerData = [NSMutableDictionary new];
    enemyBulletsLayerData[@"type"] = @"sprites";
    enemyBulletsLayerData[@"atlas"] = @"enemy_bullets";
    enemyBulletsLayerData[@"number"] = @(500);

    NSMutableDictionary *layerDatas = [NSMutableDictionary new];
    layerDatas[@"order-keys"] = @[ @"player", @"enemies", @"enemy-bullets" ];

    layerDatas[@"layers"] =
        @{@"player" : playerLayerData, @"enemies" : enemiesLayerData, @"enemy-bullets" : enemyBulletsLayerData, };
    return layerDatas;
}

@end