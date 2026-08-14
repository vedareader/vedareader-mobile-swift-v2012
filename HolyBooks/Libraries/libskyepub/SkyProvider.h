//
//  SkyProvider.h
//  SkyEPub
//
//  Created by SkyTree on 14. 11. 13..
//  Copyright (c) 2014년 SkyEpub Corporation. All rights reserved.
//Encryption

#import <Foundation/Foundation.h>
#import "ContentProvider.h"

@class SkyProvider;
@class Book;


@protocol SkyProviderDataSource <NSObject>
@optional
-(NSString*)skyProvider:(SkyProvider*)sp keyForEncryptedData:(NSString*)uuidForContent contentName:(NSString*)contentName uuidForEpub:(NSString*)uuidForEpub;
@end

@interface SkyProvider : NSObject <ContentProvider> {
    __weak Book* book;
    __weak id <SkyProviderDataSource> dataSource;
    __weak NSString* baseDirectory;
}
@property (nonatomic, weak) id <SkyProviderDataSource> dataSource;
@property (nonatomic, weak) Book* book;
@property (nonatomic, weak) NSString* baseDirectory;

-(void)destroy;

@end
