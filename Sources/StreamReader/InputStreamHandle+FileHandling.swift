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

extension InputStreamHandle: FileHandling {
    private func readMissingBytes(to newOffset: Int) {
        guard let inputStream = inputStream else { return }
        while bytesRead < newOffset && inputStream.hasBytesAvailable {
            readBytes()
        }
    }
    
    private func readableBytes(for newOffset: Int) -> Int {
        let unreadBytes = newOffset - fileOffset
        if bytesRead > newOffset {
            return unreadBytes
        } else {
            let unreadableBytes = newOffset - bytesRead
            return unreadBytes - unreadableBytes
        }
    }
    
    open func readData(ofLength length: Int) -> Data {
        let newOffset = fileOffset + length
        readMissingBytes(to: newOffset)
        let readableLength = readableBytes(for: newOffset)
        let range = NSRange(location: Int(fileOffset), length: readableLength)
        var buffer = [UInt8](repeating: 0, count: readableLength)
        data.getBytes(&buffer, range: range)
        fileOffset = fileOffset + readableLength
        return Data(bytes: buffer)
    }
    
    open func seek(toFileOffset offset: UInt64) {
        fileOffset = Int(offset)
    }
    
    open func closeFile() {
        closeStream()
    }
}
