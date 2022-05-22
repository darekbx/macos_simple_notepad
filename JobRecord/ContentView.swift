//
//  ContentView.swift
//  JobRecord
//
//  Created by Darek Barańczuk on 21/05/2022.
//
/*
 TODO:
 - line numbers (count likes) https://stackoverflow.com/questions/65375461/setting-the-cursor-position-within-a-swiftui-texteditor
 - register as a app which can open a text file
 - display size and lines count in status
 - parse date format ---- yyyy-mm-dd and show days mark on the right like android studio warnings
 */

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    private var lineNumbersWidth: CGFloat = 40
    
    @State private var text: String = ""
    @State private var fontSize = 12.0
    @State private var saved = true
    @State private var linesCount = 1
    @State private var filename: String? = nil
    @State private var fileHandle: URL? = nil
    
    var displayFont: Font {
        return Font.system(size: CGFloat(fontSize), design: .monospaced)
    }
    
    var statusFont: Font {
        return Font.system(size: CGFloat(10.0), design: .monospaced)
    }
    
    var body: some View {
        let filenameHeader = filename != nil ? "(\(filename!))" : ""
        VStack(alignment: .leading) {
            HStack(alignment: VerticalAlignment.top) {
                lineNumbers()
                    .frame(width: lineNumbersWidth, alignment: .trailing)
                textField()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text("\(linesCount) lines")
                .font(statusFont)
                .padding(.bottom, 8)
                .padding(.trailing, 14)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .navigationTitle("Job Record \(filenameHeader)")
    }
    
    func lineNumbers() -> some View {
        let linesCountText = (1...linesCount)
            .map{ String($0) }
            .joined(separator: "\n")
        return Text(linesCountText)
            .multilineTextAlignment(.trailing)
            .font(displayFont)
            .foregroundColor(Color.white.opacity(0.5))
    }
    
    func textField() -> some View {
        return TextEditor(text: $text)
            .font(displayFont)
            .onChange(of: text) { _ in
                linesCount = text
                    .split(separator: "\n", omittingEmptySubsequences: false)
                    .count
                self.saved = false
            }
            .toolbar {
                ItemsToolbar(
                    saved: self.saved,
                    save: { saveFile() },
                    open: { openFile() }
                )
            }
    }
    
    func openFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK {
            guard let file = panel.url?.path else {
                return
            }
            self.fileHandle = panel.url
            self.filename = self.fileHandle?.lastPathComponent
        
            do {
                let contents = try String(contentsOfFile: file, encoding: String.Encoding.utf8)
                self.text = contents
            } catch {
                print("Error during opening file")
            }
        }
    }
    
    func saveFile() {
        if self.fileHandle != nil {
            do {
                try self.text.write(toFile: self.fileHandle!.path, atomically: false, encoding: String.Encoding.utf8)
                self.saved = true
            } catch {
                print("Error during saving file")
                self.saved = false
            }
            return
        }
        
        let panel  = NSSavePanel()
        panel.allowedContentTypes = [UTType.plainText]
        panel.canCreateDirectories = true
        panel.allowsOtherFileTypes = false
        panel.isExtensionHidden = false
        
        if panel.runModal() == .OK {
            guard let file = panel.url?.path else {
                return
            }
            do {
                try self.text.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
                self.fileHandle = panel.url
                self.filename = self.fileHandle?.lastPathComponent
                self.saved = true
            } catch {
                print("Error during saving file")
                self.saved = false
            }
        } else {
            self.saved = false
        }
    }
}
