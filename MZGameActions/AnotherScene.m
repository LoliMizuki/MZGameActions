#import "AnotherScene.h"
#import "GameScene.h"
#import "MZGameHeader.h"

@implementation AnotherScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:@"yuyurect"];
    backButton.position = mzpFromSizeAndFactor(self.size, .5);
    [self addChild:backButton];

    __mz_gen_weak_block(weakSelf, self);
    [backButton addTouchType:kMZTouchType_Began
                 touchAction:^(NSSet *touches, UIEvent *event) {
                     SKView *view = weakSelf.view;
                     [view presentScene:[GameScene sceneWithSize:weakSelf.size]
                             transition:[SKTransition doorsOpenVerticalWithDuration:1]];
                 }];
    return self;
}

- (void)dealloc {
}


@end
