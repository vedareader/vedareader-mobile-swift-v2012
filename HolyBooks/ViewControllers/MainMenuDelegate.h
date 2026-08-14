//
//  MainMenuDelegate.h
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#ifndef HolyBooks_MainMenuDelegate_h
#define HolyBooks_MainMenuDelegate_h

@protocol MainMenuDelegate <NSObject>

- (void)mainMenuDidSelected;

- (void)mainMenuStopInteracting;
- (void)mainMenuResumeInteracting;

@optional

- (void)mainMenuOpenSearchResults;

@end

#endif
