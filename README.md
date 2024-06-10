# TaiperTravel

台北旅遊網
---

- 開發工具：`Xcode 15.4`
- 語言：`Swift`
- 開發架構：`MVVM`
- 最低支援版本：`iOS 14.0`
- Github：https://github.com/j11042004/TaiperTravel
- Youtube Demo 影片網址：https://www.youtube.com/watch?v=y824dkaQuyw
 
- Device Support：iPhone

**專案資料**

- Targets 
    - 正式版設定：`TaiperTravel`
- 加密方式：
     - AES256 ECB PKCS7
     
- 多國語系（是/否）：是
- 暗黑模式（是/否）：是
- 推播：無

- 資料儲存：
    - UserDefaults：儲存資料會以 AES 加密
    - Keychain

- 應用套件：
    - Combine：資料傳輸
    - Alamofire：協助 Api request
    - CryptoSwift：協助資料加解密
    
- Other
    - 資料夾分層：
        - Common 及 Constant：環境設定與重要資訊
        - Core：包含核心元件，例如 Api 串接、UserDefaults、Keychain 處理 
        - Data：所有的資料 Model，包含 Api Request/Response
        - View：共用或各 Page 的子畫面
        - Page：各個頁面、VC 及 ViewModel
    - App 入口：
        - 主要在 SceneDelegate 重新設定 RootViewController，但主要是用 Home.Storyboard 內的 VC
