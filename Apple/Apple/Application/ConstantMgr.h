
/*------------------------公共部分定义---开始--------------------*/

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

#define IOS7    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)
#define IOS8    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
#define IOS9    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=9.0)
#define IOS10    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=10.0)
#define IOS11    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=11.0)


#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1472), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? YES : NO)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kNewTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)



#define kColor(r,g,b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kThemeColor           kColor(0, 132, 215)
#define kNavBarColor          kColor(0, 132, 215)
#define kThemeBackgroundColor kColor(242, 242, 242)

#define kCustomColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kBgColor                                 [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]
#define kBlackBgColor                                 [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0]
#define kMainColor                                 [UIColor colorWithRed:0/255.0 green:184/255.0 blue:240/255.0 alpha:1.0]
#define kWhiteColor                              [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]
#define kLightBlackColor                         [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0f]
#define kGreenColor                              [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_color"]]
#define kRedColor                                [UIColor redColor]

#define kDefaultUserIcon                         [UIImage imageNamed:@"default_user.jpg"]
#define kNavMenuItemTextColor                    kWhiteColor
#define kNavMenuItemTextFont                     [UIFont boldSystemFontOfSize:16.0f]
#define kDefaultCellHeight                       70.0f


#define kLocalMusicLoadedNotfc                   @"kLocalMusicLoadedNotfc"


////////////
#define kSepratorPaddingLeft                     15
#define kSepratorSize                            0.5
#define kSepratorColor                           [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:0.4]
#define kShadowLayerColor                        [UIColor blackColor]
#define kShadowLayerAlpha                        0.3
#define kUnReadColor                             kGreenColor
#define kUnReadRadius                            8.0
#define kUnReadCirclePointColor                  kWhiteColor
#define kViewDistantTop                          10.0f
#define kViewPaddingLan                          14.0f

#define kNormalFieldHeight                       42.0f
#define kNormalFieldTextSize                     15.0f
#define kNormalFieldCornerRadius                 4.0
#define kNormalButtonHeight                      42.0f
#define kNormalButtonTextSize                    16.0f
#define kNormalButtonCornerRadius                4.0 

#define kMiniLabelSize                           10.0f
#define kSmallLabelSize                          12.0f
#define kNormalLabelSize                         14.0f
#define kBigLabelSize                            16.0f
#define kLargerLabelSize                         18.0f
#define kLargestLabelSize                        22.0f

//每次刷新一页取多少数据
#define kPageCount 20
#define kSpeakerViewHeight 55

#define cellBackGroundImage [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg"]]

#define kWaittingText      @"Loading..."
#define kOKText            @"OK"
#define kCancelText        @"Cancel"
#define kNOText            @"NO"
#define kYESText           @"YES"

#define kBackgroundImageName @"6.背景叠加"

#define kDefaultCoverImageName @"3-5.默认专辑封面"

//自定义Log
#ifdef DEBUG
#define TSLog(...) NSLog(__VA_ARGS__)
#else
#define TSLog(...)
#endif

///////当前用户信息
#define CURRENT_USERID                               @"1"
#define CURRENT_USERTOKEN                            @""
 

/*------------------------公共部分定义----结束-------------------*/

#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)


/****************************** 第三方申请的资料 ******************************/

#define kBuglyAppID  @"d98a9f78cb"
#define kBuglyAppKey @"2b7fc95d-d364-4685-a7d9-219c009cf9ae"


/****************************** 第三方结束 ******************************/
