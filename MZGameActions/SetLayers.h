#import <Foundation/Foundation.h>

@class MZSpritesLayer;
@class GameScene;

@interface SetLayers : NSObject

+ (MZSpritesLayer *)spritesLayerFromData:(NSDictionary *)layerData;
+ (instancetype)newWithScene:(GameScene *)scene;

- (void)setLayersFromDatas;

@end
