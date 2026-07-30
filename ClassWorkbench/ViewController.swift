import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 强制全面屏渲染，消除黑边
        view.backgroundColor = UIColor(red: 0.918, green: 0.969, blue: 0.945, alpha: 1.0)
        
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        // 忽略 viewport 缩放限制，使用设备原生分辨率
        config.ignoresViewportScaleLimits = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.918, green: 0.969, blue: 0.945, alpha: 1.0)
        webView.scrollView.contentScaleFactor = UIScreen.main.scale
        
        view.addSubview(webView)
        
        // 使用 safeAreaLayoutGuide 确保填满全面屏
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 注入安全区域 CSS 变量
        let safeAreaJS = """
        (function() {
            var style = document.createElement('style');
            style.textContent = ':root{--safe-top:' + window.screen.height * 0 + 'px;--safe-bottom:0px}';
            document.head.appendChild(style);
        })();
        """
        webView.evaluateJavaScript(safeAreaJS, completionHandler: nil)
        
        // 确保 viewport 正确
        let viewportJS = """
        var meta = document.querySelector('meta[name="viewport"]');
        if (meta) {
            meta.content = 'width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no,viewport-fit=cover';
        }
        """
        webView.evaluateJavaScript(viewportJS, completionHandler: nil)
    }
    
    // 隐藏状态栏以消除顶部黑边
    override var prefersStatusBarHidden: Bool { false }
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .fade }
}
