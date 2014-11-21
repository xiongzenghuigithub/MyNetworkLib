/**
 *   检测与指定主机服务器地址是否可达
 */

#import <Foundation/Foundation.h>
#include <SystemConfiguration/SystemConfiguration.h>

#pragma mark - 测试与主机连接的形式
typedef NS_ENUM(NSUInteger, ReachabilityAssociateType) {
    ReachabilityAssociateWithDomain    = 0x01,  //主机服务器域名
    ReachabilityAssociateWithIPAddress = 0x02,  //ip地址
};

#pragma mark - 与主机连接的状态
typedef NS_ENUM(NSUInteger, ReachabilityState) {
    UnKnown          =  0x01,                   //未知状态
    NotReachable     =  0x02,                   //不可达
    ReachableViaWiFi =  0x03,                   //可达，通过WiFi
    ReachableViaWWAN =  0x04,                   //可达，通过3G
};

#pragma mark - 回传改变的主机连接状态
typedef void (^ReachabilityChangedHandler)(ReachabilityState changedState);

#pragma mark -
@interface XZHReachabilityManager : NSObject

#pragma mark - 属性
@property (nonatomic, assign) SCNetworkReachabilityRef      reachabilityRef;

@property (nonatomic, assign) ReachabilityState             currentState;
@property (nonatomic, assign) ReachabilityAssociateType     currentAssociateType;

@property (nonatomic, copy)   ReachabilityChangedHandler    reachabilityStateChangedHandler;

@property (nonatomic, assign, readonly , getter = isReachable)        BOOL reachable;
@property (nonatomic, assign, readonly , getter = isReachableViaWiFi) BOOL reachableViaWiFi;
@property (nonatomic, assign, readonly , getter = isReachableViaWWAN) BOOL reachableViaWWAN;

#pragma mark - 方法

#pragma mark - 返回单例对象
+ (instancetype) sharedManager;

#pragma mark - init SCNetworkReachabilityRef
- (instancetype) initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

#pragma mark - 设置回调代码
- (void) setReachabilityChangedHandler:(void (^)(ReachabilityState changedState))handler;

#pragma mark - 根据 - ip address - 创建manager对象
+ (instancetype) managerForAddress:(const void *) address;

#pragma mark - 根据 - domain - 创建manager对象
+ (instancetype) managerForDomain:(NSString *) domain;

#pragma mark - 开启监听和关闭监听
- (void) startMonitoring;
- (void) stopMonitoring;

@end
