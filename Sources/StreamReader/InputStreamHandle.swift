// Copyright (c) 2017 Hèctor Marquès Ranea
//
// This software contains code derived from:
// http://stackoverflow.com/a/24648951/870560
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

open class InputStreamHandle: NSObject {
    open private(set) var error: Error?
    
    let bufferLength: Int
    
    var inputStream: InputStreaming?
    var fileOffset: Int = 0
    
    private(set) var bytesRead: Int = 0
    private(set) var data: NSMutableData = NSMutableData()
    
    deinit {
        closeStream()
    }
    
    public init(inputStream: InputStreaming, bufferLength: Int = 1024) {
        self.bufferLength = bufferLength
        self.inputStream = inputStream
        super.init()
        if let inputStream = inputStream as? InputStream {
            assert(inputStream.delegate == nil, "input stream delegate is already set")
            inputStream.delegate = self
            inputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        }
        inputStream.open()
    }
    
    func readBytes() {
        var buffer = [UInt8](repeating: 0, count: bufferLength)
        let length = inputStream!.read(&buffer, maxLength: bufferLength)
        guard length >= 0 else {
            onErrorOccurred()
            return
        }
        guard length > 0 else {
            return
        }
        data.append(&buffer, length: bufferLength)
        bytesRead = bytesRead + length
    }
    
    func onErrorOccurred() {
        if let error = inputStream!.streamError {
            self.error = error
        } else {
            self.error = NSError(domain: #file, code: #line, userInfo: nil)
        }
        closeStream()
    }
    
    func closeStream() {
        guard let inputStream = inputStream else { return }
        if let inputStream = inputStream as? InputStream {
            inputStream.delegate = nil
            inputStream.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        }
        inputStream.close()
        self.inputStream = nil
    }
}
