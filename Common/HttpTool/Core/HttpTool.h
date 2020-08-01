//
//  HttpTool.h
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HttpTool : NSObject


+(NSURLSessionTask*) getWithPath:(NSString*)path
                           param:(NSDictionary *)param
                            succ:(void(^)(id json))succ
                            fail:(void(^)(NSError * err))fail;

+(NSURLSessionTask*) postWithPath:(NSString*)path
                            param:(NSDictionary *)param
                             succ:(void(^)(id json))succ
                             fail:(void(^)(NSError * err))fail;

+(NSURLSessionTask*) deleteWithPath:(NSString*)path
                            param:(NSDictionary *)param
                             succ:(void(^)(id json))succ
                             fail:(void(^)(NSError * err))fail;

+(NSURLSessionTask*) putWithPath:(NSString*)path
                              param:(NSDictionary *)param
                               succ:(void(^)(id json))succ
                               fail:(void(^)(NSError * err))fail;

/*
+(NSURLSessionTask* ) uploadImageFile:(UIImage*)img
                             category:(NSString*)category
                             progress:(void (^)(CGFloat cur,CGFloat total))progress
                                 succ:(void (^)(NSString *path))succ
                                 fail:(void (^)(NSString *msg))fail;

+(NSURLSessionTask* ) uploadImageFile:(UIImage*)img
                             category:(NSString*)category
                   compressionQuality:(CGFloat)compressionQuality
                             progress:(void (^)(CGFloat cur,CGFloat total))progress
                                 succ:(void (^)(NSString *path))succ
                                 fail:(void (^)(NSString *msg))fail;

//多线程调用?
+(void) uploadImages:(NSMutableArray*)images
            category:(NSString*)category
     returnFileNames:(NSMutableArray*)files
             showMsg:(NSString*)msg
          completion:(void(^)(NSArray *results,NSString *eMsg))completion;

+(CGFloat) getUploadSizeForImage:(UIImage*)image;
 */

@end
