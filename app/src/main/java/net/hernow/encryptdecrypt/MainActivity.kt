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
import androidx.appcompat.app.AppCompatActivity

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

        webView = findViewById(R.id.webView)

        webView.settings.apply {
            javaScriptEnabled = true
            allowFileAccess = true
            domStorageEnabled = true
            mixedContentMode = WebSettings.MIXED_CONTENT_NEVER_ALLOW
        }

        webView.addJavascriptInterface(AndroidClipboardBridge(), "AndroidClipboard")

        webView.webChromeClient = object : WebChromeClient() {
            override fun onPermissionRequest(request: PermissionRequest) {
                request.grant(request.resources)
            }
        }

        WebView.setWebContentsDebuggingEnabled(false)
        webView.loadUrl("file:///android_asset/EncryptDecryptToolWeb.html")
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        if (webView.canGoBack()) webView.goBack()
        else super.onBackPressed()
    }
}