//
//  protocolCard.h
//  CardTwins
//
//  Created by Константин on 17.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#ifndef CardTwins_protocolCard_h
#define CardTwins_protocolCard_h

@class CardView;

@protocol protocolCard <NSObject>

- (void) changeSost: (CardView*)card;

- (BOOL) checkClickCard;
@end

#endif
