/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI27_0_0RCTTabBarManager.h"

#import "ABI27_0_0RCTBridge.h"
#import "ABI27_0_0RCTTabBar.h"
#import "ABI27_0_0RCTUIManager.h"
#import "ABI27_0_0RCTUIManagerObserverCoordinator.h"

@implementation ABI27_0_0RCTConvert (UITabBar)

ABI27_0_0RCT_ENUM_CONVERTER(UITabBarItemPositioning, (@{
  @"fill" : @(UITabBarItemPositioningFill),
  @"auto" : @(UITabBarItemPositioningAutomatic),
  @"center" : @(UITabBarItemPositioningCentered)
}), UITabBarItemPositioningAutomatic, integerValue)

@end

@interface ABI27_0_0RCTTabBarManager () <ABI27_0_0RCTUIManagerObserver>

@end

@implementation ABI27_0_0RCTTabBarManager
{
  // The main thread only.
  NSHashTable<ABI27_0_0RCTTabBar *> *_viewRegistry;
}

- (void)setBridge:(ABI27_0_0RCTBridge *)bridge
{
  [super setBridge:bridge];

  [self.bridge.uiManager.observerCoordinator addObserver:self];
}

- (void)invalidate
{
  [self.bridge.uiManager.observerCoordinator removeObserver:self];
}

ABI27_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  if (!_viewRegistry) {
    _viewRegistry = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
  }

  ABI27_0_0RCTTabBar *view = [ABI27_0_0RCTTabBar new];
  [_viewRegistry addObject:view];
  return view;
}

ABI27_0_0RCT_EXPORT_VIEW_PROPERTY(unselectedTintColor, UIColor)
ABI27_0_0RCT_EXPORT_VIEW_PROPERTY(tintColor, UIColor)
ABI27_0_0RCT_EXPORT_VIEW_PROPERTY(barTintColor, UIColor)
ABI27_0_0RCT_EXPORT_VIEW_PROPERTY(translucent, BOOL)
#if !TARGET_OS_TV
ABI27_0_0RCT_EXPORT_VIEW_PROPERTY(barStyle, UIBarStyle)
#endif
ABI27_0_0RCT_EXPORT_VIEW_PROPERTY(itemPositioning, UITabBarItemPositioning)
ABI27_0_0RCT_EXPORT_VIEW_PROPERTY(unselectedItemTintColor, UIColor)

#pragma mark - ABI27_0_0RCTUIManagerObserver

- (void)uiManagerDidPerformMounting:(__unused ABI27_0_0RCTUIManager *)manager
{
  ABI27_0_0RCTExecuteOnMainQueue(^{
    for (ABI27_0_0RCTTabBar *view in self->_viewRegistry) {
      [view uiManagerDidPerformMounting];
    }
  });
}

@end
