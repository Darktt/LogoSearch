# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

This is a native Xcode project (no CocoaPods or Swift Package Manager).

```bash
# Build for simulator
xcodebuild -project LogoSearch.xcodeproj -scheme LogoSearch -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run unit tests
xcodebuild -project LogoSearch.xcodeproj -scheme LogoSearch -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test class
xcodebuild -project LogoSearch.xcodeproj -scheme LogoSearch -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:LogoSearchTests/LogoSearchTests test
```

## Architecture

Redux + UIKit 練習專案，使用 [Logo.dev](https://www.logo.dev) API 搜尋品牌 Logo。UI 使用 UIKit + XIB（非 SwiftUI），狀態管理使用自製 Redux 實作。

### 層次結構

```
Redux/
  Store.swift              — 泛型 Redux Store 核心 Store<State, Action>

ViewModel/
  LogoSearchState.swift    — 應用全域狀態（搜尋結果、快取圖片、錯誤）
  LogoSearchAction.swift   — 所有 Action 枚舉
  LogoSearchStore.swift    — 全域單例 kLogoSearchStore，組合 Reducer 與 Middleware 鏈
  ApiMiddware.swift        — 攔截搜尋 Action，呼叫 APIHandler，回傳 searchResult
  ImageLoaderMiddware.swift — 攔截圖片請求 Action，呼叫 ImageLoader，回傳圖片
  ErrorMiddware.swift      — 攔截 API 錯誤，標準化為 LogoSearchError

Models/
  APIHandler.swift         — 網路層單例（@MainActor），使用 URLSession ephemeral
  APIRequest.swift         — 泛型 API 請求協議（關聯類型 Response: JsonDecodable）
  APIName.swift            — API 端點定義（https://api.logo.dev/...）
  Config.swift             — 金鑰設定，使用 InMemoryProvider
  APIKeys.swift            — Config 的靜態代理，供其他層存取金鑰
  ImageLoader.swift        — 圖片加載，URLCache 20MB 記憶體快取
  Coordinator.swift        — 導航協調器（頁面跳轉邏輯）

Main/ SearchLogo/ LogoDetail/
  *ViewController.swift + .xib  — UIViewController 畫面
```

### Redux 資料流

```
View.dispatch(action)
  → Middleware chain: ApiMiddleware → ImageLoaderMiddleware → ErrorMiddleware
  → Reducer → @Published state
  → Combine 訂閱 → UI 更新
```

Middleware 只處理自己負責的 Action，其餘一律呼叫 `next(action)` 傳遞。

### 新增 API 請求

1. 建立遵循 `APIRequest` 協議的 struct（`Models/`），指定 `Response` 關聯類型
2. 在 `APIName.swift` 加入對應端點
3. 在 `LogoSearchAction.swift` 新增觸發 Action 與結果 Action
4. 在對應 Middleware 攔截並呼叫 `APIHandler.shared.sendRequest()`

## Dependencies

- **SwiftExtensions.xcframework** — 本地自製 Framework（`Frameworks/`），提供 UIKit 輔助擴充功能
- **Configuration** — 設定讀取框架，透過 Xcode 原生依賴管理引入

## API 金鑰管理

金鑰儲存於 `Config.swift` 的 `InMemoryProvider`，由 `APIKeys.swift` 靜態代理存取。若需更換金鑰，直接修改 `Config.init()` 中的 `InMemoryProvider` 值。
