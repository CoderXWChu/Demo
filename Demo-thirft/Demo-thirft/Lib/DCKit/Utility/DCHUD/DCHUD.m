//
//  DCHUD.m
//
//  Created by DanaChu on 16/6/2.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCHUD.h"

static UIView *viewPresentedHUD = nil;

@implementation DCHUD

+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title
                                     toView:(UIView *)view
                                   animated:(BOOL)animated {
    __block DCHUD *HUD = nil;
    dispatch_main_sync_safe(^{
        [DCHUD dc_hidePresentedHUD];
        UIView *toView = view != nil ? view : [self rootView];
        if (toView == nil) return;
        HUD = [DCHUD showHUDAddedTo:toView animated:animated];
        HUD.labelFont = [UIFont systemFontOfSize:DCHUDFontSizeDefault];
        HUD.labelText = title;
        HUD.opacity = DCHUDOpacityDefault;
        [self dc_storeView:toView];
    });
    return HUD;
}

+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title
                                     toView:(UIView *)view {
    return [self dc_showHUDWithTitle:title
                                    toView:view
                                  animated:YES];
}

+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title
                                toView:(UIView *)view
                             hideAfter:(NSTimeInterval)afterSecond {
    __block DCHUD *HUD = nil;
    dispatch_main_sync_safe(^{
        [DCHUD dc_hidePresentedHUD];
        UIView *toView = view != nil ? view : [self rootView];
        if (toView == nil) return;
        HUD = [DCHUD showHUDAddedTo:toView animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelFont = [UIFont systemFontOfSize:DCHUDFontSizeDefault];
        HUD.labelText = title;
        HUD.opacity = DCHUDOpacityDefault;
        [HUD hide:YES afterDelay:afterSecond];
        [self dc_storeView:toView];
    });
    return HUD;
}


+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title
                                toView:(UIView *)view
                                  type:(DCHUDType)hudType
{
    __block DCHUD *HUD = nil;
    dispatch_main_sync_safe(^{
        [self dc_hidePresentedHUD];
        UIView *toView = view != nil ? view : [self rootView];
        if (toView == nil) return;
        HUD = [DCHUD showHUDAddedTo:toView animated:YES];
        HUD.labelFont = [UIFont systemFontOfSize:DCHUDFontSizeDefault];
        HUD.labelText = title;
        HUD.opacity = DCHUDOpacityDefault;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [self customViewWithHUDType:hudType];
        [self dc_storeView:toView];
    });
    return HUD;
}

+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title
                                toView:(UIView *)view
                             hideAfter:(NSTimeInterval)afterSecond
                                  type:(DCHUDType)hudType{
    __block DCHUD *HUD = nil;
    dispatch_main_sync_safe(^{
        [self dc_hidePresentedHUD];
        UIView *toView = view != nil ? view : [self rootView];
        if (toView == nil) return;
        HUD = [DCHUD showHUDAddedTo:toView animated:YES];
        HUD.labelFont = [UIFont systemFontOfSize:DCHUDFontSizeDefault];
        HUD.labelText = title;
        HUD.opacity = DCHUDOpacityDefault;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [self customViewWithHUDType:hudType];
        [HUD hide:YES afterDelay:afterSecond];
        [self dc_storeView:toView];
    });
    return HUD;
}

+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title
                             hideAfter:(NSTimeInterval)afterSecond
                                  type:(DCHUDType)hudType
{
    return [self dc_showHUDWithTitle:title
                              toView:nil
                           hideAfter:afterSecond
                                type:hudType];
}

+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title
                             hideAfter:(NSTimeInterval)afterSecond
{
    return [self dc_showHUDWithTitle:title
                              toView:nil
                           hideAfter:afterSecond];
}

+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitle:(NSString *)title
                                                 toView:(UIView *)view {
    __block DCHUD *HUD = nil;
    dispatch_main_sync_safe(^{
        [self dc_hidePresentedHUD];
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        UIView *toView = view != nil ? view : [self rootView];
        if (toView == nil) return;
        HUD = [self showHUDAddedTo:toView animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.animationType = MBProgressHUDAnimationZoom;
        HUD.labelText = title;
        HUD.labelFont = [UIFont systemFontOfSize:DCHUDFontSizeDefault];
        [self dc_storeView:toView];
    });
    return HUD;
}

+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitle:(NSString *)title
{
    return [self dc_showIndeterminateHUDWithTitle:title toView:nil];
}

+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitleType:(DCHUDTitleType)titleType
                                               toView:(UIView *)view {
    return [self dc_showIndeterminateHUDWithTitle:[self dc_titleWithHUDType:titleType]
                                           toView:view];
}

+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitleType:(DCHUDTitleType)titleType{

    return [self dc_showIndeterminateHUDWithTitleType:titleType
                                             toView:nil];
}


+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitleType:(DCHUDTitleType)titleType
                                            hideAfter:(NSTimeInterval)afterSecond
{
    DCHUD *HUD = [self dc_showIndeterminateHUDWithTitleType:titleType];
    [HUD hide:YES afterDelay:afterSecond];
    return HUD;
}


+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message
{
    return [self dc_showHUDWithTitle:message toView:nil
                                type:DCHUDTypeSuccessful];
}
+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message
                     userInterfaceEnable:(BOOL)yesOrNo
{
    DCHUD *HUD = [self dc_showSuccessMessage:message];
    HUD.userInteractionEnabled = !yesOrNo;
    return HUD;
}
+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message
                               hideAfter:(NSTimeInterval)afterSecond
{
    return [self dc_showHUDWithTitle:message
                           hideAfter:afterSecond
                                type:DCHUDTypeSuccessful];
}
+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message
                               hideAfter:(NSTimeInterval)afterSecond
                     userInterfaceEnable:(BOOL)yesOrNo
{
    DCHUD *HUD = [self dc_showSuccessMessage:message hideAfter:afterSecond];
    HUD.userInteractionEnabled = !yesOrNo;
    return HUD;
}



+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage
{
    return [self dc_showHUDWithTitle:errormessage
                              toView:nil
                                type:DCHUDTypeError];
}
+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage
                   userInterfaceEnable:(BOOL)yesOrNo
{
    DCHUD *HUD = [self dc_showErrorMessage:errormessage];
    HUD.userInteractionEnabled = !yesOrNo;
    return HUD;
}
+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage
                             hideAfter:(NSTimeInterval)afterSecond
{
    return [self dc_showHUDWithTitle:errormessage
                           hideAfter:afterSecond
                                type:DCHUDTypeError];
}
+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage
                             hideAfter:(NSTimeInterval)afterSecond
                   userInterfaceEnable:(BOOL)yesOrNo
{
    DCHUD *HUD = [self dc_showErrorMessage:errormessage
                                 hideAfter:afterSecond];
    HUD.userInteractionEnabled = !yesOrNo;
    return HUD;
}



+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message
{
    return [self dc_showHUDWithTitle:message toView:nil];
}
+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message
              userInterfaceEnable:(BOOL)yesOrNo
{
    DCHUD *HUD = [self dc_showMessage:message];
    HUD.userInteractionEnabled = !yesOrNo;
    return HUD;
}
+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message
                        hideAfter:(NSTimeInterval)afterSecond
{
    return [self dc_showHUDWithTitle:message hideAfter:afterSecond];
}
+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message
                        hideAfter:(NSTimeInterval)afterSecond
              userInterfaceEnable:(BOOL)yesOrNo
{
    DCHUD *HUD = [self dc_showMessage:message  hideAfter:afterSecond];
    HUD.userInteractionEnabled = !yesOrNo;
    return HUD;
}




+ (void)dc_hidePresentedHUD
{
    UIView *view = viewPresentedHUD;
    if(view == nil) view = [self rootView];
    if (view == nil) return;
    [DCHUD hideHUDForView:viewPresentedHUD animated:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)dc_hideAfter:(NSTimeInterval)afterSecond {
    [self hide:YES afterDelay:afterSecond];
}

- (void)dc_hideWithTitle:(NSString *)title
               hideAfter:(NSTimeInterval)afterSecond {
    if (title.length > 0) {
        self.labelText = title;
        self.mode = MBProgressHUDModeText;
    }
    [self hide:YES afterDelay:afterSecond];
}

- (void)dc_hideWithTitle:(NSString *)title
               hideAfter:(NSTimeInterval)afterSecond
                    type:(DCHUDType)hudType
{
    self.labelText = title;
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[self class] customViewWithHUDType:hudType];;
    [self hide:YES afterDelay:afterSecond];
}


#pragma mark - Private

+ (UIView *)rootView
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topController.presentedViewController) {
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
    }
    return topController.view;
}

+ (void)dc_storeView:(UIView *)view
{
    if (view != viewPresentedHUD) {
        viewPresentedHUD = view;
    }
}


+ (NSString *)dc_imageNamedWithHUDType:(DCHUDType)hudType
{
    switch (hudType) {
        case DCHUDTypeSuccessful:
            return @"DCHUDResource.bundle/successful";
            break;
        case DCHUDTypeError:
            return @"DCHUDResource.bundle/error";
            break;
        case DCHUDTypeWarning:
            return @"DCHUDResource.bundle/warning";
            break;
        case DCHUDTypeInfo:
            return nil;
            break;
        default:
            NSAssert(NO, @"必须为已知类型的DCHUDType!");
            break;
    }
}

+ (NSString *)dc_titleWithHUDType:(DCHUDTitleType)hudType
{
    switch (hudType) {
        case DCHUDTitleTypeLoading:
            return @"正在加载...";
            break;
        case DCHUDTitleTypeLoadError:
            return @"加载错误!";
            break;
        case DCHUDTitleTypeLoadSuccessful:
            return @"加载成功!";
            break;
        case DCHUDTitleTypeNoMoreData:
            return @"没有更多数据...";
            break;
        case DCHUDTitleTypeLogin:
            return @"正在登录...";
        default:
            NSAssert(NO, @"必须为已知类型的DCHUDTitleType!");
            break;
    }
}

+ (UIImageView *)customViewWithHUDType:(DCHUDType)hudType
{
    NSString *imageName = [[self class ] dc_imageNamedWithHUDType:hudType];
    if (imageName == nil || imageName.length == 0 || [imageName isEqualToString:@""]) return nil;
    NSAssert((imageName && imageName.length > 0), @"'dc_imageNamedWithHUDType:'传入的hudType必须为已知类型!");
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    customView.frame = CGRectMake(0, 0, 35, 35);
    return customView;
}

@end
