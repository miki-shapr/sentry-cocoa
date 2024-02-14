#import "SentrySerializable.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SentryId;

@interface SentryReplayRecording : NSObject

@property (nonatomic) NSInteger segmentId;

/**
 * Video file size
 */
@property (nonatomic) NSInteger size;

@property (nonatomic, strong) NSDate *start;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) NSInteger frameCount;

@property (nonatomic) NSInteger frameRate;

@property (nonatomic) NSInteger height;

@property (nonatomic) NSInteger width;

- (instancetype)initWithSegmentId:(NSInteger)segmentId
                             size:(NSInteger)size
                            start:(NSDate *)start
                         duration:(NSTimeInterval)duration
                       frameCount:(NSInteger)frameCount
                        frameRate:(NSInteger)frameRate
                           height:(NSInteger)height
                            width:(NSInteger)width;

- (nonnull NSArray<NSDictionary<NSString *, id> *> *)serialize;

@end

NS_ASSUME_NONNULL_END