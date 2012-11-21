#import "MHRoom.h"

@interface MHRoom ()

@property (nonatomic, readwrite) int volumeInSquareMeters;
@property (nonatomic, readwrite) MHHazmatFlags hazmatFlags;
@property (nonatomic, readwrite) BOOL requiresStairs;

@end

@implementation MHRoom

- (id)initWithVolumeInSquareMeters:(int)volume {
    return [self initWithVolumeInSquareMeters:volume andStairs:NO];
}

- (id)initWithVolumeInSquareMeters:(int)volume andStairs:(BOOL)stairs {
    return [self initWithVolumeInSquareMeters:volume andStairs:stairs andHazmatFlags:MHHazmatFlagsNone];
}

- (id)initWithVolumeInSquareMeters:(int)volume andStairs:(BOOL)stairs andHazmatFlags:(MHHazmatFlags)hazmatFlags {
    if (self = [super init]) {
        self.boxes = [NSMutableArray array];
        self.volumeInSquareMeters = volume;
        self.hazmatFlags = hazmatFlags;
        self.requiresStairs = stairs;
    }
    return self;
}

- (int)remainingVolumeInSquareMeters {
    int remainingVolume = self.volumeInSquareMeters;
    for (MHBox *box in self.boxes) {
        remainingVolume -= box.volumeInSquareMeters;
    }
    return remainingVolume;
}

- (BOOL)canSafelyHold:(MHBox *)box {
    BOOL roomIsFull = self.remainingVolumeInSquareMeters < box.volumeInSquareMeters;
    BOOL tooLargeForStairs = self.requiresStairs && box.volumeInSquareMeters > 50;
    BOOL unsafe = ~self.hazmatFlags & box.hazmatFlags;
    return !roomIsFull && !tooLargeForStairs && !unsafe;
}

@end
