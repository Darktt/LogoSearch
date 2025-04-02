# LogoSearch

Redux 與 UIKit 連動的練習專案，使用 [Logo.dev](https://www.logo.dev) 作為資料來源。

## Redux 架構

### Store

Redux 的架構核心，處理 Action 傳遞給 Reducer 的資料流，並且持有 state。

### State

資料保存的地方，透過 Store 來管理，View 使用 combine 來訂閱 state 的變化，
它是一個統一的資料來源，讓所有 View 可以取得最新的資料。

### Action

用來描述發生了什麼事情，透過 Store.dispatch 來發送 Action，並且透過 Reducer 來更新 state。

### Middleware

處理 Action 的請求，如：api、log、錯誤處理等。

### Reducer

處理 Action 的結果，並且更新 state。

## Redux 資料流

```mermaid
flowchart TB
    A["Store.dispatch(action)"] -->|送 Action 到第一個 Middleware| Middleware

    subgraph Middleware

        direction TB
        C{是否該處理
         Action}

        C -->|是| D[處理 Action]
        D -->|建立結果的 Action| E
        
        C -->|否| E[下一個 Middleware]
    end
    
    E -->|無下個 Middleware| F[Reducer]
    F -->|更新 State 資訊| G[Store.State]

```

## 架構圖

```mermaid
flowchart TD
    %% App Lifecycle
    subgraph "App Lifecycle"
        A1("AppDelegate"):::lifecycle
        A2("SceneDelegate"):::lifecycle
    end

    %% Redux Core
    subgraph "Redux Core"
        R1("Store"):::redux
        R2("Actions"):::redux
        M1("API Middleware"):::redux
        M2("Error Middleware"):::redux
        M3("ImageLoader Middleware"):::redux
        R3("Reducer/State"):::redux
    end

    %% UI Layer
    subgraph "UI Layer"
        U1("MainViewController"):::ui
        U2("LogoDetailViewController"):::ui
        U3("SearchViewController"):::ui
    end

    %% Models
    subgraph "Models"
        MD("Models"):::model
    end

    %% Utilities
    subgraph "Utilities"
        UT1("SwiftExtensions"):::utility
        UT2("Protocols"):::utility
        UT3("Extensions"):::utility
    end

    %% Testing
    subgraph "Testing"
        T1("LogoSearchTests"):::testing
        T2("LogoSearchUITests"):::testing
    end

    %% Connections - App Lifecycle to Redux Core
    A1 -->|"initializes"| R1
    A2 -->|"initializes"| R1

    %% Connections - UI dispatches actions to Store
    U1 -->|"dispatch"| R1
    U2 -->|"dispatch"| R1
    U3 -->|"dispatch"| R1

    %% Connections - Redux Core internal flow
    R1 -->|"distributes"| R2
    R2 -->|"processing"| M1
    R2 -->|"processing"| M2
    R2 -->|"processing"| M3
    M1 -->|"updates"| R3
    M2 -->|"updates"| R3
    M3 -->|"updates"| R3

    %% Connections - State update back to UI
    R3 -->|"subscribe"| U1
    R3 -->|"subscribe"| U2
    R3 -->|"subscribe"| U3

    %% Connections - Middleware uses Models for API and image handling
    M1 -->|"API_call"| MD
    M3 -->|"load_image"| MD

    %% Connections - Utilities support UI and Redux
    UT2 -->|"provides_contract"| U1
    UT2 -->|"provides_contract"| U2
    UT2 -->|"provides_contract"| U3
    UT3 -->|"provides_helpers"| U1
    UT3 -->|"provides_helpers"| U2
    UT3 -->|"provides_helpers"| U3
    UT1 -->|"extends_functionality"| R1

    %% Connections - Testing suites verification
    T1 -->|"tests"| MD
    T2 -->|"tests_UI"| U1

    %% Styles
    classDef ui fill:#AED6F1,stroke:#1B4F72,stroke-width:2px;
    classDef redux fill:#F9E79F,stroke:#B9770E,stroke-width:2px;
    classDef model fill:#A9DFBF,stroke:#1D8348,stroke-width:2px;
    classDef utility fill:#E8DAEF,stroke:#8E44AD,stroke-width:2px;
    classDef lifecycle fill:#F5CBA7,stroke:#AF601A,stroke-width:2px;
    classDef testing fill:#D5DBDB,stroke:#707B7C,stroke-width:2px;

    %% Click Events
    click R1 "https://github.com/darktt/logosearch/blob/main/LogoSearch/Redux/Store.swift"
    click R2 "https://github.com/darktt/logosearch/blob/main/LogoSearch/ViewModel/LogoSearchAction.swift"
    click M1 "https://github.com/darktt/logosearch/blob/main/LogoSearch/ViewModel/ApiMiddware.swift"
    click M2 "https://github.com/darktt/logosearch/blob/main/LogoSearch/ViewModel/ErrorMiddware.swift"
    click M3 "https://github.com/darktt/logosearch/blob/main/LogoSearch/ViewModel/ImageLoaderMiddware.swift"
    click U1 "https://github.com/darktt/logosearch/blob/main/LogoSearch/Main/MainViewController.swift"
    click U2 "https://github.com/darktt/logosearch/blob/main/LogoSearch/LogoDetail/LogoDetailViewController.swift"
    click U3 "https://github.com/darktt/logosearch/blob/main/LogoSearch/SearchLogo/SearchViewController.swift"
    click A1 "https://github.com/darktt/logosearch/blob/main/LogoSearch/AppDelegate.swift"
    click A2 "https://github.com/darktt/logosearch/blob/main/LogoSearch/SceneDelegate.swift"
    click MD "https://github.com/darktt/logosearch/tree/main/LogoSearch/Models"
    click UT1 "https://github.com/darktt/logosearch/blob/main/Frameworks/SwiftExtensions.xcframework"
    click UT2 "https://github.com/darktt/logosearch/tree/main/LogoSearch/Protocols"
    click UT3 "https://github.com/darktt/logosearch/tree/main/LogoSearch/Extensions"
    click T1 "https://github.com/darktt/logosearch/tree/main/LogoSearchTests"
    click T2 "https://github.com/darktt/logosearch/tree/main/LogoSearchUITests"
```
