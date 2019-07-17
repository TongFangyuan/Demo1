#  第三方集成

## facebook 登录

### 配置 info.plist

1. 右键点击 `info.plist`，然后选择 作为源代码打开。

2. 将下列 XML 代码片段复制并粘贴到文件正文中 (<dict>...</dict>)。

```
<key>CFBundleURLTypes</key> <array> <dict> <key>CFBundleURLSchemes</key> <array> <string>fb359012484787426</string> </array> </dict> </array> <key>FacebookAppID</key> <string>359012484787426</string> <key>FacebookDisplayName</key> <string>登录测试</string>
```

3. 如要使用任何 Facebook 对话框（例如，登录、分享、应用邀请等），以便从您的应用切换至 Facebook 应用，则您应用程序的 info.plist 还必须包含：
```
<key>LSApplicationQueriesSchemes</key> <array> <string>fbapi</string> <string>fb-messenger-share-api</string> <string>fbauth2</string> <string>fbshareextension</string> </array>
```

4. 构建设置

4.1 前往 Xcode 中的项目导航器，然后选择您的项目以查看项目设置。

4.2 选择其他关联工具标记以进行编辑。

4.3 将 -ObjC 标记添加到其他关联工具标记，并应用于所有构建目标。
![](http://ww1.sinaimg.cn/large/9f473525gy1g4ukns9kqnj20eh00jdfn.jpg)
