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
import XCTest
@testable import StreamReader

class StreamReaderTests: XCTestCase {
    var sut: StreamReader!
    var fileHandle: MockFileHandling!
    var encoding: String.Encoding!
    var delimiterData: Data!
    var chunkSize: Int!
    
    private func givenFileHandleHasNextLine(count: Int) {
        fileHandle.nextLine = String(repeating: "lorem ipsum", count: count)
    }
    
    private func givenStreamReaderHasReadNextLine() {
        givenFileHandleHasNextLine(count: chunkSize)
        _ = sut.nextLine()
    }
    
    private func givenStreamReaderHasRewinded() {
        givenStreamReaderHasReadNextLine()
        sut.rewind()
    }
    
    private func givenStreamReaderIsClosed() {
        sut.close()
    }
    
    private func givenStramReaderIsDeallocated() {
        sut = nil
    }
    
    override func setUp() {
        fileHandle = MockFileHandling()
        encoding = .utf8
        delimiterData = "\n".data(using: encoding)! as Data
        chunkSize = 4096
        sut = StreamReader(
            fileHandle: fileHandle,
            delimiterData: delimiterData,
            encoding: encoding,
            chunkSize: 4096
        )
    }
    
    func testInitSetsFileHandle() {
        XCTAssertTrue(sut.fileHandle as! MockFileHandling === fileHandle)
    }
    
    func testInitSetsEncoding() {
        XCTAssertEqual(sut.encoding, encoding)
    }
    
    func testInitSetsDelimiterData() {
        XCTAssertEqual(sut.delimiterData, delimiterData)
    }
    
    func testInitSetsChunkSize() {
        XCTAssertEqual(sut.chunkSize, chunkSize)
    }
    
    func testCloseClosesFileHandle() {
        givenStreamReaderIsClosed()
        XCTAssertTrue(fileHandle.closed)
    }
    
    func testCloseNilsFileHandle() {
        givenStreamReaderIsClosed()
        XCTAssertNil(sut.fileHandle)
    }
    
    func testIsClosedCanBeFalse() {
        XCTAssertFalse(sut.isClosed)
    }
    
    func testCloseUpdatesIsClosed() {
        givenStreamReaderIsClosed()
        XCTAssertTrue(sut.isClosed)
    }
    
    func testFileHandleIsClosedOnDeinit() {
        givenStramReaderIsDeallocated()
        XCTAssertTrue(fileHandle.closed)
    }
    
    func testNextLineReturnsLineWhenShorterThanChunkSize() {
        givenFileHandleHasNextLine(count: 1)
        XCTAssertEqual(sut.nextLine(), fileHandle.nextLine)
    }
    
    func testNextLineReturnsLineWhenLongerThanChunkSize() {
        givenFileHandleHasNextLine(count: chunkSize)
        XCTAssertEqual(sut.nextLine(), fileHandle.nextLine)
    }

    func testBufferEmptyAfterInit() {
        XCTAssertTrue(sut.buffer.isEmpty)
    }
    
    func testBufferEmptyAfterRewind() {
        givenStreamReaderHasRewinded()
        XCTAssertTrue(sut.buffer.isEmpty)
    }

    func testBufferEmptyAfterNewLine() {
        givenStreamReaderHasReadNextLine()
        XCTAssertTrue(sut.buffer.isEmpty)
    }
    
    func testNotAtEofAfterInit() {
        XCTAssertFalse(sut.atEof)
    }
    
    func testNotAtEofAfterRewind() {
        XCTAssertFalse(sut.atEof)
    }
    
    static var allTests = [
        ("testInitSetsFileHandle", testInitSetsFileHandle),
        ("testInitSetsEncoding", testInitSetsEncoding),
        ("testInitSetsDelimiterData", testInitSetsDelimiterData),
        ("testInitSetsChunkSize", testInitSetsChunkSize),
        ("testCloseClosesFileHandle", testCloseClosesFileHandle),
        ("testCloseNilsFileHandle", testCloseNilsFileHandle),
        ("testIsClosedCanBeFalse", testIsClosedCanBeFalse),
        ("testCloseUpdatesIsClosed", testCloseUpdatesIsClosed),
        ("testFileHandleIsClosedOnDeinit", testFileHandleIsClosedOnDeinit),
        ("testNextLineReturnsLineWhenShorterThanChunkSize", testNextLineReturnsLineWhenShorterThanChunkSize),
        ("testNextLineReturnsLineWhenLongerThanChunkSize", testNextLineReturnsLineWhenLongerThanChunkSize),
        ("testBufferEmptyAfterInit", testBufferEmptyAfterInit),
        ("testBufferEmptyAfterRewind", testBufferEmptyAfterRewind),
        ("testBufferEmptyAfterNewLine", testBufferEmptyAfterNewLine),
        ("testNotAtEofAfterInit", testNotAtEofAfterInit),
        ("testNotAtEofAfterRewind", testNotAtEofAfterRewind)
    ]
}
