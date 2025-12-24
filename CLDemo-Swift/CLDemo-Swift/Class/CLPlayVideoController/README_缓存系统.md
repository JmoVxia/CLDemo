# 视频帧缓存系统使用说明

## 架构概览

本缓存系统参考 SDWebImage 架构设计，包含以下组件：

1. **CLVideoFrameCacheConfig** - 缓存配置类
2. **CLVideoFrameMemoryCache** - 内存缓存
3. **CLVideoFrameDiskCache** - 磁盘缓存
4. **CLVideoFrameCache** - 缓存管理器
5. **CLVideoOperation** - 集成缓存的视频操作
6. **CLVideoPlayer** - 播放器管理器

## 配置选项

### 缓存模式
```swift
CLVideoFrameCacheConfig.shared.cacheMode = .all  // 内存+磁盘
// .memoryOnly - 仅内存
// .diskOnly - 仅磁盘
// .all - 内存+磁盘
```

### 内存配置
```swift
CLVideoFrameCacheConfig.shared.memoryMaxCount = 50  // 最多50张
CLVideoFrameCacheConfig.shared.memoryMaxBytes = 50 * 1024 * 1024  // 最大50MB
```

### 磁盘配置
```swift
CLVideoFrameCacheConfig.shared.diskMaxBytes = 200 * 1024 * 1024  // 最大200MB
CLVideoFrameCacheConfig.shared.diskMaxAge = 7 * 24 * 60 * 60  // 7天
```

### 图片格式
```swift
CLVideoFrameCacheConfig.shared.diskImageFormat = .jpeg(quality: 0.8)
// 或
CLVideoFrameCacheConfig.shared.diskImageFormat = .png
```

### 预加载策略
```swift
CLVideoFrameCacheConfig.shared.preloadStrategy = .playWhileCaching  // 边缓存边播放
// 或
CLVideoFrameCacheConfig.shared.preloadStrategy = .cacheBeforePlay  // 先全部缓存再播放
```

### 日志开关
```swift
CLVideoFrameCacheConfig.shared.enableLog = true  // 启用日志
```

## 日志说明

### 日志级别和格式
所有日志都有统一前缀：`[视频帧缓存]` + emoji 标识

- ℹ️ info - 信息日志
- 📖 read - 读取操作
- ✍️ write - 写入操作
- 🗑️ delete - 删除操作
- 🧹 clean - 清理操作
- ✅ hit - 缓存命中
- ❌ miss - 缓存未命中

### 关键日志点

#### 1. 配置初始化
```
[视频帧缓存] ℹ️ 缓存配置初始化
[视频帧缓存] ℹ️   - 缓存模式: all
[视频帧缓存] ℹ️   - 内存最大数量: 50张
[视频帧缓存] ℹ️   - 内存最大大小: 50MB
[视频帧缓存] ℹ️   - 磁盘最大大小: 200MB
[视频帧缓存] ℹ️   - 磁盘最长时间: 7天
[视频帧缓存] ℹ️   - 预加载策略: playWhileCaching
```

#### 2. 内存缓存操作
```
[视频帧缓存] ✍️ 内存缓存写入: abc123_frame_0, 大小: 256KB
[视频帧缓存] ✅ 内存缓存命中: abc123_frame_0
[视频帧缓存] ❌ 内存缓存未命中: abc123_frame_0
[视频帧缓存] 🗑️ 内存缓存删除: abc123_frame_0
[视频帧缓存] 🧹 内存缓存已清空
```

#### 3. 磁盘缓存操作
```
[视频帧缓存] ✍️ 磁盘缓存写入成功: abc123_frame_0, 大小: 128KB
[视频帧缓存] ✅ 磁盘缓存命中: abc123_frame_0
[视频帧缓存] ❌ 磁盘缓存未命中: abc123_frame_0
[视频帧缓存] 🗑️ 磁盘缓存删除: abc123_frame_0
[视频帧缓存] 🧹 清理过期缓存: 删除 10 个文件
[视频帧缓存] 🧹 清理超限缓存: 删除 5 个文件, 释放 10MB
```

#### 4. 缓存查询链路
```
[视频帧缓存] 📖 查询缓存: abc123_frame_0
[视频帧缓存] ❌ 内存缓存未命中: abc123_frame_0
[视频帧缓存] ✅ 磁盘缓存命中: abc123_frame_0
[视频帧缓存] ✍️ 内存缓存写入: abc123_frame_0, 大小: 256KB
```

#### 5. 视频播放
```
[视频帧缓存] ℹ️ 视频播放开始: /path/to/video.mp4, 策略: playWhileCaching
[视频帧缓存] ℹ️ 开始预缓存所有帧: /path/to/video.mp4
[视频帧缓存] ℹ️ 预缓存进度: 10 帧
[视频帧缓存] ℹ️ 预缓存完成: 共 120 帧
```

#### 6. 播放器操作
```
[视频帧缓存] ℹ️ 播放器启动视频: /path/to/video.mp4
[视频帧缓存] ℹ️ 播放器取消视频: /path/to/video.mp4
[视频帧缓存] ℹ️ 播放器取消所有视频
[视频帧缓存] ℹ️ 播放器销毁
```

#### 7. 统计信息
```
[视频帧缓存] ℹ️ 内存缓存统计 - 命中:80 未命中:20 命中率:80.00%
[视频帧缓存] ℹ️ 磁盘缓存大小: 150MB
```

## 测试场景

### 场景 1：首次播放（无缓存）
**预期日志：**
1. 配置初始化
2. 缓存管理器初始化
3. 内存缓存初始化
4. 磁盘缓存初始化
5. 播放器启动视频
6. 视频播放开始（边缓存边播放）
7. 每帧查询缓存 → 未命中 → 解码 → 写入缓存
8. 内存缓存写入日志（每帧）
9. 磁盘缓存写入日志（异步）

**性能特征：**
- CPU 使用率高（解码）
- 内存逐渐增长（写入缓存）
- 磁盘 I/O 活跃（异步写入）

### 场景 2：第二次播放（有缓存）
**预期日志：**
1. 播放器启动视频
2. 视频播放开始
3. 每帧查询缓存 → 内存命中 → 直接显示

**性能特征：**
- CPU 使用率低（无解码）
- 内存稳定（直接读取）
- 磁盘 I/O 少（仅读取未命中帧）

### 场景 3：先缓存再播放策略
**预期日志：**
1. 播放器启动视频
2. 开始预缓存所有帧
3. 预缓存进度日志（每 10 帧）
4. 预缓存完成
5. 播放循环开始
6. 每帧查询缓存 → 命中 → 直接显示

**性能特征：**
- 首次有明显延迟（预缓存）
- 播放流畅（无解码）

## API 使用

### 获取缓存大小
```swift
CLVideoPlayer.getCacheSize { memorySize, diskSize in
    print("内存缓存: \(memorySize / 1024 / 1024)MB")
    print("磁盘缓存: \(diskSize / 1024 / 1024)MB")
}
```

### 获取统计信息
```swift
CLVideoPlayer.getCacheStatistics()
// 会在日志中打印统计信息
```

### 清空缓存
```swift
CLVideoPlayer.clearCache {
    print("缓存已清空")
}
```

## 性能优化建议

1. **内存模式** - 适合短视频、少量视频场景
   - 优点：速度最快
   - 缺点：内存占用高，应用退出即丢失

2. **磁盘模式** - 适合长视频、大量视频场景
   - 优点：持久化，节省内存
   - 缺点：首次读取稍慢

3. **混合模式（推荐）** - 适合大多数场景
   - 优点：兼顾速度和内存
   - 缺点：实现复杂度高

4. **JPEG vs PNG**
   - JPEG: 文件小，有损，适合大多数场景（推荐 0.8 质量）
   - PNG: 文件大，无损，适合需要高质量的场景

5. **预加载策略**
   - 边缓存边播放：立即可见，适合用户体验优先
   - 先缓存再播放：流畅度优先，适合网络视频

## 注意事项

1. 缓存路径：`Library/Caches/CLVideoFrameCache`
2. 缓存键格式：`{视频路径MD5}_frame_{帧索引}`
3. 磁盘缓存异步操作，不阻塞主线程
4. 自动清理过期缓存（启动时）
5. 自动限制缓存大小（LRU 策略）
6. 线程安全（使用锁保护）

## 调试技巧

1. 启用日志查看缓存行为
2. 观察内存使用情况（Xcode Instruments）
3. 监控磁盘 I/O（Xcode Instruments）
4. 定期打印统计信息
5. 清空缓存后对比性能差异

