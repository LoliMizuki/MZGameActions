#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "MZGameDefines.h"

@class SKAction;
@class MZPool;

#pragma mark - SKNode (MZPool)

@interface SKNode (MZPoolElement)
@property (nonatomic, readwrite, weak) MZPool *pool;
@property (nonatomic, readwrite) NSUInteger poolElementIndex;

- (void)returnPool;
- (void)removeFomrPool;
@end


#pragma mark - SKNode (MZTouch_Private)

typedef void (^MZTouchAction)(NSSet *touches, UIEvent *event);

@interface SKNode (MZTouch)
- (void)addTouchType:(MZTouchType)type touchAction:(MZTouchAction)touchAction;
@end



#pragma mark - SKAction(Improve_Sequence)

@interface SKAction (Improve_Sequence)
+ (SKAction *)sequencePara:(SKAction *)actions, ...;
@end