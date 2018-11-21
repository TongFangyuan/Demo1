//
//  VerifyCodeView.m
//  VerificationCode
//
//  Created by admin on 2018/11/21.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "VerifyCodeView.h"
#import "Masonry.h"



@interface VerifyCodeView()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *field1;
@property (nonatomic,strong) UITextField *field2;
@property (nonatomic,strong) UITextField *field3;
@property (nonatomic,strong) UITextField *field4;
@property (nonatomic,strong) UITextField *field5;
@property (nonatomic,strong) UITextField *field6;

@end

@implementation VerifyCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    
    for (int i=1; i<=6; i++) {
        UITextField *textField = [UITextField new];
        [self addSubview:textField];
        
        /// 样式
        textField.tag = i;
        textField.layer.borderColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1].CGColor;
        textField.layer.borderWidth = 1;
        textField.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        textField.layer.cornerRadius = 8;
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBold];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
        
//        textField.text = [NSString stringWithFormat:@"%d",i];
        
        int offset = i-3;
        CGFloat startOffset = offset>0 ? (kItemSpace*0.5+kItemWidth*0.5) : -(kItemSpace*0.5+kItemWidth*0.5);
        int time = offset>0 ? (offset-1) : offset;
        CGFloat xOffset = (kItemWidth+kItemSpace) * time + startOffset;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kItemWidth, kItemHeight));
            make.centerY.equalTo(self);
            make.centerX.mas_equalTo(self).offset(xOffset);
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChange:(NSNotification *)noti
{
    UITextField *obj = noti.object;
    if (obj.superview!=self) return;
    if (obj.text.length <=0) return;
    
    UITextField *next = [self viewWithTag:(obj.tag+1)];
    if (next) {
        [next becomeFirstResponder];
    } else {
        [self getText];
        [obj resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *willText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (willText.length>1) {
        return NO;
    }
    return YES;
}

- (NSString *)getText
{
    NSString *text = [NSString new];
    for (int i=1; i<=6; i++) {
        UITextField *obj = [self viewWithTag:i];
        text = [text stringByAppendingString:obj.text];
    }
    NSLog(@"code: %@",text);
    return text;
}
@end
