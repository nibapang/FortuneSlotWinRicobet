//
//  WinRicoPrivacyVC.swift
//  FortuneSlotWinRicobet
//
//  Created by SunTory on 2025/3/3.
//

import UIKit

@preconcurrency import WebKit
class WinRicoPrivacyVC: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var dynastyWebView: WKWebView!
    @IBOutlet weak var topCos: NSLayoutConstraint!
    @IBOutlet weak var bottomCos: NSLayoutConstraint!
    
    @IBOutlet weak var leftBtn: UIButton!
    var backAction: (() -> Void)?
    var privacyData: [Any]?
    @objc var url: String?
    let dynastyPrivacyUrl = "https://www.termsfeed.com/live/c527f802-99a6-40ce-97c1-bacbe6345510"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.privacyData = UserDefaults.standard.array(forKey: UIViewController.winRicoGetUserDefaultKey())
        winRicoInitSubViews()
        winRicoInitNavView()
        winRicoInitWebView()
        winRicoStartLoadWebView()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let confData = privacyData, confData.count > 4 {
            let top = (confData[3] as? Int) ?? 0
            let bottom = (confData[4] as? Int) ?? 0
            
            if top > 0 {
                topCos.constant = view.safeAreaInsets.top
            }
            if bottom > 0 {
                bottomCos.constant = view.safeAreaInsets.bottom
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    //MARK: - Functions
    @objc func backClick() {
        backAction?()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - INIT
    private func winRicoInitSubViews() {
        dynastyWebView.scrollView.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .black
        dynastyWebView.backgroundColor = .black
        dynastyWebView.isOpaque = false
        dynastyWebView.scrollView.backgroundColor = .black
        indicatorView.hidesWhenStopped = true
    }
    
    private func winRicoInitNavView() {
        guard let url = url, !url.isEmpty else {
            dynastyWebView.scrollView.contentInsetAdjustmentBehavior = .automatic
            return
        }
        
        self.leftBtn.isHidden = true;
        navigationController?.navigationBar.tintColor = .systemBlue
        
        let image = UIImage(systemName: "xmark")
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backClick))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func winRicoInitWebView() {
        guard let confData = privacyData, confData.count > 7 else { return }
        
        let userContentC = dynastyWebView.configuration.userContentController
        
        if let ty = confData[18] as? Int, ty == 1 || ty == 2 {
            if let trackStr = confData[5] as? String {
                let trackScript = WKUserScript(source: trackStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                userContentC.addUserScript(trackScript)
            }
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               let bundleId = Bundle.main.bundleIdentifier,
               let wgName = confData[7] as? String {
                let inPPStr = "window.\(wgName) = {name: '\(bundleId)', version: '\(version)'}"
                let inPPScript = WKUserScript(source: inPPStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                userContentC.addUserScript(inPPScript)
            }
            
            if let messageHandlerName = confData[6] as? String {
                userContentC.add(self, name: messageHandlerName)
            }
        }
        
        else if let ty = confData[18] as? Int, ty == 3 {
            if let trackStr = confData[29] as? String {
                let trackScript = WKUserScript(source: trackStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                userContentC.addUserScript(trackScript)
            }
            
            if let messageHandlerName = confData[6] as? String {
                userContentC.add(self, name: messageHandlerName)
            }
        }
        
        else {
            userContentC.add(self, name: confData[19] as? String ?? "")
        }
        
        dynastyWebView.navigationDelegate = self
        dynastyWebView.uiDelegate = self
    }
    
    
    private func winRicoStartLoadWebView() {
        let urlStr = url ?? dynastyPrivacyUrl
        guard let url = URL(string: urlStr) else { return }
        
        indicatorView.startAnimating()
        let request = URLRequest(url: url)
        dynastyWebView.load(request)
    }
    
    private func winRicoReloadWebViewData(_ adurl: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let storyboard = self.storyboard,
               let adView = storyboard.instantiateViewController(withIdentifier: "WinRicoPrivacyVC") as? WinRicoPrivacyVC {
                adView.url = adurl
                adView.backAction = { [weak self] in
                    let close = "window.closeGame();"
                    self?.dynastyWebView.evaluateJavaScript(close, completionHandler: nil)
                }
                let nav = UINavigationController(rootViewController: adView)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let confData = privacyData, confData.count > 9 else { return }
        
        let name = message.name
        if name == (confData[6] as? String),
           let trackMessage = message.body as? [String: Any] {
            let tName = trackMessage["name"] as? String ?? ""
            let tData = trackMessage["data"] as? String ?? ""
            
            if let ty = confData[18] as? Int, ty == 1 {
                if let data = tData.data(using: .utf8) {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if tName != (confData[8] as? String) {
                                winRicoSendEvent(tName, values: jsonObject)
                                return
                            }
                            if tName == (confData[9] as? String) {
                                return
                            }
                            if let adId = jsonObject["url"] as? String, !adId.isEmpty {
                                winRicoReloadWebViewData(adId)
                            }
                        }
                    } catch {
                        winRicoSendEvent(tName, values: [tName: data])
                    }
                } else {
                    winRicoSendEvent(tName, values: [tName: tData])
                }
            } else if let ty = confData[18] as? Int, ty == 2 {
                winRicoSendEvents(tName, paramsStr: tData)
            } else {
                if tName == confData[28] as? String {
                    if let url = URL(string: tData),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else {
                    winRicoSendEvent(withName: tName, value: tData)
                }
            }
            
        } else if name == (confData[19] as? String) {
            if let messageBody = message.body as? String,
               let dic = winRicoJsonToDic(withJsonString: messageBody) as? [String: Any],
               let evName = dic["funcName"] as? String,
               let evParams = dic["params"] as? String {
                
                if evName == (confData[20] as? String) {
                    if let uDic = winRicoJsonToDic(withJsonString: evParams) as? [String: Any],
                       let urlStr = uDic["url"] as? String,
                       let url = URL(string: urlStr),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else if evName == (confData[21] as? String) {
                    winRicoendEvents(withParams: evParams)
                }
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            UIApplication.shared.open(url)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        DispatchQueue.main.async {
            let authenticationMethod = challenge.protectionSpace.authenticationMethod
            if authenticationMethod == NSURLAuthenticationMethodServerTrust,
               let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            }
        }
        
    }

}
