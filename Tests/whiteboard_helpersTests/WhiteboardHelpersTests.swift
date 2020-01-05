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
            ("test_parsesMultipleNamespaces", test_parsesMultipleNamespaces),
            ("test_createDefNameOnCName", test_createDefNameOnCName),
            ("test_createDefNameWorksWithNumbers", test_createDefNameWorksWithNumbers),
            ("test_createArrayCountDef", test_createArrayCountDef),
            ("test_createArrayCountDefWithLevel", test_createArrayCountDefWithLevel),
            ("test_createArrayCountDefWithBackwardsCompatibility", test_createArrayCountDefWithBackwardsCompatibility),
            ("test_createClassName", test_createClassName),
            ("test_createClassNameWithNumbers", test_createClassNameWithNumbers),
            ("test_createClassNameWithNumbersWithoutUnderscores", test_createClassNameWithNumbersWithoutUnderscores),
            ("test_createClassNameWithCamelCase", test_createClassNameWithCamelCase),
            ("test_createClassNameWithBackwardsCompatibility", test_createClassNameWithBackwardsCompatibility),
            ("test_createClassNameWithNumbersWithBackwardsCompatibility", test_createClassNameWithNumbersWithBackwardsCompatibility),
            ("test_createClassNameWithNumbersWithoutUnderscoresWithBackwardsCompatibility", test_createClassNameWithNumbersWithoutUnderscoresWithBackwardsCompatibility),
            ("test_createClassNameWithCamelCaseWithBackwardsCompatibility", test_createClassNameWithCamelCaseWithBackwardsCompatibility),
            ("test_createStructName", test_createStructName),
            ("test_createStructNameWithNumbers", test_createStructNameWithNumbers),
            ("test_createStructNameWithNumbersWithoutUnderscores", test_createStructNameWithNumbersWithoutUnderscores),
            ("test_createStructNameWithCamelCase", test_createStructNameWithCamelCase),
            ("test_createStructNameWithBackwardsCompatibility", test_createStructNameWithBackwardsCompatibility),
            ("test_createStructNameWithNumbersWithBackwardsCompatibility", test_createStructNameWithNumbersWithBackwardsCompatibility),
            ("test_createStructNameWithNumbersWithoutUnderscoresWithBackwardsCompatibility", test_createStructNameWithNumbersWithoutUnderscoresWithBackwardsCompatibility),
            ("test_createStructNameWithCamelCaseWithBackwardsCompatibility", test_createStructNameWithCamelCaseWithBackwardsCompatibility),
            ("test_createDescriptionBufferSizeDef", test_createDescriptionBufferSizeDef),
            ("test_createDescriptionBufferSizeDefWithBackwardsCompatibility", test_createDescriptionBufferSizeDefWithBackwardsCompatibility),
            ("test_createToStringBufferSizeDef", test_createToStringBufferSizeDef),
            ("test_createToStringBufferSizeDefWithBackwardsCompatibility", test_createToStringBufferSizeDefWithBackwardsCompatibility)
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
        } catch let e as WhiteboardHelpers.ParserErrors {
            switch e {
            case .malformedValue(let reason):
                self.checkErrorMessage(reason, offendingCharacter: "_")
                return
            }
        } catch {
            XCTFail("Unexpected error thrown while parsing malformed namespace.")
        }
        XCTFail("Expected failure to parse namespace beginning with underscore.")
    }
    
    public func test_cannotParseNamespaceEndingWithUnderscore() {
        let namespace = "namespace_"
        do {
            _ = try self.helpers.parseNamespaces(namespace)
        } catch let e as WhiteboardHelpers.ParserErrors {
            switch e {
            case .malformedValue(let reason):
                self.checkErrorMessage(reason, offendingCharacter: "_")
                return
            }
        } catch {
            XCTFail("Unexpected error thrown while parsing malformed namespace.")
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
    
    public func test_createDefNameOnCName() {
        let name = "some_class"
        let result = self.helpers.createDefName(forClassNamed: name)
        XCTAssertEqual("SOME_CLASS", result)
    }
    
    public func test_createDefNameWorksWithNumbers() {
        let name = "some_1_class2_3"
        let result = self.helpers.createDefName(forClassNamed: name)
        XCTAssertEqual("SOME_1_CLASS2_3", result)
    }
    
    public func test_createArrayCountDef() {
        let classname = "some_class"
        let variable = "variable"
        let result = self.helpers.createArrayCountDef(inClass: classname, forVariable: variable, level: 0, backwardsCompatible: false)
        XCTAssertEqual("SOME_CLASS_VARIABLE_ARRAY_SIZE", result)
    }
    
    public func test_createArrayCountDefWithLevel() {
        let classname = "some_class"
        let variable = "variable"
        let level = 3
        let result = self.helpers.createArrayCountDef(inClass: classname, forVariable: variable, level: level, backwardsCompatible: false)
        XCTAssertEqual("SOME_CLASS_VARIABLE_3_ARRAY_SIZE", result)
    }
    
    public func test_createArrayCountDefWithBackwardsCompatibility() {
        let classname = "some_class"
        let variable = "variable"
        let level = 3
        let result = self.helpers.createArrayCountDef(inClass: classname, forVariable: variable, level: level, backwardsCompatible: true)
        XCTAssertEqual("SOME_CLASS_VARIABLE_3_ARRAY_SIZE", result)
    }
    
    public func test_createClassName() {
        let classname = "some_class"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("SomeClass", result)
    }
    
    public func test_createClassNameWithNumbers() {
        let classname = "some23_class1"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("Some23Class1", result)
    }
    
    public func test_createClassNameWithNumbersWithoutUnderscores() {
        let classname = "some23class1"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("Some23class1", result)
    }
    
    public func test_createClassNameWithCamelCase() {
        let classname = "some_ClassName"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("SomeClassName", result)
    }
    
    public func test_createClassNameWithBackwardsCompatibility() {
        let classname = "some_class"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("someClass", result)
    }
    
    public func test_createClassNameWithNumbersWithBackwardsCompatibility() {
        let classname = "some23_class1"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("some23Class1", result)
    }
    
    public func test_createClassNameWithNumbersWithoutUnderscoresWithBackwardsCompatibility() {
        let classname = "some23class1"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("some23class1", result)
    }
    
    public func test_createClassNameWithCamelCaseWithBackwardsCompatibility() {
        let classname = "some_ClassName"
        let result = self.helpers.createClassName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("someClassName", result)
    }
    
    public func test_createStructName() {
        let classname = "some_class"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("wb_some_class", result)
    }
    
    public func test_createStructNameWithNumbers() {
        let classname = "some23_class1"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("wb_some23_class1", result)
    }
    
    public func test_createStructNameWithNumbersWithoutUnderscores() {
        let classname = "some23class1"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("wb_some23class1", result)
    }
    
    public func test_createStructNameWithCamelCase() {
        let classname = "some_ClassName"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: false)
        XCTAssertEqual("wb_some_class_name", result)
    }
    
    public func test_createStructNameWithBackwardsCompatibility() {
        let classname = "some_class"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("wb_some_class", result)
    }
    
    public func test_createStructNameWithNumbersWithBackwardsCompatibility() {
        let classname = "some23_class1"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("wb_some23_class1", result)
    }
    
    public func test_createStructNameWithNumbersWithoutUnderscoresWithBackwardsCompatibility() {
        let classname = "some23class1"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("wb_some23class1", result)
    }
    
    public func test_createStructNameWithCamelCaseWithBackwardsCompatibility() {
        let classname = "some_ClassName"
        let result = self.helpers.createStructName(forClassNamed: classname, backwardsCompatible: true)
        XCTAssertEqual("wb_some_classname", result)
    }
    
    public func test_createDescriptionBufferSizeDef() {
        let classnames = ["some_class", "some23class1", "some23class1", "some_ClassName"]
        for classname in classnames {
            let def = self.helpers.createDefName(forClassNamed: classname, backwardsCompatible: false)
            let result = self.helpers.createDescriptionBufferSizeDef(forClassNamed: classname, backwardsCompatible: false)
            XCTAssertEqual(def + "_DESC_BUFFER_SIZE", result)
        }
    }
    
    public func test_createDescriptionBufferSizeDefWithBackwardsCompatibility() {
        let classnames = ["some_class", "some23class1", "some23class1", "some_ClassName"]
        for classname in classnames {
            let def = self.helpers.createDefName(forClassNamed: classname, backwardsCompatible: true)
            let result = self.helpers.createDescriptionBufferSizeDef(forClassNamed: classname, backwardsCompatible: true)
            XCTAssertEqual(def + "_DESC_BUFFER_SIZE", result)
        }
    }
    
    public func test_createToStringBufferSizeDef() {
        let classnames = ["some_class", "some23class1", "some23class1", "some_ClassName"]
        for classname in classnames {
            let def = self.helpers.createDefName(forClassNamed: classname, backwardsCompatible: false)
            let result = self.helpers.createToStringBufferSizeDef(forClassNamed: classname, backwardsCompatible: false)
            XCTAssertEqual(def + "_TO_STRING_BUFFER_SIZE", result)
        }
    }
    
    public func test_createToStringBufferSizeDefWithBackwardsCompatibility() {
        let classnames = ["some_class", "some23class1", "some23class1", "some_ClassName"]
        for classname in classnames {
            let def = self.helpers.createDefName(forClassNamed: classname, backwardsCompatible: true)
            let result = self.helpers.createToStringBufferSizeDef(forClassNamed: classname, backwardsCompatible: true)
            XCTAssertEqual(def + "_TO_STRING_BUFFER_SIZE", result)
        }
    }

}
