//
//  HttpTool.m
//
//

#import "HttpTool.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "HttpErrShowViewController.h"
#import "HttpToolLog.h"
#import "HttpTool+Business.h"
#import "HttpToolErrHandler.h"

#define timeout 15
#define Quality 0.6

static AFHTTPSessionManager * httpManager;

@implementation HttpTool

+ (AFHTTPSessionManager*) http{
    if(!httpManager){
        httpManager = [[AFHTTPSessionManager alloc] init];
        httpManager.requestSerializer.timeoutInterval = timeout;
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        response.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html",nil];
        response.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        //response.removesKeysWithNullValues = YES; //去掉为NSULL的值
        response.readingOptions = NSJSONReadingMutableContainers|NSJSONReadingAllowFragments;
        httpManager.responseSerializer = response;
        httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [HttpToolErrHandler shareHandler];
    }
    return httpManager;
}


+(void) enterHttpError:(NSError*)error task:(NSURLSessionDataTask*)t failBlock:(void(^)(NSError * eMsg))fail{
    
    NSString * emsg = @"网络错误";
    if(error.code == NSURLErrorTimedOut){
        emsg = @"网络超时，请稍后再试！";
    }
    else if( ((NSHTTPURLResponse*)t.response).statusCode == 404){
        emsg = @"服务器错误 404 ";
    }
    else if(error.code == 3840) {
        emsg = @"服务器错误json格式";
    }
    else if(error.code == NSURLErrorBadServerResponse) {
        emsg = @"服务器错误";
    }
    NSError * e = [NSError errorWithDomain:emsg code:-1 userInfo:nil];
    fail(e);
}


+(NSURLSessionTask*) getWithPath:(NSString*)path
                           param:(NSDictionary *)param
                            succ:(void(^)(id json))succ
                            fail:(void(^)(NSError * err))fail{

    NSDictionary * commHeads = [HttpTool commonHttpHeads];
    
    NSMutableDictionary * p = [param mutableCopy];
    [[self commonParams] enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        p[key] = obj;
    }];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL, path];
    
    NSDictionary * heads   = [self http].requestSerializer.HTTPRequestHeaders;
    [HttpToolLog Log:@" ====== [HTTP] : GET :%@ \n param:%@ reqHeads:%@",urlStr,p,heads];
    
    return [[self http] GET:urlStr parameters:p headers:commHeads progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpToolLog Log:@"====== [HTTP] : path:%@ ==========responseJson :%@" , responseObject,path];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            id ret = [self prepareBusinessJson1:responseObject path:path];
            if([ret isKindOfClass:[NSError class]]){
                fail(ret);
            }else{
                succ(ret);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code != NSURLErrorCancelled){
                [HttpToolLog Log:@"====== httpGet error:%@",error];
                [self enterHttpError:error task:task failBlock:fail];
            }
        });
    }];
}


+(NSURLSessionTask*) postWithPath:(NSString*)path
                            param:(NSDictionary *)param
                             succ:(void(^)(id json))succ
                             fail:(void(^)(NSError * err))fail{
    
    NSMutableDictionary * p = [param mutableCopy];
    [[self commonParams] enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        p[key] = obj;
    }];
    
    NSDictionary * commHeads = [HttpTool commonHttpHeads];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL, path];
    
    NSDictionary * heads   = [self http].requestSerializer.HTTPRequestHeaders;
    [HttpToolLog Log:@" ====== [HTTP] : Post :%@ \n param:%@ reqHeads:%@",urlStr,p,heads];
    
    return [[self http] POST:urlStr parameters:p headers:commHeads progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpToolLog Log:@"====== [HTTP] : path:%@ ==========responseJson :%@" , responseObject,path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id ret = [self prepareBusinessJson1:responseObject path:path];
            if([ret isKindOfClass:[NSError class]]){
                fail(ret);
            }else{
                [self recvePostResponseWithTask:task];
                succ(ret);
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code != NSURLErrorCancelled){
                [HttpToolLog Log:@"====== httpPost error:%@",error];
                [self enterHttpError:error task:task failBlock:fail];
            }
        });
    }];
}


+(NSURLSessionTask *)deleteWithPath:(NSString *)path param:(NSDictionary *)param succ:(void (^)(id))succ fail:(void (^)(NSError * err))fail{
    
    NSMutableDictionary * p = [param mutableCopy];
    [[self commonParams] enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        p[key] = obj;
    }];
    
    NSDictionary * commHeads = [HttpTool commonHttpHeads];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL, path];
    
    NSDictionary * heads   = [self http].requestSerializer.HTTPRequestHeaders;
    [HttpToolLog Log:@" ====== [HTTP] : delete :%@ \n param:%@ reqHeads:%@",urlStr,p,heads];
    
    return [[self http] DELETE:urlStr parameters:p headers:commHeads success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HttpToolLog Log:@"====== [HTTP] : path:%@ ==========responseJson :%@" , responseObject,path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id ret = [self prepareBusinessJson1:responseObject path:path];
            if([ret isKindOfClass:[NSError class]]){
                fail( ret);
            }else{
                [self recvePostResponseWithTask:task];
                succ(ret);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code != NSURLErrorCancelled){
                [HttpToolLog Log:@"====== httpDelete error:%@",error];
                [self enterHttpError:error task:task failBlock:fail];
            }
        });
    }];
}

+(NSURLSessionTask*) putWithPath:(NSString*)path
                           param:(NSDictionary *)param
                            succ:(void(^)(id json))succ
                            fail:(void(^)(NSError * err))fail{
    
    NSMutableDictionary * p = [param mutableCopy];
    [[self commonParams] enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        p[key] = obj;
    }];
    
    NSDictionary * commHeads = [HttpTool commonHttpHeads];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL, path];
    
    NSDictionary * heads   = [self http].requestSerializer.HTTPRequestHeaders;
    [HttpToolLog Log:@" ====== [HTTP] : PUT :%@ \n param:%@ reqHeads:%@",urlStr,p,heads];
    
    return [[self http] PUT:urlStr parameters:p headers:commHeads success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HttpToolLog Log:@"====== [HTTP] : path:%@ ==========responseJson :%@" , responseObject,path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id ret = [self prepareBusinessJson1:responseObject path:path];
            if([ret isKindOfClass:[NSError class]]){
                fail(ret);
            }else{
                [self recvePostResponseWithTask:task];
                succ(ret);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code != NSURLErrorCancelled){
                [HttpToolLog Log:@"====== httpPut error:%@",error];
                [self enterHttpError:error task:task failBlock:fail];
            }
        });
    }];
}

/*
+(NSURLSessionTask* ) uploadImageFile:(UIImage*)img
                           parameters:(NSDictionary*)parameters
                   compressionQuality:(CGFloat)compressionQuality
                             progress:(void (^)(CGFloat ,CGFloat ))progress
                                 succ:(void (^)(NSString *))succ
                                 fail:(void (^)(NSString *))fail{
    NSMutableDictionary * p = @{}.mutableCopy;
    [[self commonParams] enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        p[key] = obj;
    }];
    
    NSDictionary * commHeads = [HttpTool commonHttpHeads];
    [commHeads enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [[self http].requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    
    NSData   *imageData = UIImageJPEGRepresentation(img,compressionQuality);
    NSString *imgType = @"image/jpeg";
    NSString *fileName = @"img.jpg";
    if(!imageData){
        imageData = UIImagePNGRepresentation(img);
        imgType = @"image/png";
        fileName = @"img.png";
    }
    if(!imageData){
        fail(@"无效图片");
        return nil;
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,@"v1/api/upload"];
    NSDictionary * heads = [self http].requestSerializer.HTTPRequestHeaders;
    [HttpToolLog Log:@" ====== [HTTP] : uploadImage :%@ \n param:%@ reqHeads:%@",urlStr,p,heads];
    
    return [[self http] POST:urlStr parameters:p constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:imgType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(progress){
                progress(uploadProgress.completedUnitCount ,(CGFloat)uploadProgress.totalUnitCount);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpToolLog Log:@"====== [HTTP] : uploadImage responseJson :%@" , responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            id ret = [self prepareBusinessJson1:responseObject path:urlStr];
            if([ret isKindOfClass:[NSError class]]){
                fail( ((NSError*)ret).domain );
            }else{
                NSString * url = ret[@"url"];
                succ(url);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code != NSURLErrorCancelled){
                [HttpToolLog Log:@"====== uploadImage error:%@",error];
                [self enterHttpError:error task:task failBlock:fail];
            }
        });
    }];
}

+(NSURLSessionTask* ) uploadImageFile:(UIImage*)img
                             category:(NSString*)category
                             progress:(void (^)(CGFloat ,CGFloat ))progress
                                 succ:(void (^)(NSString *))succ
                                 fail:(void (^)(NSString *))fail{
    
    return [self uploadImageFile:img
                        category:category
              compressionQuality:Quality
                        progress:progress
                            succ:succ fail:fail];
}


+(NSURLSessionTask* ) uploadImageFile:(UIImage*)img
                             category:(NSString*)category
                     compressionQuality:(CGFloat)compressionQuality
                               progress:(void (^)(CGFloat ,CGFloat ))progress
                                   succ:(void (^)(NSString *))succ
                                   fail:(void (^)(NSString *))fail{
    
    return [self uploadImageFile:img
                      parameters:@{@"type":@(0),@"category":category}
              compressionQuality:compressionQuality
                        progress:progress
                            succ:succ fail:fail];
}




+(void) uploadImages:(NSMutableArray*)images
            category:(NSString*)category
     returnFileNames:(NSMutableArray*)files
             showMsg:(NSString*)msg
          completion:(void(^)(NSArray *results,NSString *eMsg))completion{
    
    static CGFloat curSize = 0;
    static CGFloat totalSize = 0;
    
    if(totalSize <=0 ){
        [images enumerateObjectsUsingBlock:^(UIImage* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            totalSize += [HttpTool getUploadSizeForImage:obj];
            curSize = 0;
        }];
    }
    __weak typeof(self) wSelf = self;
    if(images.count > 0){
        UIImage * img =  images.firstObject;
        [images removeObjectAtIndex:0];
        __block CGFloat curUploadImageSize = 0;
        [HttpTool uploadImageFile:img category:category progress:^(CGFloat cur, CGFloat total) {
            curUploadImageSize = total;
            [SVProgressHUD showProgress:(curSize+cur)/totalSize status:msg];
        } succ:^(NSString *url) {
            NSLog(@"%@",url);
            
            [files addObject:url];
            
            curSize += curUploadImageSize;
            
            [wSelf uploadImages:images category:category returnFileNames:files showMsg:msg completion:completion];
            
        } fail:^(NSString *eMsg) {
            totalSize = 0;
            curSize = 0;
            completion(nil,@"上传图片错误!");
        }];
        
    }else{
        [SVProgressHUD dismiss];
        totalSize = 0;
        curSize = 0;
        if(files.count > 0) {
           completion(files,nil);
        }else {
           completion(nil,nil);
        }
    }
}


+(CGFloat)getUploadSizeForImage:(UIImage *)image{
    return UIImageJPEGRepresentation(image,Quality).length;
}
*/

@end
