#import "SyntheticTcp.h"
#import "GCDAsyncSocket.h"

@implementation SyntheticTcp

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

dispatch_queue_t mainQueue = NULL;
long *tag = NULL;

RCTPromiseRejectBlock readReject = NULL;
RCTPromiseResolveBlock readResolve = NULL;

RCTPromiseRejectBlock writeReject = NULL;
RCTPromiseResolveBlock writeResolve = NULL;

RCTPromiseRejectBlock connectReject = NULL;
RCTPromiseResolveBlock connectResolve = NULL;


RCT_REMAP_METHOD(connect,
                 host:(NSString *)host
                 port:(nonnull NSNumber *)port
                 timeout:(nonnull NSNumber *)timeout
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)
{
    
    if(host == NULL || port == NULL) {
        NSError *error = [ NSError errorWithDomain:@"com.commlink.OmniShieldApp2" code:500 userInfo: NULL ];
        reject(@"error", @"Missing required props for connection", error);
        return;
    }
   
    connectResolve = resolve;
    mainQueue = dispatch_get_main_queue();
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    NSError *error = nil;
    if(![asyncSocket connectToHost:host onPort:port.shortValue viaInterface:NULL withTimeout:[timeout doubleValue] error:&error]) {
        reject(@"error", @"Connection was refused by the Comm Link", error);
        return;
    }
}

RCT_REMAP_METHOD(read,
                 timeout:(nonnull NSNumber *)timeout
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)
{
    readResolve = resolve;
    [asyncSocket readDataWithTimeout:[timeout doubleValue] tag:1];
}

RCT_REMAP_METHOD(write,
                 string:(NSString *)string
                 timeout:(nonnull NSNumber *)timeout
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)
{
     
    if(string == NULL) {
        NSError *error = [ NSError errorWithDomain:@"com.commlink.OmniShieldApp2" code:500 userInfo: NULL ];
        reject(@"error", @"Missing required props for connection", error);
        return;
    }
    
    writeResolve = resolve;
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:[timeout doubleValue] tag:2];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"sockettcp connect :%@", host);
    if(connectResolve != NULL) {
        connectResolve(@"Connected to host %@");
        connectResolve = NULL;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if(writeResolve != NULL) {
        writeResolve(@"Data written");
        writeResolve = NULL;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [NSString stringWithFormat:@"sockettcp response: %@", response]);
    
    if(readResolve != NULL) {
        readResolve(response);
        readResolve = NULL;
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    
    if(readReject != NULL) {
        NSError *error = [ NSError errorWithDomain:@"com.commlink.OmniShieldApp2" code:500 userInfo: NULL ];
        readReject(@"error", @"Unable to communicate with the Comm Link", error);
        readReject = NULL;
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    
    if(writeReject != NULL) {
        NSError *error = [ NSError errorWithDomain:@"com.commlink.OmniShieldApp2" code:500 userInfo: NULL ];
        writeReject(@"error", @"Unable to communicate with the Comm Link", error);
        writeReject = NULL;
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"sockettcp error");
    NSLog(@"%@", err.localizedDescription);
    if(connectReject != NULL) {
        if(err.code == 3) {
            NSError *error = [ NSError errorWithDomain:@"com.commlink.OmniShieldApp2" code:500 userInfo: NULL ];
            connectReject(@"error", @"The connection to the Comm Link has been lost", error);
            connectReject = NULL;
        }
    }
}

@end
