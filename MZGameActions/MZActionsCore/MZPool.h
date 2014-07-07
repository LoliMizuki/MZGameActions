// TODO: 加入收尋法 ... 兩種類 ...
// overuse, 偵測並回報 pool 使用達到極限 ...
// issus: make sure block release

#import <Foundation/Foundation.h>

@class MZPool;

typedef void (^MZPoolElementAction)(id element);



#pragma mark - MZPoolElement

@protocol MZPoolElement <NSObject>

@property (nonatomic, readwrite, weak) MZPool* pool;
@property (nonatomic, readwrite) NSUInteger poolElementIndex;

- (void)returnToPool;
@end



#pragma mark - MZPool

@interface MZPool : NSObject

@property (nonatomic, readonly) NSUInteger numberOfElements;
@property (nonatomic, readonly) NSUInteger numberOfAvailable;
@property (nonatomic, readonly) NSArray *elements;

+ (instancetype)newWithNumber:(NSUInteger)number
               elementGenFunc:(id (^)(void))elementGenFunc
                  onGetAction:(MZPoolElementAction)onGetAction
               onReturnAction:(MZPoolElementAction)onReturnAction;
- (instancetype)initWithNumber:(NSUInteger)number
                elementGenFunc:(id (^)(void))elementGenFunc
                   onGetAction:(MZPoolElementAction)onGetAction
                onReturnAction:(MZPoolElementAction)onReturnAction;

- (id)getElement;
- (void)returnElement:(id)element;

- (bool)containsElement:(id)element;

- (void)removeElement:(id)element;
- (void)removeAllElements;
- (void)clearPool;

@end