import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WKWebView 配置 - 关键：忽略 viewport 缩放限制以利用设备原生分辨率
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        // 忽略 viewport 缩放限制，让页面以设备原生像素渲染
        config.ignoresViewportScaleLimits = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isOpaque = false
        // 关键：使用设备原生缩放因子
        webView.scrollView.contentScaleFactor = UIScreen.main.scale
        webView.backgroundColor = UIColor(red: 0.918, green: 0.969, blue: 0.945, alpha: 1.0)
        
        // 注入 JS 设置设备像素比
        let deviceScaleJS = """
        (function() {
            var meta = document.querySelector('meta[name="viewport"]');
            if (!meta) {
                meta = document.createElement('meta');
                meta.name = 'viewport';
                document.head.appendChild(meta);
            }
            var scale = 1 / window.devicePixelRatio;
            meta.content = 'width=device-width,initial-scale=' + scale + ',maximum-scale=' + scale + ',user-scalable=no,viewport-fit=cover';
        })();
        """
        let userScript = WKUserScript(source: deviceScaleJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(userScript)
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // 加载本地 HTML
        if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    
    // 关键：禁止缩放（WebView 页面缩放导致模糊）
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 禁止用户缩放
        let noZoomJS = """
        var meta = document.querySelector('meta[name="viewport"]');
        if (meta) {
            meta.content = 'width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no,viewport-fit=cover';
        }
        """
        webView.evaluateJavaScript(noZoomJS, completionHandler: nil)
    }
    
    override var prefersStatusBarHidden: Bool { false }
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}
