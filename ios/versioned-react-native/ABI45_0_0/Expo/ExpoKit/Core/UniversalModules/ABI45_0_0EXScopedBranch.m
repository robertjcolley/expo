// Copyright 2019-present 650 Industries. All rights reserved.
#if __has_include(<ABI45_0_0EXBranch/ABI45_0_0RNBranch.h>)
#import "ABI45_0_0EXScopedBranch.h"

@interface ABI45_0_0EXScopedBranch ()

@property (nonatomic, weak) ABI45_0_0EXModuleRegistry *exModuleRegistry;

@end

@protocol ABI45_0_0EXDummyBranchProtocol
@end

@implementation ABI45_0_0EXScopedBranch

@synthesize bridge = _bridge;

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI45_0_0EXDummyBranchProtocol)];
}

- (instancetype)initWithScopeKey:(NSString *)scopeKey
{
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ABI45_0_0RNBranchLinkOpenedNotification object:nil];
    _scopeKey = scopeKey;
  }
  return self;
}

- (void)setModuleRegistry:(ABI45_0_0EXModuleRegistry *)exModuleRegistry
{
  _exModuleRegistry = exModuleRegistry;
  [(id<ABI45_0_0EXBranchScopedModuleDelegate>)[_exModuleRegistry getSingletonModuleForName:@"BranchManager"] branchModuleDidInit:self];
}

- (void)setBridge:(ABI45_0_0RCTBridge *)bridge
{
  _bridge = bridge;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInitSessionFinished:) name:ABI45_0_0RNBranchLinkOpenedNotification object:nil];
#pragma clang diagnostic pop
}

@end
#endif
