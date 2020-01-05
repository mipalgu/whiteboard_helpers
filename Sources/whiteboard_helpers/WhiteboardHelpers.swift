/*
 * WhiteboardHelpers.swift 
 * whiteboard_helpers
 *
 * Created by Callum McColl on 04/01/2018.
 * Copyright © 2017 Callum McColl. All rights reserved.
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

import Foundation

import swift_helpers

public final class WhiteboardHelpers {
    
    public enum ParserErrors: Error {
        
        case malformedValue(reason: String)
        
    }

    fileprivate let helpers: StringHelpers

    public init(helpers: StringHelpers = StringHelpers()) {
        self.helpers = helpers
    }

    //swiftlint:disable:next line_length
    public func createArrayCountDef(inClass className: String, forVariable label: String, level: Int, backwardsCompatible: Bool = false, namespaces: [CNamespace]? = nil) -> String {
        let levelStr = 0 == level ? "" : "_\(level)"
        let def = self.createDefName(forClassNamed: className, backwardsCompatible: backwardsCompatible, namespaces: namespaces)
        return "\(def)_\(label.uppercased())\(levelStr)_ARRAY_SIZE"
    }

    //swiftlint:disable:next line_length
    public func createArrayCountDef(inClass className: String, backwardsCompatible: Bool = false, namespaces: [CNamespace]? = nil) -> (String) -> (Int) -> String {
        return { variable in
            return { level in
                self.createArrayCountDef(
                    inClass: className,
                    forVariable: variable,
                    level: level,
                    backwardsCompatible: backwardsCompatible,
                    namespaces: namespaces
                )
            }
        }
    }

    public func createClassName(forClassNamed className: String, backwardsCompatible: Bool = false) -> String {
        if true == backwardsCompatible {
            let split = className.split(separator: "_").lazy.map { String($0) }
            return split.combine("") { $0 + ($1.first.map { String($0).capitalized } ?? "") + String($1.dropFirst()) }
        }
        let camel = self.helpers.toCamelCase(className)
        guard let first = camel.first else {
            return ""
        }
        return String(self.helpers.toUpper(first)) + String(camel.dropFirst())
    }

    public func createDefName(forClassNamed className: String, backwardsCompatible: Bool = false, namespaces: [CNamespace]? = nil) -> String {
        let namespace = namespaces?.reduce("") { $0 + $1 + "_" } ?? ""
        return namespace.uppercased() + className.uppercased()
    }

    public func createStructName(forClassNamed className: String, backwardsCompatible: Bool = false, namespaces: [CNamespace]? = nil) -> String {
        let namespace = namespaces?.reduce("") { $0 + $1 + "_" } ?? ""
        if true == backwardsCompatible {
            return "wb_" + namespace + className.lowercased()
        }
        return "wb_" + namespace + self.helpers.toSnakeCase(String(className.lazy.map {
            self.helpers.isAlphaNumeric($0) ? $0 : "_"
        })).lowercased()
    }

    //swiftlint:disable:next line_length
    public func createDescriptionBufferSizeDef(forClassNamed className: String, backwardsCompatible: Bool = false, namespaces: [CNamespace]? = nil) -> String {
        let defName = self.createDefName(forClassNamed: className, backwardsCompatible: backwardsCompatible, namespaces: namespaces)
        return defName + "_DESC_BUFFER_SIZE"
    }

    //swiftlint:disable:next line_length
    public func createToStringBufferSizeDef(forClassNamed className: String, backwardsCompatible: Bool = false, namespaces: [CNamespace]? = nil) -> String {
        let defName = self.createDefName(forClassNamed: className, backwardsCompatible: backwardsCompatible, namespaces: namespaces)
        return defName + "_TO_STRING_BUFFER_SIZE"
    }
    
    /**
     *  Parse a string containing a list of C namespaces separated by '::'.
     *
     *  This function is helpful for parsing the namespaces used to namespace
     *  C struct/functions and the C++ classes used through the whiteboard. The
     *  global whiteboard has no namespace, however custom whiteboards may
     *  leverage namespaces to stop conflicting type names between the global
     *  whiteboard and other custom whiteboards.
     *
     *  The String `str` may be formatted in the C++ format, although it is
     *  recommeded that the c style namespace format be used. In this sense,
     *  namespaces should be written in lowercase letters separated by
     *  underscores. To specify separate namespaces separate each namespace
     *  with '::'. For example:
     *  ```
     *  "first_namespace::second_namespace::third_namespace"
     *  ```
     *
     *  - Parameter str: The string containing the C namespaces.
     *
     *  - Returns: An array of `CNamespace`s.
     *
     *  - Throws: A `WhiteboardHelpers.ParserError` when `str` is malformed.
     *
     *  - Complexity: O(n)
     */
    public func parseNamespaces(_ str: String) throws -> [CNamespace] {
        let namespaces = str.components(separatedBy: "::")
        let check: ((Int, Character)) -> Bool = { (tuple: (Int, Character)) -> Bool in
            !tuple.1.isASCII || (!tuple.1.isLetter && !tuple.1.isNumber && tuple.1 != "_")
        }
        let tuple: (Int, String)? = namespaces.reduce(nil) {
            if nil != $0 {
                return $0
            }
            if $1.first! == "_" {
                return (0, $1)
            }
            if $1.last! == "_" {
                return ($1.count - 1, $1)
            }
            if let (firstIndex, _) = $1.enumerated().first(where: check) {
                return (firstIndex, $1)
            }
            return $0
        }
        if let (index, errorStr) = tuple {
            let pre = "The namespace list '"
            let spaces = String(Array<Character>(repeating: " ", count: pre.count + index))
            throw ParserErrors.malformedValue(reason: pre + errorStr + "' must only contain letters, numbers and underscores separated by '::'." + "\n" + spaces + "^" + "\n" + spaces + "|")
        }
        return namespaces.map { CNamespace(self.helpers.toSnakeCase(String($0))) }
    }
    
    /**
     *  Convert a `CPPNamespace` to a `CNamespace`.
     *
     *  This function converts a snake case C style namespace, into its
     *  corresponding camel case C++ representation.
     *
     *  - Parameter cppNamespace: The `CPPNamespace` which is being converted.
     *
     *  - Returns: The equivalent `CNamespace`.
     *
     *  - SeeAlso: `StringHelpers.toSnakeCase(_: String)`.
     */
    public func toCNamespace(cppNamespace: CPPNamespace) -> CNamespace {
        return CNamespace(self.helpers.toSnakeCase(String(cppNamespace)))
    }
    
    /**
     *  Convert a `CNamespace` to a `CPPNamespace`.
     *
     *  This function converts a camel cased C++ style namespace, into its
     *  corresponding snake cased C style representation.
     *
     *  - Parameter cNamespace: The `CNamespace` which is being converted.
     *
     *  - Returns: The equivalent `CPPNamespace`.
     *
     *  - SeeAlso: `StringHelpers.toCamelCase(_: String)`.
     */
    public func toCPPNamespace(cNamespace: CNamespace) -> CPPNamespace {
        return CPPNamespace(self.helpers.toCamelCase(String(cNamespace)))
    }

}
