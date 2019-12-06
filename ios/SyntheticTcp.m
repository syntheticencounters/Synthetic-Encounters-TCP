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
RCTResponseSenderBlock readCallback = NULL;
RCTResponseSenderBlock writeCallback = NULL;
RCTResponseSenderBlock connectCallback = NULL;

RCT_REMAP_METHOD(connect,
                 host:(NSString *)host
                 port:(nonnull NSNumber *)port
                 callback:(RCTResponseSenderBlock)callback)
{
    
    if(host == NULL || port == NULL) {
        callback(@[@"Missing required host and/or port", [NSNull null]]);
        return;
    }
   
    connectCallback = callback;
    mainQueue = dispatch_get_main_queue();
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    NSError *error = nil;
    if(![asyncSocket connectToHost:host onPort:port.shortValue viaInterface:NULL withTimeout:5 error:&error]) {
        callback(@[@"Connection was refused by the Comm Link", [NSNull null]]);
        return;
    }
}

RCT_REMAP_METHOD(read,
                 timeout:(nonnull NSNumber *)timeout
                 callback:(RCTResponseSenderBlock)callback)
{
    if(![asyncSocket isConnected]) {
        callback(@[@"The connection between your device and the Comm Link has been lost", [NSNull null]]);
        return;
    }
    
    readCallback = callback;
    [asyncSocket readDataWithTimeout:timeout.shortValue tag:1];
}

RCT_REMAP_METHOD(write,
                 string:(NSString *)string
                 callback:(RCTResponseSenderBlock)callback)
{
    if(![asyncSocket isConnected]) {
        callback(@[@"The connection between your device and the Comm Link has been lost", [NSNull null]]);
        return;
    }
    
    if(string == NULL) {
        callback(@[@"Missing required string for data", [NSNull null]]);
        return;
    }
    
    writeCallback = callback;
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:5 tag:2];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"sockettcp connect :%@", host);
    if(connectCallback != NULL) {

        connectCallback(@[[NSNull null], [NSString stringWithFormat:@"Connected to host %@", host]]);
        connectCallback = NULL;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if(writeCallback != NULL) {

        writeCallback(@[[NSNull null], [NSNull null]]);
        writeCallback = NULL;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [NSString stringWithFormat:@"sockettcp response: %@", httpResponse]);
    if(readCallback != NULL) {

        readCallback(@[[NSNull null], httpResponse]);
        readCallback = NULL;
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"sockettcp error");
    NSLog(@"%@", err.localizedDescription);
    if(connectCallback) {
        
        if(err.code == 3) {
            connectCallback(@[@"We were unable to establish a connection within an appropriate amount of time", [NSNull null]]);
            connectCallback = NULL;
        }
    }
    
    if(readCallback != NULL) {

        readCallback(@[@"Unable to read the response from the Comm Link", [NSNull null]]);
        readCallback = NULL;
    }
    
}

@end
