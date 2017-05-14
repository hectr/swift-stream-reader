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

/// Read-only stream abstraction.
public protocol InputStreaming: class {
    /// Returns YES if the stream has bytes available or if it impossible to tell without actually doing the read.
    var hasBytesAvailable: Bool { get }
    
    /// Returns an NSError object representing the stream error.
    var streamError: Error? { get }
    
    /// Opens the receiving stream.
    func open()
    
    /// Closes the receiver.
    func close()
    
    /// Reads up to length bytes into the supplied buffer, which must be at least of size len. Returns the actual number of bytes read.
    func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int
}
