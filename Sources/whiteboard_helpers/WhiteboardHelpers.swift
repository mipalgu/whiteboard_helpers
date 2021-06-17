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

/**
 *  Provides a collection of useful naming functions.
 *
 *  These collection of functions are provided to create a uniform standard
 *  between for the names of #defines, structs, classes, and functions that are
 *  used to generate whiteboard classes.
 */
public final class WhiteboardHelpers {

    // MARK: Initialisation
    
    fileprivate let helpers: StringHelpers

    /**
     *  Create a new `WhiteboardHelpers`.
     *
     *  - Parameter helpers: A `swift_helpers.StringHelpers` which is used to
     *  perform some of the text manipulation.
     */
    public init(helpers: StringHelpers = StringHelpers()) {
        self.helpers = helpers
    }
    
    // MARK: Generating #define Names

    /**
     *  Create the #define name for the #define containg the length of a C
     *  style array.
     *
     *  This #define specifies the length of the buffer used in the C style
     *  description functions.
     *
     *  - Parameter className: The name specified in the gen file. This name
     *  should be formatted as per the classgenerator specification. This name
     *  is not the C struct name, nor the C++ class name nor the swift wrapper
     *  name. It is the gen name. For example, the gen 'my_class.gen' would
     *  result in a name of 'my_class'.
     *
     *  - Parameter label: A string containing the array variables label.
     *
     *  - Parameter level: The value is used to allow for multi dimensional
     *  arrays. The level starts at 0 indicating the length of the actual
     *  array referenced by `label`, and each increment of level indicates the
     *  length of each inner array. As an example, consider the following array:
     *  `int myArray[5][3]` The 5 in `myArray` is level 0, whereas the 3 is
     *  level 1.
     *
     *  - Parameter backwardsCompatible: Specifies whether or not to follow the
     *  naming convention used by the first 'Mick' classgenerator. This should
     *  only be used for gens that were creating using the old '.txt'. format.
     *
     *  - Parameter namespaces: Specify a list of namespaces. These namespaces
     *  are used to create a unique #define in case the same gen is used
     *  in multiple different whiteboards that are being accessed by the same
     *  application. Each version of the gen would then need to exist in it's
     *  own namespace.
     *
     *  - Returns: A unique string representing the #define name for the #define
     *  containing the length of the array specified by `label` and `level`.
     *
     *  - SeeAlso: `createDefName(forClassNamed:backwardsCompatible:namespaces:)`
     */
    public func createArrayCountDef(
        inClass className: String,
        forVariable label: String,
        level: Int,
        backwardsCompatible: Bool = false,
        namespaces: [CNamespace] = []
    ) -> String {
        let levelStr = 0 == level ? "" : "_\(level)"
        let def = self.createDefName(
            forClassNamed: className,
            backwardsCompatible: backwardsCompatible,
            namespaces: namespaces
        )
        return "\(def)_\(label.uppercased())\(levelStr)_ARRAY_SIZE"
    }

    /**
     *  This function creates a helper function that can be used to simply the
     *  use of `createArrayCountDef(inClass:forVariable:level:backwardsCompatible:namespaces:)`.
     *
     *  This function simplifies the process of creating a #define name
     *  for an array by creating a function that only takes the array variables
     *  label, followed by the level. This way one could call the function
     *  with the variables label, then make a subsequent call with each level
     *  that needs to be handled. This effectively allows one to loop over
     *  all levels without needing to remember all the other details.
     *
     *  - Parameter className: The name specified in the gen file. This name
     *  should be formatted as per the classgenerator specification. This name
     *  is not the C struct name, nor the C++ class name nor the swift wrapper
     *  name. It is the gen name. For example, the gen 'my_class.gen' would
     *  result in a name of 'my_class'.
     *
     *  - Parameter backwardsCompatible: Specifies whether or not to follow the
     *  naming convention used by the first 'Mick' classgenerator. This should
     *  only be used for gens that were creating using the old '.txt'. format.
     *
     *  - Parameter namespaces: Specify a list of namespaces. These namespaces
     *  are used to create a unique #define in case the same gen is used
     *  in multiple different whiteboards that are being accessed by the same
     *  application. Each version of the gen would then need to exist in it's
     *  own namespace.
     *
     *  - Returns: A function which takes the variable label, then returns
     *  another function which takes a level, which returns the #define
     *  name.
     *
     *  - SeeAlso: `createArrayCountDef(inClass:forVariable:level:backwardsCompatible:namespaces:)`
     */
    public func createArrayCountDef(
        inClass className: String,
        backwardsCompatible: Bool = false,
        namespaces: [CNamespace] = []
    ) -> (String) -> (Int) -> String {
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

    /**
     *  Create the prefix of a #define.
     *
     *  This prefix basically namespaces a specific #define so that is unique
     *  for a specific class, and optionally, for a specific whiteboard.
     *
     *  - Warning: You may use this function if you would like to create
     *  defines for a specific gen not convered by the other functions provided
     *  by this class. Generally, you should attempt to use the other functions
     *  provided in this class before trying to use this function.
     *
     *  - Parameter className: The name specified in the gen file. This name
     *  should be formatted as per the classgenerator specification. This name
     *  is not the C struct name, nor the C++ class name nor the swift wrapper
     *  name. It is the gen name. For example, the gen 'my_class.gen' would
     *  result in a name of 'my_class'.
     *
     *  - Parameter backwardsCompatible: Specifies whether or not to follow the
     *  naming convention used by the first 'Mick' classgenerator. This should
     *  only be used for gens that were creating using the old '.txt'. format.
     *
     *  - Parameter namespaces: Specify a list of namespaces. These namespaces
     *  are used to create a unique #define in case the same gen is used
     *  in multiple different whiteboards that are being accessed by the same
     *  application. Each version of the gen would then need to exist in it's
     *  own namespace.
     *
     *  - Returns: A unique string representing the prefix of a #define.
     */
    public func createDefName(
        forClassNamed className: String,
        backwardsCompatible: Bool = false,
        namespaces: [CNamespace] = []
    ) -> String {
        if namespaces.isEmpty {
            return className.uppercased()
        }
        let namespace = namespaces.joined(separator: "_")
        return namespace.uppercased() + "_" + className.uppercased()
    }

    /**
     *  Create the #define name for the to_string buffer size.
     *
     *  This #define specifies the length of the buffer used in the C style
     *  description functions.
     *
     *  - Parameter className: The name specified in the gen file. This name
     *  should be formatted as per the classgenerator specification. This name
     *  is not the C struct name, nor the C++ class name nor the swift wrapper
     *  name. It is the gen name. For example, the gen 'my_class.gen' would
     *  result in a name of 'my_class'.
     *
     *  - Parameter backwardsCompatible: Specifies whether or not to follow the
     *  naming convention used by the first 'Mick' classgenerator. This should
     *  only be used for gens that were creating using the old '.txt'. format.
     *
     *  - Parameter namespaces: Specify a list of namespaces. These namespaces
     *  are used to create a unique #define in case the same gen is used
     *  in multiple different whiteboards that are being accessed by the same
     *  application. Each version of the gen would then need to exist in it's
     *  own namespace.
     *
     *  - Returns: A unique string representing the #define name of the
     *  C style description buffer size.
     *
     *  - SeeAlso: `createDefName(forClassNamed:backwardsCompatible:namespaces:)`
     */
    public func createDescriptionBufferSizeDef(
        forClassNamed className: String,
        backwardsCompatible: Bool = false,
        namespaces: [CNamespace] = []
    ) -> String {
        let defName = self.createDefName(
            forClassNamed: className,
            backwardsCompatible: backwardsCompatible,
            namespaces: namespaces
        )
        return defName + "_DESC_BUFFER_SIZE"
    }

    /**
     *  Create the #define name for the to_string buffer size.
     *
     *  This #define specifies the length of the buffer used in the C style
     *  to_string functions.
     *
     *  - Parameter className: The name specified in the gen file. This name
     *  should be formatted as per the classgenerator specification. This name
     *  is not the C struct name, nor the C++ class name nor the swift wrapper
     *  name. It is the gen name. For example, the gen 'my_class.gen' would
     *  result in a name of 'my_class'.
     *
     *  - Parameter backwardsCompatible: Specifies whether or not to follow the
     *  naming convention used by the first 'Mick' classgenerator. This should
     *  only be used for gens that were creating using the old '.txt'. format.
     *
     *  - Parameter namespaces: Specify a list of namespaces. These namespaces
     *  are used to create a unique #define in case the same gen is used
     *  in multiple different whiteboards that are being accessed by the same
     *  application. Each version of the gen would then need to exist in it's
     *  own namespace.
     *
     *  - Returns: A unique string representing the #define name of the
     *  C style to_string buffer size.
     *
     *  - SeeAlso: `createDefName(forClassNamed:backwardsCompatible:namespaces:)`
     */
    public func createToStringBufferSizeDef(
        forClassNamed className: String,
        backwardsCompatible: Bool = false,
        namespaces: [CNamespace] = []
    ) -> String {
        let defName = self.createDefName(
            forClassNamed: className,
            backwardsCompatible: backwardsCompatible,
            namespaces: namespaces
        )
        return defName + "_TO_STRING_BUFFER_SIZE"
    }
    
    // MARK: Generating Struct/Class Names
    
    /**
     *  Create the C++ style class name for the specified generated class.
     *
     *  Note that all classes that are generated by this function are not
     *  prefixed with anything. This is because the languages that use object
     *  oriented classes should be able to namespace them using other means
     *  (namespaces in C++/packages in swift). Because of this, this function
     *  differs from the other naming generation functions provided in this
     *  class; being that it does not take as a parameter an array of
     *  namespaces.
     *
     *  - Parameter className: The name specified in the gen file. This name
     *  should be formatted as per the classgenerator specification. This name
     *  is not the C struct name, nor the C++ class name, nor the swift wrapper
     *  name. It is the gen name. For example, the gen 'my_class.gen' would
     *  result in a name of 'my_class'.
     *
     *  - Parameter backwardsCompatible: Specifies whether or not to follow the
     *  naming convention used by the first 'Mick' classgenerator. This should
     *  only be used for gens that were creating using the old '.txt'. format.
     *
     *  - Returns: The corresponding C++ style class name for the specified
     *  class.
     */
    public func createClassName(
        forClassNamed className: String,
        backwardsCompatible: Bool = false
    ) -> String {
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
    
    public func includeGuard(forCHeader file: String, namespaces: [CNamespace]) -> String {
        let fileName = file.uppercased().replacingOccurrences(of: ".", with: "_")
        if namespaces.isEmpty {
            return fileName
        }
        return namespaces.map { $0.uppercased() }.joined(separator: "_") + "_" + fileName
    }
    
    public func includeGuard(forCPPHeader file: String, namespaces: [CPPNamespace]) -> String {
        let fileName = file.uppercased().replacingOccurrences(of: ".", with: "_")
        if namespaces.isEmpty {
            return fileName
        }
        return namespaces.map { $0.uppercased() }.joined(separator: "_") + "_" + fileName
    }
    
    public func cIncludeGuard(
        forClassNamed className: String,
        backwardsCompatible: Bool = false,
        namespaces: [CNamespace] = []
    ) -> String {
        self.createDefName(forClassNamed: className, backwardsCompatible: backwardsCompatible, namespaces: namespaces) + "_DEFINED"
    }
    
    public func cppIncludeGuard(
        forClassNamed className: String,
        backwardsCompatible: Bool = false,
        namespaces: [CPPNamespace] = []
    ) -> String {
        self.createDefName(forClassNamed: className, backwardsCompatible: backwardsCompatible, namespaces: namespaces.map { toCNamespace(cppNamespace: $0) }) + "_DEFINED"
    }
    
    public func createNamespacedClassName(
        forClassNamed className: String,
        backwardsCompatible: Bool = false,
        namespaces: [CPPNamespace] = []
    ) -> String {
        (namespaces + [CPPNamespace(createClassName(forClassNamed: className, backwardsCompatible: backwardsCompatible))]).joined(separator: "::")
    }
    
    public func cConversionDefine(forStructNamed structName: String) -> String {
        return "USE_" + structName.uppercased() + "_C_CONVERSION"
    }
    
    /**
     *  Create the C style struct name for the specified generated class.
     *
     *  All struct names generated by this function have a prefix of
     *  'wb_'. This is to keep all whiteboard structs within the same global
     *  'wb' namesapce.
     *
     *  - Parameter className: The name specified in the gen file. This name
     *  should be formatted as per the classgenerator specification. This name
     *  is not the C struct name, nor the C++ class name, nor the swift wrapper
     *  name. It is the gen name. For example, the gen 'my_class.gen' would
     *  result in a name of 'my_class'.
     *
     *  - Parameter backwardsCompatible: Specifies whether or not to follow the
     *  naming convention used by the first 'Mick' classgenerator. This should
     *  only be used for gens that were creating using the old '.txt'. format.
     *
     *  - Parameter namespaces: Specify a list of namespaces. These namespaces
     *  are used to create a unique struct name in case the same gen is used
     *  in multiple different whiteboards that are being accessed by the same
     *  application. Each version of the gen would then need to exist in it's
     *  own namespace.
     *
     *  - Returns: The corresponding struct name for the specified class.
     */
    public func createStructName(forClassNamed className: String, backwardsCompatible: Bool = false, namespaces: [CNamespace] = []) -> String {
        let namespace = cNamespace(of: namespaces)
        if true == backwardsCompatible {
            return namespaces.isEmpty ? className.lowercased() : namespace + "_" + className.lowercased()
        }
        let name = self.helpers.toSnakeCase(String(className.lazy.map {
            self.helpers.isAlphaNumeric($0) ? $0 : "_"
        })).lowercased()
        return namespaces.isEmpty ? name : namespace + "_" + name
    }
    
    // MARK: Namespace Parsing and Manipulation
    
    /**
     *  A list of possible errors that may be triggered through the use of
     *  certain functions within this class.
     */
    public enum ParserErrors: Error {

        /**
         *  Provides an easy way to access error messages.
         *
         *  This avoids the need to do a switch case over a `ParserErrors`
         *  everytime an error is thrown. Simply handle the error as follows:
         *  ```
         *  do {
         *      let result = try someFunctionThatThrows()
         *  } catch let e as WhiteboardHelpers.ParserErrors {
         *      fatalError(e.message) // Access the message.
         *  } catch {
         *      // Some other error is thrown.
         *  }
         *  ```
         */
        public var message: String {
            switch self {
            case .malformedValue(let reason):
                return reason
            }
        }
        
        /**
         *  A value was not formatted correctly.
         *
         *  This error is triggered when certain values do not meet their
         *  specific specifications. A `reason` is provided to explain the
         *  specific reason for why this error is thrown.
         */
        case malformedValue(reason: String)

    }
    
    public func parseNamespacePair(_ str: String) throws -> (CNamespace, CPPNamespace) {
        let namespaces = str.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":")
        if namespaces.isEmpty {
            throw ParserErrors.malformedValue(reason: "Must not be empty")
        }
        let cNamespaceStr = namespaces[0].trimmingCharacters(in: .whitespacesAndNewlines)
        if cNamespaceStr.isEmpty {
            let cppNamespace = try parseCPPNamespace(namespaces[1])
            return (toCNamespace(cppNamespace: cppNamespace), cppNamespace)
        }
        let cNamespace = try parseCNamespace(cNamespaceStr)
        if namespaces.count < 2 {
            return (cNamespace, toCPPNamespace(cNamespace: cNamespace))
        }
        let cppNamespaceStr = namespaces[1].trimmingCharacters(in: .whitespacesAndNewlines)
        if cppNamespaceStr.isEmpty {
            return (cNamespace, toCPPNamespace(cNamespace: cNamespace))
        }
        let cppNamespace = try parseCPPNamespace(cppNamespaceStr)
        return (cNamespace, cppNamespace)
    }
    
    public func parseCNamespace(_ str: String) throws -> CNamespace {
        let namespace = str.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstChar = namespace.first, let lastChar = namespace.last else {
            throw ParserErrors.malformedValue(reason: "Cannot be empty.")
        }
        if !firstChar.isLetter {
            throw ParserErrors.malformedValue(reason: "Must start with a letter.")
        }
        if lastChar == "_" {
            throw ParserErrors.malformedValue(reason: "Must not end with an underscore.")
        }
        try namespace.dropFirst().forEach {
            if !$0.isLetter && !$0.isNumber && $0 != "_" {
                throw ParserErrors.malformedValue(reason: "Must only contain letters, numbers and underscores.")
            }
        }
        return CNamespace(self.helpers.toSnakeCase(namespace))
    }
    
    public func parseCPPNamespace(_ str: String) throws -> CPPNamespace {
        let namespace = str.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstChar = namespace.first, let lastChar = namespace.last else {
            throw ParserErrors.malformedValue(reason: "Cannot be empty.")
        }
        if !firstChar.isLetter {
            throw ParserErrors.malformedValue(reason: "Must start with a letter.")
        }
        
        if lastChar == "_" {
            throw ParserErrors.malformedValue(reason: "Must not end with an underscore.")
        }
        try namespace.dropFirst().forEach {
            if !$0.isLetter && !$0.isNumber && $0 != "_" {
                throw ParserErrors.malformedValue(reason: "Must only contain letters, numbers and underscores.")
            }
        }
        return CNamespace(self.helpers.toCamelCase(namespace))
    }
    
    public func cNamespace(of namespaces: [CNamespace]) -> String {
        namespaces.joined(separator: "_")
    }
    
    public func cppNamespace(of namespaces: [CPPNamespace]) -> String {
        namespaces.joined(separator: "::")
    }

    /**
     *  Convert a `CPPNamespace` to a `CNamespace`.
     *
     *  This function converts a camel case C++ style namespace, into its
     *  corresponding snake case C style representation.
     *
     *  - Parameter cppNamespace: The `CPPNamespace` which is being converted.
     *
     *  - Returns: The equivalent `CNamespace`.
     *
     *  - SeeAlso: `swift_helpers.StringHelpers.toSnakeCase(_:)`.
     */
    public func toCNamespace(cppNamespace: CPPNamespace) -> CNamespace {
        return CNamespace(self.helpers.toSnakeCase(String(cppNamespace)))
    }

    /**
     *  Convert a `CNamespace` to a `CPPNamespace`.
     *
     *  This function converts a snake case C style namespace, into its
     *  corresponding camel cased C++ style representation.
     *
     *  - Parameter cNamespace: The `CNamespace` which is being converted.
     *
     *  - Returns: The equivalent `CPPNamespace`.
     *
     *  - SeeAlso: `swift_helpers.StringHelpers.toCamelCase(_:)`.
     */
    public func toCPPNamespace(cNamespace: CNamespace) -> CPPNamespace {
        return CPPNamespace(self.helpers.toCamelCase(String(cNamespace)))
    }

}
