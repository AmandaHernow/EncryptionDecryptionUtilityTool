<p align="center">
  <img src="docs/banner.svg" alt="Encrypt & Decrypt Data Utility Tool" width="100%"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=flat-square&logo=android&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-Web-008B8B?style=flat-square&logo=html5&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-iOS-000000?style=flat-square&logo=apple&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-Desktop-555555?style=flat-square&logo=windows&logoColor=white"/>
  <img src="https://img.shields.io/badge/Encryption-AES--256--GCM-blue?style=flat-square"/>
  <img src="https://img.shields.io/badge/KDF-PBKDF2--SHA256-blue?style=flat-square"/>
  <img src="https://img.shields.io/badge/License-GPL%20v3-green?style=flat-square"/>
  <img src="https://img.shields.io/badge/Offline-Zero--trace-008B8B?style=flat-square"/>
</p>

---

## 🌐 Try the Web Version

**No install required — open it directly in your browser:**

> ### [Encrypt &amp; Decrypt Data Utility Tool Web Version](https://amandahernow.github.io/EncryptionDecryptionUtilityTool/)

Download the html file from the latest web release to keep on your computer and run the program offline locally.

Works on any device with a modern browser. Everything runs locally — nothing is sent anywhere.

---

## About

**Encrypt & Decrypt Data Utility Tool** is a password-based text encryption and decryption utility built for privacy and simplicity. It lets you lock any message behind a password so that only someone with the correct password can read it. All cryptographic operations happen locally on your device — nothing is transmitted, logged, or stored.

The tool uses **AES-256-GCM** encryption combined with **PBKDF2-SHA256** key derivation (100,000 iterations), giving you strong, industry-standard security without needing a technical background to use it.

It was originally built as an internal utility tool and has since been rewritten as a standalone, open-source application available across multiple platforms.

---

## Platforms

| Platform | Status | Notes |
|---|---|---|
| **Android** | ✅ Released | Available on Google Play - [Open in PlayStore](https://play.google.com/store/apps/details?id=net.hernow.encryptdecrypt)|
| **Web** | ✅ Released | [Open in browser](https://amandahernow.github.io/EncryptionDecryptionUtilityTool/) — single HTML file, no server required |
| **iOS** | 🔧 Work in progress | SwiftUI — not yet released |
| **Desktop** | 📋 Planned | Native desktop application — coming in a future release |

---

## Language Support

Language support is being tracked across all platform versions. At the moment, only the **web version** has multilingual support implemented.

| Language | Web | Android | iOS | Desktop |
|---|---|---|---|---|
| English | ✅ | ✅ | 📋 Planned | 📋 Planned |
| German / Deutsch | ✅ | ✅ | 📋 Planned | 📋 Planned |
| Simplified Chinese / 中文（简体） | ✅ | 📋 Planned | 📋 Planned | 📋 Planned |
| Traditional Chinese / 中文（繁體） | ✅ | 📋 Planned | 📋 Planned | 📋 Planned |
| Japanese / 日本語 | ✅ | 📋 Planned | 📋 Planned | 📋 Planned |
| Korean / 한국어 | ✅ | 📋 Planned | 📋 Planned | 📋 Planned |
| French / Français | ✅ | 📋 Planned | 📋 Planned | 📋 Planned |
| Spanish / Español | ✅ | 📋 Planned | 📋 Planned | 📋 Planned |
| Italian / Italiano | 📋 Planned | 📋 Planned | 📋 Planned | 📋 Planned |
| Portuguese / Português | 📋 Planned | 📋 Planned | 📋 Planned | 📋 Planned |
| Arabic / العربية | 📋 Planned | 📋 Planned | 📋 Planned | 📋 Planned |
| Farsi / فارسی | 📋 Planned | 📋 Planned | 📋 Planned | 📋 Planned |

Currently implemented on the web version:
- `index.html`
- `privacy-policy.html`

---

## Independent Decryption

Your data is yours. Because this tool uses industry-standard algorithms, you can decrypt your messages using standard command-line tools without needing this software.

> ### [Independent Decryption Guide](https://amandahernow.github.io/EncryptionDecryptionUtilityTool/decryption-guide.html)

---

## How It Works

### Encrypt
1. Open the app and tap **Encrypt**.
2. Enter the text you want to protect.
3. Enter a password.
4. The app produces an encrypted Base64 string. Copy it and send or store it however you like.

### Decrypt
1. Open the app and tap **Decrypt**.
2. Paste the encrypted Base64 string.
3. Enter the password that was used to encrypt it.
4. The original text is revealed if the password is correct.

> **Important:** If you forget your password, there is no way to recover the message. No one can reset or retrieve it.

---

## Security

| Property | Detail |
|---|---|
| **Encryption algorithm** | AES-256-GCM — authenticated encryption that protects confidentiality and detects tampering |
| **Key derivation** | PBKDF2-SHA256, 100,000 iterations — strengthens passwords against brute-force attacks |
| **Salt** | 16 bytes, randomly generated per encryption |
| **IV / Nonce** | 12 bytes, randomly generated per encryption |
| **Output format** | Base64-encoded blob: `[16-byte salt] + [12-byte IV] + [ciphertext + GCM tag]` |
| **Network access** | None — all operations are local and offline |
| **Storage** | No passwords, plaintext, or ciphertext are stored anywhere on the device |
| **Clipboard** | Clipboard writes are user-initiated only |

Random salt and IV per operation means the same input text with the same password will produce a different encrypted output every time, preventing pattern analysis.

---

## Project Structure

```
EncryptionDecryptionUtilityTool/
├── app/                    # Android app module
├── gradle/                 # Gradle version catalog and wrapper files
├── IOS/                    # iOS project notes and files
├── docs/                   # Images and assets used by the web page and README
├── index.html              # Main web app
├── privacy-policy.html     # Web privacy policy
├── sitemap.html            # HTML sitemap
├── sitemap.xml             # XML sitemap
├── site.webmanifest        # Web app manifest
├── build.gradle.kts        # Android project build config
├── settings.gradle.kts     # Android project settings
├── gradle.properties       # Android/Gradle properties
├── gradlew                 # Gradle wrapper (Unix)
├── gradlew.bat             # Gradle wrapper (Windows)
├── LICENSE                 # GNU General Public License v3
└── README.md
```

---

## Support the Developer

If you find this tool useful, consider supporting its development. It helps keep the project maintained and free.

<p align="center">
  <a href="https://www.paypal.me/AmandaHernow">
    <img src="docs/paypal_qr.png" alt="Donate via PayPal" width="180"/>
  </a>
  <br/><br/>
  <a href="https://www.paypal.me/AmandaHernow">💙 Donate via PayPal</a>
</p>

You can also reach out or report issues at: **encrypt.decrypt.support@hernow.net**

---

## License

This project is licensed under the **GNU General Public License v3.0**.
You are free to use, modify, and distribute this software under the terms of that licence.
See the [LICENSE](LICENSE) file for the full text, or visit [gnu.org/licenses/gpl-3.0](https://www.gnu.org/licenses/gpl-3.0).

---

## Developer

**Amanda Hernow**
✉️ encrypt.decrypt.support@hernow.net

---

<p align="center">
  <sub>© Amanda Hernow — All rights reserved where applicable. Licensed under GPL v3.</sub>
</p>
