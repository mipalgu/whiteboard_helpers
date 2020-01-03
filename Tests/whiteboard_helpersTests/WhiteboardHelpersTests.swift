/*
 * WhiteboardHelpersTests.swift 
 * whiteboard_helpersTests 
 *
 * Created by Callum McColl on 11/03/2019.
 * Copyright © 2019 Callum McColl. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials
 *    provided with the distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *
 *        This product includes software developed by Callum McColl.
 *
 * 4. Neither the name of the author nor the names of contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * -----------------------------------------------------------------------
 * This program is free software; you can redistribute it and/or
 * modify it under the above terms or under the terms of the GNU
 * General Public License as published by the Free Software Foundation;
 * either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see http://www.gnu.org/licenses/
 * or write to the Free Software Foundation, Inc., 51 Franklin Street,
 * Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */

@testable import whiteboard_helpers

import XCTest

public final class WhiteboardHelpersTests: XCTestCase {

    public static var allTests: [(String, (WhiteboardHelpersTests) -> () throws -> Void)] {
        return [
            ("test_point_2D", test_point_2D),
            ("test_Point_2D_withSpace", test_Point_2D_withSpace),
            ("test_esp", test_esp),
            ("test_parsesSingleCNamespace", test_parsesSingleCNamespace),
            ("test_parsesSingleCNamespaceWithUnderscore", test_parsesSingleCNamespaceWithUnderscore),
            ("test_cannotParseNamespaceBeginningWithUnderscore", test_cannotParseNamespaceBeginningWithUnderscore),
            ("test_cannotParseNamespaceEndingWithUnderscore", test_cannotParseNamespaceEndingWithUnderscore),
            ("test_cannotParseNamespaceContainingUnsupportedSymbols", test_cannotParseNamespaceContainingUnsupportedSymbols),
            ("test_parsesMultipleNamespaces", test_parsesMultipleNamespaces)
        ]
    }

    fileprivate var helpers: WhiteboardHelpers {
        return WhiteboardHelpers()
    }

    public func test_point_2D() {
        let name = "point_2D"
        XCTAssertEqual("wb_point_2d", self.helpers.createStructName(forClassNamed: name))
        XCTAssertEqual("Point2D", self.helpers.createClassName(forClassNamed: name))
        XCTAssertEqual("wb_point_2d", self.helpers.createStructName(forClassNamed: name, backwardsCompatible: true))
        XCTAssertEqual("point2D", self.helpers.createClassName(forClassNamed: name, backwardsCompatible: true))
    }

    public func test_Point_2D_withSpace() {
        let name = "Point_2 D"
        XCTAssertEqual("wb_point_2_d", self.helpers.createStructName(forClassNamed: name))
        XCTAssertEqual("Point2D", self.helpers.createClassName(forClassNamed: name))
        XCTAssertEqual("wb_point_2 d", self.helpers.createStructName(forClassNamed: name, backwardsCompatible: true))
        XCTAssertEqual("Point2 D", self.helpers.createClassName(forClassNamed: name, backwardsCompatible: true))
    }

    public func test_esp() {
        let name = "esp8266_pin_toggle"
        XCTAssertEqual("wb_esp8266_pin_toggle", self.helpers.createStructName(forClassNamed: name))
        XCTAssertEqual("Esp8266PinToggle", self.helpers.createClassName(forClassNamed: name))
        //swiftlint:disable:next line_length
        XCTAssertEqual("wb_esp8266_pin_toggle", self.helpers.createStructName(forClassNamed: name, backwardsCompatible: true))
        XCTAssertEqual("esp8266PinToggle", self.helpers.createClassName(forClassNamed: name, backwardsCompatible: true))
    }
    
    public func test_parsesSingleCNamespace() {
        let namespace = "namespace"
        let result: [CNamespace]
        do {
            result = try self.helpers.parseNamespaces(namespace)
        } catch let e {
            XCTFail("Unable to parse namespace: \(e).")
            return
        }
        XCTAssertEqual(["namespace"], result)
    }
    
    public func test_parsesSingleCNamespaceWithUnderscore() {
        let namespace = "first_namespace"
        let result: [CNamespace]
        do {
            result = try self.helpers.parseNamespaces(namespace)
        } catch let e {
            XCTFail("Unable to parse namespace: \(e).")
            return
        }
        XCTAssertEqual(["first_namespace"], result)
    }
    
    public func test_cannotParseNamespaceBeginningWithUnderscore() {
        let namespace = "_namespace"
        do {
            _ = try self.helpers.parseNamespaces(namespace)
        } catch {
            return
        }
        XCTFail("Expected failure to parse namespace beginning with underscore.")
    }
    
    public func test_cannotParseNamespaceEndingWithUnderscore() {
        let namespace = "namespace_"
        do {
            _ = try self.helpers.parseNamespaces(namespace)
        } catch {
            return
        }
        XCTFail("Expected failure to parse namespace ending with underscore.")
    }
    
    public func test_cannotParseNamespaceContainingUnsupportedSymbols() {
        let namespace = "namesp!ace"
        do {
            _ = try self.helpers.parseNamespaces(namespace)
        } catch let e as WhiteboardHelpers.ParserErrors {
            switch e {
            case .malformedValue(let reason):
                self.checkErrorMessage(reason, offendingCharacter: "!")
                return
            default:
                break
            }
        } catch {
            XCTFail("Unexpected error thrown while parsing malformed namespace.")
        }
        XCTFail("Expected failure to parse namespace ending with underscore.")
    }
    
    public func test_parsesMultipleNamespaces() {
        let namespace = "first_namespace::second_namespace"
        let result: [CNamespace]
        do {
            result = try self.helpers.parseNamespaces(namespace)
        } catch let e {
            XCTFail("Unable to parse namespace: \(e).")
            return
        }
        XCTAssertEqual(["first_namespace", "second_namespace"], result)
    }
    
    fileprivate func checkErrorMessage(_ errorMessage: String, offendingCharacter: Character) {
        let split = errorMessage.split(separator: "\n")
        guard
            let (index, _) = errorMessage.enumerated().first(where: { $0.element == offendingCharacter }),
            let secondLastLine = split.dropLast().last,
            let lastLine = split.last
        else {
            XCTFail("Malformed error message: \(errorMessage).")
            return
        }
        let spaces = String(Array(repeating: " ", count: index))
        XCTAssertEqual(secondLastLine, spaces + "^")
        XCTAssertEqual(lastLine, spaces + "|")
    }

}
