NSMPlayer 可植入多个基于不同播放器内核的功能强大的视频播放器。默认内置了基于 AVPlayer 为内核的播放器。

## Features
- 播放器底层使用层次状态机来管理播放器的状态
- 播放器和渲染层可以分离
- 播放器支持销毁和恢复功能
- 添加是否允许 3G/4G 网络播放功能
- 播放器的控制面板 UI 和播放器分离，支持完全自定义控制面板的 UI
- 支持循环播放、自动播放等播放器的默认功能

## Supported Formats

AVPlayer 默认支持的媒体格式

## Requirements

- iOS 8.0 or later
- Xcode 7.3 or later

## Installation

### Podfile

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'NSMPlayer'
end
```
如果使用 Swift, 需要在 Podfile 中 添加 `use_frameworks!` ，并且 target 要设定成 iOS 8+:

```ruby
platform :ios, '8.0'
use_frameworks!
```

然后执行以下命令:

```bash
$ pod install
```

### Installation with Carthage

Coming soon

## Getting Started

```objective-c
self.playerController = [[NSMVideoPlayerController alloc] init];

NSMPlayerAsset *playerAsset = [[NSMPlayerAsset alloc] init];
playerAsset.assetURL = [NSURL URLWithString:@"http://vjs.zencdn.net/v/oceans.mp4"];
[self.playerController.videoPlayer replaceCurrentAssetWithAsset:playerAsset];

NSMAVPlayerView *playerRenderingView = [[NSMAVPlayerView alloc] init];
NSMPlayerAccessoryView *accessoryView = [[NSMPlayerAccessoryView alloc] init];
self.playerController.videoPlayer.playerView = playerRenderingView;

[self.view addSubview:playerRenderingView];
[self.view addSubview:accessoryView];
```

## How To Use

### NSMVideoPlayerController

使用 `NSMVideoPlayerController` 是播放器的管理类，用来管理遵循 `NSMVideoPlayerProtocol` 协议的对象，使用遵循该协议的对象就可以对播放器的进行相关的控制操作，也可以通过该协议中定义的属性拿到你所想要的播放器状态、视频尺寸等一系列有关播放器的信息。

播放一个视频源

```objective-c
NSMVideoPlayerController *playerController = [[NSMVideoPlayerController alloc] init];

NSMPlayerAsset *playerAsset = [[NSMPlayerAsset alloc] init];
[playerAsset.assetURL = [NSURL URLWithString:@"http://vjs.zencdn.net/v/oceans.mp4"]
[playerController.videoPlayer replaceCurrentAssetWithAsset:playerAsset];
```

### NSMVideoPlayerProtocol

遵循 `NSMVideoPlayerProtocol` 协议的对象可以对播放器进行控制，举例：播放、暂停、seek、允许 WWAN 播放、销毁和恢复播放器等功能.
`NSMVideoPlayer` 对象是一个遵循 `NSMVideoPlayerProtocol` 协议的播放器控制对象，也是 NSMPlayer 中最核心的一个类。`NSMVideoPlayer` 内部使用层次状态机来管理底层播放器内核在处理不同指令时状态的切换，并且在状态发生变化的时候以通知形式发送出去。`NSMVideoPlayer` 中管理着实际用来控制媒体资源的底层的播放器。

播放器主要的控制接口

```objective-c
// 添加一个媒体资源
- (void)replaceCurrentAssetWithAsset:(NSMPlayerAsset *)asset;
// 播放
- (void)play;
// 暂停
- (void)pause;
// 移动播放进度
- (BFTask *)seekToTime:(NSTimeInterval)seconds;
```

使用通知监听播放器的状态

```objective-c
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerStatusDidChange:) name:NSMVideoPlayerStatusDidChange object:nil];

- (void)videoPlayerStatusDidChange:(NSNotification *)notification {
    NSMVideoPlayerStatus oldStatus = [notification.userInfo[NSMVideoPlayerOldStatusKey] intValue];
    NSMVideoPlayerStatus newStatus = [notification.userInfo[NSMVideoPlayerNewStatusKey] intValue];

   // 在播放器状态发生的变化的时候，改变你的控制层的 UI 等一系列上层 UI 
   switch (newStatus) {
        case NSMVideoPlayerStatusFailed:
        break;

        case NSMVideoPlayerStatusPreparing:
        break;

        case NSMVideoPlayerStatusPlaying:            
        break;

        case NSMVideoPlayerStatusWaitBufferingToPlay:
        break;

        case NSMVideoPlayerStatusPaused:
        break;

        case NSMVideoPlayerStatusPlayToEndTime:
        break;

        default:
        break;
    }
}
```

使用 KVO 监听播放器的相关属性

```objective-c
// 视频的总长度
[self.playerController.videoPlayer.playbackProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(totalUnitCount)) options:0 context:nil];
// 播放进度
[self.playerController.videoPlayer.playbackProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount)) options:0 context:nil];
// 缓存进度
[self.playerController.videoPlayer.bufferProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount)) options:0 context:nil];
```

销毁播放器

```objective-c
self.saveConfig = [self.playerController.videoPlayer savePlayerState];
[self.playerViewController.playerController.videoPlayer releasePlayer];
```

恢复播放器

```objective-c
[self.playerController.videoPlayer restorePlayerWithRestoration:self.saveConfig];
```

根据播放器 Error 信息恢复播放器。当播放器的状态切换成 `NSMVideoPlayerStatusFailed` 的时候，就能够拿到播放器的 Error 信息，这样就能够根据 Error 中的信息恢复播放器。

```objective-c
// 默认情况下不允许使用3G/4G网络进行播放，所以播放器在3G/4G网络播放情况下会出现 Error，恢复播放器的时候可以根据 Error 信息中的 `NSMPlayerRestoration` object 恢复之前的播放状态，如播放进度，播放音量和播放源

NSMPlayerError *playerError = [self.playerViewController.playerController.videoPlayer playerError];
NSMPlayerRestoration *restoration = playerError.restoration;
[self.playerController.videoPlayer restorePlayerWithRestoration:restoration];
```

开启 3G/4G 播放开关

```objective-c
[self.playerController.videoPlayer setAllowWWAN:YES];
```

其他播放器功能

`NSMVideoPlayerProtocol` 中还定义了播放器控制的其他功能，例如：允许循环播放，支持自动播放等功能

### NSMUnderlyingPlayerProtocol

遵守 `NSMUnderlyingPlayerProtocol` 协议的对象就是播放器的内核。

可以基于当前的项目结构植入多个播放器内核，只需要提供一个实现 `NSMUnderlyingPlayerProtocol` 协议的播放器内核对象，就可以将其植入到当前项目中，这样就可以在不同的播放器内核之间完成切换。

NSMPlayer 中的 `NSMAVPlayer` 就是一个遵循 `NSMUnderlyingPlayerProtocol` 协议的基于 AVPlayer 为内核的底层播放器。

### NSMPlayerAccessoryViewProtocol
遵循 `NSMPlayerAccessoryViewProtocol` 协议的对象就是实际播放器需要用到的控制层对象。

播放器的控制层 UI 支持完全自定义的 UI，只需要遵守 `NSMPlayerAccessoryViewProtocol` 协议，就可以在播放器中使用此控制层。

## Common Problems

播放器的默认内核是基于 AVPlayer，所以支持的媒体格式也只局限于 AVPlayer 默认支持的几种格式。

## Licenses

NSPlayer 使用 MIT 许可证，详情见 LICENSE 文件。

## Architecture

![Architecture](https://raw.githubusercontent.com/xinpianchang/NSMPlayer-ObjC/master/NSMVideoPlayer.png)
