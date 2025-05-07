//
//  SFCBPeripheral.h
//  SifliOCore
//
//  Created by Sean on 2023/10/30.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFCBPeripheral : NSObject
@property (nonatomic,strong) CBPeripheral *peripheral;

/// 信号量
@property (nonatomic,strong) NSNumber *RSSI;
@property (nonatomic,copy,readonly) NSString *name;
@property (nonatomic,copy,readonly) NSString *identifier;
@property (nonatomic,copy) NSString *centralIdentifier;
@end

NS_ASSUME_NONNULL_END
