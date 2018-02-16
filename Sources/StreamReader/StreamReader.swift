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

/// It reads from a file in chunks and converts complete lines to strings.
open class StreamReader  {
    let encoding: String.Encoding
    let chunkSize: Int
    let delimiterData: Data
    private(set) var fileHandle: FileHandling?
    private(set) var buffer: Data
    private(set) var atEof: Bool
    
    open var isClosed: Bool {
        return fileHandle == nil
    }
    
    public convenience init?(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        guard let fileHandle = FileHandle(forReadingAtPath: path) else { return nil }
        guard let delimiterData = delimiter.data(using: encoding) else { return nil }
        self.init(
            fileHandle: fileHandle,
            delimiterData: delimiterData,
            encoding: encoding,
            chunkSize: chunkSize
        )
    }
    
    public init(fileHandle: FileHandling, delimiterData: Data, encoding: String.Encoding, chunkSize: Int) {
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimiterData = delimiterData
        self.buffer = Data(capacity: chunkSize)
        self.atEof = false
    }
    
    deinit {
        close()
    }
    
    /// Returns next line, or nil on EOF.
    open func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")
        
        // Reads data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimiterData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle!.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    /// Starts reading from the beginning of file.
    open func rewind() -> Void {
        fileHandle!.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }
    
    /// Closes the underlying file. No reading must be done after calling this method.
    open func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}
