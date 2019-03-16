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

    fileprivate let helpers: StringHelpers

    public init(helpers: StringHelpers = StringHelpers()) {
        self.helpers = helpers
    }

    public func createArrayCountDef(inClass className: String, forVariable label: String, level: Int, backwardsCompatible _: Bool = false) -> String {
        let levelStr = 0 == level ? "" : "_\(level)"
        return "\(className.uppercased())_\(label.uppercased())\(levelStr)_ARRAY_SIZE"
    }

    public func createArrayCountDef(inClass className: String, backwardsCompatible: Bool = false) -> (String) -> (Int) -> String {
        //swiftlint:disable:next opening_brace
        return { variable in
            return { level in
                self.createArrayCountDef(inClass: className, forVariable: variable, level: level, backwardsCompatible: backwardsCompatible)
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
    
    public func createDefName(forClassNamed className: String, backwardsCompatible: Bool = false) -> String {
        return className.uppercased()
    }

    public func createStructName(forClassNamed className: String, backwardsCompatible: Bool = false) -> String {
        if true == backwardsCompatible {
            return "wb_" + className.lowercased()
        }
        return "wb_" + self.helpers.toSnakeCase(String(className.lazy.map {
            self.helpers.isAlphaNumeric($0) ? $0 : "_"
        })).lowercased()
    }

    public func createDescriptionBufferSizeDef(forClassNamed className: String, backwardsCompatible _: Bool = false) -> String {
        return className.uppercased() + "_DESC_BUFFER_SIZE"
    }

    public func createToStringBufferSizeDef(forClassNamed className: String, backwardsCompatible _: Bool = false) -> String {
        return className.uppercased() + "_TO_STRING_BUFFER_SIZE"
    }

}
