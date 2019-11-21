#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif

#import "GCDAsyncSocket.h"

@interface SyntheticTcp : NSObject <RCTBridgeModule> {
    GCDAsyncSocket *asyncSocket;
}

@end
