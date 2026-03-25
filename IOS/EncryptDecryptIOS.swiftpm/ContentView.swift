import SwiftUI
import CryptoKit
import CommonCrypto

extension Color {
    static let darkCyan = Color(red: 0, green: 139/255, blue: 139/255)
}

@available(iOS 16.0, *)
@available(iOS 16.0, *)
struct ContentView: View {
    @State private var inputText = ""
    @State private var password = ""
    @State private var outputText = ""
    @State private var showCopyAlert = false
    
    enum Mode { case encrypt, decrypt }
    
    @State private var mode: Mode = .encrypt
    @FocusState private var focusedField: Field?
    enum Field { case input, password }
    @available(iOS 16.0, *)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Encryption & Decryption IOS Utility Tool")
                .font(.custom("Segoe UI", size: 24))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.darkCyan)
            
            Text("AES-256/PBKDF2 Encryption & Decryption Utility")
                .font(.custom("Segoe UI", size: 14))
                .foregroundColor(.darkCyan)
            
            Text("Password-protect your text for secure encryption and decryption when sharing confidential data")
                .font(.custom("Segoe UI", size: 12))
                .foregroundColor(.darkCyan)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button("Encrypt") { startEncrypt() }
                Button("Decrypt") { startDecrypt() }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.darkCyan)
            .font(.custom("Segoe UI", size: 16).weight(.bold))
            
            ZStack(alignment: .topLeading) {
                // 1) The editor itself
                TextEditor(text: $inputText)
                    .font(.custom("Segoe UI", size: 14))
                    .padding(8)                                    // inset content
                    .focused($focusedField, equals: .input)
                    .scrollContentBackground(.hidden)              // iOS 16+ hides its default bg
                    .background(Color(UIColor.systemBackground))   // match your form’s fill
                    .cornerRadius(5)
                
                // 2) Placeholder on top, non-blocking taps
                if inputText.isEmpty {
                    Text("Enter text to encrypt or decrypt here…")
                        .foregroundColor(.gray)
                        .font(.custom("Segoe UI", size: 14))
                        .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray)
            )
            
            SecureField("Password", text: $password)
                .font(.custom("Segoe UI", size: 14))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = nil
                }
            
            HStack(spacing: 16) {
                Spacer()
                Button("Submit") { submit() }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(Color.darkCyan)
            .font(.custom("Segoe UI", size: 16).weight(.bold))
            
            ScrollView {
                Text(outputText)
                    .font(.custom("Segoe UI", size: 14))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .textSelection(.enabled)      // ← allows the user to tap-and-drag to select & copy
            }
            .border(Color.gray)
            
            Spacer()
            
            Text("© Amanda Hernow. All rights reserved (2025)    ")
                .font(.custom("Segoe UI", size: 12))
                .foregroundColor(.darkCyan)
                .padding(.bottom, 8)
        }
        .padding()
        .alert(isPresented: $showCopyAlert) {
            Alert(
                title: Text("Copy to Clipboard"),
                message: Text("Copy encrypted text to clipboard?"),
                primaryButton: .default(Text("Allow")) {
                    UIPasteboard.general.string = outputText
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func startEncrypt() {
        outputText = ""
        inputText = ""
        mode = .encrypt
    }
    
    private func startDecrypt() {
        outputText = ""
        inputText = ""
        mode = .decrypt
    }
    
    private func submit() {
        guard !password.isEmpty else { return }
        switch mode {
        case .encrypt: encrypt()
        case .decrypt: decrypt()
        }
        password = ""    // ← this clears the SecureField
    }
    
    private func encrypt() {
        let salt = randomData(length: 16)
        let keyData = pbkdf2(password: password, salt: salt)
        let key = SymmetricKey(data: keyData)
        let iv = randomData(length: 12)
        do {
            let sealed = try AES.GCM.seal(Data(inputText.utf8),
                                          using: key,
                                          nonce: AES.GCM.Nonce(data: iv))
            let combined = salt + iv + sealed.ciphertext + sealed.tag
            outputText = combined.base64EncodedString()
            showCopyAlert = true
        } catch {
            outputText = "Encryption error: \(error.localizedDescription)"
        }
    }
    
    private func decrypt() {
        guard let allData = Data(base64Encoded: inputText) else {
            outputText = "Invalid Base64"
            return
        }
        let salt = allData[0..<16]
        let iv   = allData[16..<28]
        let cipherAndTag = allData[28...]
        let keyData = pbkdf2(password: password, salt: salt)
        let key = SymmetricKey(data: keyData)
        do {
            let sealedBox = try AES.GCM.SealedBox(nonce: AES.GCM.Nonce(data: iv),
                                                  ciphertext: cipherAndTag.dropLast(16),
                                                  tag: cipherAndTag.suffix(16))
            let decrypted = try AES.GCM.open(sealedBox, using: key)
            outputText = String(decoding: decrypted, as: UTF8.self)
        } catch {
            outputText = "Decryption error: \(error.localizedDescription)"
        }
    }
    
    private func randomData(length: Int) -> Data {
        var d = Data(count: length)
        _ = d.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, length, $0.baseAddress!)
        }
        return d
    }
    private func pbkdf2(password: String, salt: Data) -> Data {
        // 1) Snapshot lengths
        let passwordLen = password.utf8.count
        let saltLen     = salt.count
        let keyLength   = 32
        
        // 2) Extract salt pointer in its own closure
        var saltPtr: UnsafePointer<UInt8>!
        salt.withUnsafeBytes { raw in
            saltPtr = raw.bindMemory(to: UInt8.self).baseAddress!
        }
        
        // 3) Allocate key buffer
        var keyData = Data(count: keyLength)
        
        // 4) Run PBKDF2 over that buffer without referencing keyData.count inside the closure
        keyData.withUnsafeMutableBytes { rawKey in
            let keyPtr = rawKey.bindMemory(to: UInt8.self).baseAddress!
            let status = CCKeyDerivationPBKDF(
                CCPBKDFAlgorithm(kCCPBKDF2),
                password, passwordLen,
                saltPtr,     saltLen,
                CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                100_000,
                keyPtr,      keyLength
            )
            precondition(status == kCCSuccess, "PBKDF2 failed")
        }
        return keyData
    }
}
