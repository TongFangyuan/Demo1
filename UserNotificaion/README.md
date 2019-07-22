#   TTNotificationCenter

##  说明

- 这是一个本地通知的DEMO
- iOS10及以上


## 使用

### 获取通知权限
```
[TTNotificationCenter.shareCenter requestAuth:^(BOOL granted) {
NSLog(@"通知权限：%d",granted);
}];
```

### 添加通知
```
[TTNotificationCenter.shareCenter addNotificationWithTitle:@"Battery Charged" body:@"Good news! The Battery is fully charged and good to go!" timeInterval:15 repeats:NO];
```

### 获取通知内容
监听`TTNotificationNameReceiveData`通知即可
