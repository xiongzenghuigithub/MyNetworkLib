

#import "XZHReachabilityManager.h"

#pragma mark - 字符串地址转换成网络地址依赖库
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#pragma mark - XZHReachabilityManager(匿名分类)
@interface XZHReachabilityManager ()

#pragma mark - 各种操作队列
@property (nonatomic, strong) dispatch_queue_t  serialQueue;        //串行队列
@property (nonatomic, strong) dispatch_queue_t  conCurrentQueue;    //并发队列

@end

@implementation XZHReachabilityManager

//TODO: initWithXxx函数
- (instancetype) initWithReachabilityRef:(SCNetworkReachabilityRef)ref {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //初始化
    _serialQueue = dispatch_queue_create("Reachability.Serial.Queue", NULL);
    _conCurrentQueue = dispatch_queue_create("Reachability.ConCurrent.Queue", DISPATCH_QUEUE_CONCURRENT);
    
    _reachabilityRef = ref;
    _currentState = UnKnown;
    
    return  nil;
}

#pragma mark - 释放内存
- (void)dealloc {
    
    //TODO: SCNetworkReachabilityRef必须要关闭 , 先停止监听
    [self stopMonitoring];
    if (_reachabilityRef) {
        CFRelease(_reachabilityRef);
    }
    _reachabilityRef = nil;
    
    self.serialQueue = nil;
    self.conCurrentQueue = nil;
    self.reachabilityStateChangedHandler = nil;
}

+ (instancetype)sharedManager {
    
    //TODO: 标准单例法
    static XZHReachabilityManager * manager = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //1. 构造一个零地址
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
        
        //2. 创建一个测试地址的manager
        manager = [self managerForAddress:&address];
    });
    return manager;
}

- (void) setReachabilityChangedHandler:(void (^)(ReachabilityState changedState))handler {
    self.reachabilityStateChangedHandler = [handler copy];
}

+ (instancetype) managerForAddress:(const void *) address {
    
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    
    XZHReachabilityManager * manager = [[XZHReachabilityManager alloc] initWithReachabilityRef:ref];
    manager.currentAssociateType = ReachabilityAssociateWithIPAddress;
    
    return manager;
}

+ (instancetype)managerForDomain:(NSString *)domain {
    
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    
    XZHReachabilityManager * manager = [[XZHReachabilityManager alloc] initWithReachabilityRef:ref];
    manager.currentAssociateType = ReachabilityAssociateWithDomain;
    
    return manager;
}

@end
