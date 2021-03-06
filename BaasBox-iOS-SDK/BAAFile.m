//
//  BAAFile.m
//
//  Created by Cesare Rocchi on 12/11/13.
//  Copyright (c) 2013 Cesare Rocchi. All rights reserved.
//

#import "BAAFile.h"

@interface BAAFile  ()

@property (nonatomic, copy) NSURL *fileURL;
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
@property (nonatomic, strong) BAAClient *client;

@end

@implementation BAAFile

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        _fileId = dictionary[@"id"];
        _author = dictionary[@"_author"];
        _contentType = dictionary[@"contentType"];
        _creationDate = dictionary[@"_creation_date"];
        _attachedData = dictionary[@"attachedData"];
        _metadataData = dictionary[@"metadata"];
        
    }
    
    return self;
    
}

-(instancetype)initWithData:(NSData *)data {
    
    self = [super init];
    
    if (self) {
        
        _data = data;
        
    }
    
    return self;
    
}

- (BAAClient *) client {
    
    if (_client == nil)
        _client = [BAAClient sharedClient];
    
    return _client;
    
}

- (NSMutableDictionary *) attachedData {
    if (_attachedData == nil)
        _attachedData = [NSMutableDictionary dictionary];
    
    return _attachedData;
    
}

+ (void) getFilesWithCompletion:(BAAArrayResultBlock)completionBlock {
    
    BAAClient *client = [BAAClient sharedClient];
    [client loadFiles:[[self alloc] init]
           completion:completionBlock];
    
}

- (NSURL *) fileURL {
    
    if (self.fileId == nil)
        return nil;
    
    NSString *URLString = [NSString stringWithFormat:@"%@/file/%@", self.client.baseURL, self.fileId];
    return [NSURL URLWithString:URLString];
    
}

- (void) loadFileWithCompletion:(void(^)(NSData *data, NSError *error))completionBlock {
    
    self.downloadTask = [self.client loadFileData:self
                                       completion:^(NSData *data, NSError *error) {
                                           
                                           if (completionBlock) {
                                               completionBlock(data, error);
                                           }
                                           
                                       }];
    
}

- (void) loadFileWithParameters:(NSDictionary *)parameters completion:(void(^)(NSData *data, NSError *error))completionBlock {
    
    self.downloadTask = [self.client loadFileData:self
                                       parameters:parameters
                                       completion:^(NSData *data, NSError *error) {
                                           
                                           if (completionBlock) {
                                               completionBlock(data, error);
                                           }
                                           
                                       }];
    
}

- (void) stopFileLoading {
    
    [self.downloadTask suspend];
    
}

+ (void) loadFileDetails:(NSString *)fileId completion:(BAAObjectResultBlock)completionBlock {

    BAAClient *client = [BAAClient sharedClient];
    [client loadFileDetails:fileId
                 completion:^(id object, NSError *error) {
                     
                     if (completionBlock)
                         completionBlock(object, error);
                     
                 }];
    
}

#pragma mark - Permissions

- (void) grantAccessToRole:(NSString *)roleName ofType:(NSString *)accessType completion:(BAAObjectResultBlock)completionBlock {
    
    [self.client grantAccess:self
                      toRole:roleName
                  accessType:accessType
                  completion:completionBlock];
    
}

- (void) grantAccessToUser:(NSString *)username ofType:(NSString *)accessType completion:(BAAObjectResultBlock)completionBlock {
    
    [self.client grantAccess:self
                      toUser:username
                  accessType:accessType
                  completion:completionBlock];
    
}

- (void) revokeAccessToRole:(NSString *)roleName ofType:(NSString *)accessType completion:(BAAObjectResultBlock)completionBlock {
    
    [self.client revokeAccess:self
                       toRole:roleName
                   accessType:accessType
                   completion:completionBlock];
    
}

- (void) revokeAccessToUser:(NSString *)username ofType:(NSString *)accessType completion:(BAAObjectResultBlock)completionBlock {
    
    [self.client revokeAccess:self
                       toUser:username
                   accessType:accessType
                   completion:completionBlock];
    
}

#pragma mark - Upload

- (void) uploadFileWithCompletion:(BAAObjectResultBlock)completionBlock {
    
    [self.client uploadFile:self
                 completion:completionBlock];
    
    
}

#pragma mark - Delete

- (void) deleteFileWithCompletion:(BAABooleanResultBlock)completionBlock {
    
    [self.client deleteFile:self
                 completion:completionBlock];
    
}

@end
