#  第三方字体

## 将工具目录拖入工程
`TTFont`文件夹拖入工程

## 在`info.plist`中配置字体
```
<!--  配置第三方字体  -->
<key>UIAppFonts</key>
<array>
<string>filsonsoft-light.otf</string>
<string>filsonsoft-book.otf</string>
<string>Chantal-boldItalic.ttf</string>
<string>Chantal-medium.ttf</string>
<string>Chantal-lightItalic.ttf</string>
<string>CHANTAL.TTF</string>
<string>sf-pro-text_regular.ttf</string>
</array>
```
## 使用字体

```
cell.textLabel.font = [UIFont tt_fontWithName:TTFontNameChantalMedium size:35.f];
```

## 支持的字体

```
#pragma mark - Chantal 字体
extern TTFontName const TTFontNameChantalNormal;
extern TTFontName const TTFontNameChantalMedium;
extern TTFontName const TTFontNameChantalBoldItalic;
extern TTFontName const TTFontNameChantalLightItalic;

#pragma mark - Filson Soft 字体
extern TTFontName const TTFontNameFilsonSoftLight;
extern TTFontName const TTFontNameFilsonSoftBook;

#pragma mark - SFProText 字体
extern TTFontName const TTFontNameSFProTextRegular;
```
