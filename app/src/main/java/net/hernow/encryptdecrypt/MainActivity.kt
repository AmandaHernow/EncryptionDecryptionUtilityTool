package net.hernow.encryptdecrypt

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.webkit.JavascriptInterface
import android.webkit.PermissionRequest
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity : AppCompatActivity() {

    private lateinit var webView: WebView

    inner class AndroidClipboardBridge {

        @JavascriptInterface
        fun getText(): String {
            val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            return clipboard.primaryClip?.getItemAt(0)?.text?.toString() ?: ""
        }

        @JavascriptInterface
        fun clear() {
            val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                clipboard.clearPrimaryClip()
            } else {
                // On older Android, overwrite with empty string
                clipboard.setPrimaryClip(ClipData.newPlainText("", ""))
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(android.R.id.content)) { view, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            view.setPadding(
                systemBars.left,
                systemBars.top,
                systemBars.right,
                systemBars.bottom
            )
            insets
        }

        webView = findViewById(R.id.webView)

        webView.settings.apply {
            javaScriptEnabled = true
            allowFileAccess = true
            domStorageEnabled = true
            mixedContentMode = WebSettings.MIXED_CONTENT_NEVER_ALLOW
        }

        webView.webViewClient = object : android.webkit.WebViewClient() {
            override fun shouldOverrideUrlLoading(
                view: android.webkit.WebView,
                request: android.webkit.WebResourceRequest
            ): Boolean {
                val url = request.url.toString()
                return if (url.startsWith("file://")) {
                    false // let the WebView handle local files normally
                } else {
                    val intent = android.content.Intent(
                        android.content.Intent.ACTION_VIEW,
                        android.net.Uri.parse(url)
                    )
                    startActivity(intent)
                    true
                }
            }
        }

        webView.addJavascriptInterface(AndroidClipboardBridge(), "AndroidClipboard")

        webView.webChromeClient = object : WebChromeClient() {
            override fun onPermissionRequest(request: PermissionRequest) {
                request.grant(request.resources)
            }
        }

        WebView.setWebContentsDebuggingEnabled(false)
        webView.loadUrl("file:///android_asset/EncryptDecryptToolWeb.html")

        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                if (webView.canGoBack()) {
                    webView.goBack()
                } else {
                    isEnabled = false
                    onBackPressedDispatcher.onBackPressed()
                }
            }
        })
    }
}