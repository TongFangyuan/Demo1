//
//  UDPViewController.m
//  GCDAsyncSocketDemo
//
//  Created by Tong on 2019/9/29.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "UDPViewController.h"
#import "GCDAsyncUdpSocket.h"

@interface UDPViewController ()<GCDAsyncUdpSocketDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *socket;
@property (nonatomic, strong) dispatch_queue_t udpQueue;

@property (weak, nonatomic) IBOutlet UITextField *ip;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UIButton *listenBtn;
@property (weak, nonatomic) IBOutlet UITextView *logView;
@property (weak, nonatomic) IBOutlet UITextView *sendView;

- (IBAction)clickListenBtn:(UIButton *)sender;
- (IBAction)clickClearBtn:(UIButton *)sender;
- (IBAction)clickSendBtn:(UIButton *)sender;

@end

@implementation UDPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.udpQueue = dispatch_get_main_queue();
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:self.udpQueue];
    self.ip.text = @"172.18.1.213";
    self.port.text = @"12476";
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickListenBtn:(UIButton *)sender {
    if (self.ip.text.length<=0 || self.port.text.length<=0) {
        [self log:@"请输入ip或者端口号"];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSString *ip  = self.ip.text;
        int port = [self.port.text intValue];
        NSError *error;
        [self.socket bindToPort:port error:&error];
        [self.socket enableBroadcast:YES error:&error];
        [self.socket beginReceiving:&error];
        if (error) {
            [self log:error.localizedDescription];
        } else {
            NSLog(@"start listen server %@:%d",[self.socket localHost],[self.socket localPort]);
            [self log:[NSString stringWithFormat:@"start listen server %@:%d",self.socket.connectedHost,self.socket.connectedPort]];
        }
    } else {
        [self.socket close];
    }
    
}

- (IBAction)clickClearBtn:(UIButton *)sender {
    self.logView.text = @"";
}

- (IBAction)clickSendBtn:(UIButton *)sender {
    if (self.sendView.text.length<=0) return;
    NSData *data = [self.sendView.text dataUsingEncoding:NSUTF8StringEncoding];
    int tag = random();
    [self.socket sendData:data withTimeout:1 tag:tag];
//    [self.socket sendData:<#(nonnull NSData *)#> toAddress:<#(nonnull NSData *)#> withTimeout:<#(NSTimeInterval)#> tag:<#(long)#>]
}

- (void)log:(NSString *)str {
    self.logView.text = [NSString stringWithFormat:@"%@\n%@",self.logView.text,str];
}
#pragma mark  - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    NSString *host;
    uint16_t port = 0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];

    NSString *logString = [NSString stringWithFormat:@"didConnectToAddress %@:%d",host,port];
    NSLog(@"%@",logString);
    [self log:logString];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
    NSString *logString = [NSString stringWithFormat:@"%@%@",@"udp connect failed",error.localizedDescription];
    NSLog(@"%@",logString);
    [self log:logString];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSString *logString = [NSString stringWithFormat:@"%@:%ld",@"didSendDataWithTag",tag];
    NSLog(@"%@",logString);
    [self log:logString];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {
    NSString *logString = [NSString stringWithFormat:@"%@:%ld error:%@",@"didNotSendDataWithTag",tag,error.localizedDescription];
    NSLog(@"%@",logString);
    [self log:logString];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext {
    NSString *host = [GCDAsyncUdpSocket hostFromAddress:address];
    host = [host stringByReplacingOccurrencesOfString:@"::ffff:" withString:@""];
    int port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *logString = [NSString stringWithFormat:@"%@:%d %@",host,port,data];
    NSLog(@"%@",logString);
    [self log:logString];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
    NSString *logString = [NSString stringWithFormat:@"%@:%@",@"udpSocketDidClose with error",error];
    NSLog(@"%@",logString);
    [self log:logString];
}

#pragma mark - ------------- UITextFieldDelegate ------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
