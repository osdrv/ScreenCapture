//
//  GenericStorageAgent+ViewBuilder.h
//  ScreenCapture
//
//  Created by Olegs on 30/10/14.
//  Copyright (c) 2014 Brand New Heroes. All rights reserved.
//

#import "GenericStorageAgent.h"
#import "AbstractStorageAgentViewBuilder.h"


@interface GenericStorageAgent (ViewBuilder)

- (NSView *)buildActionView:(NSManagedObject *)managedObject withBuilder:(AbstractStorageAgentViewBuilder *)builder;

- (AbstractStorageAgentViewBuilder *)getMenuItemViewBuilder;

- (BOOL)hasMenuAction;

@end
