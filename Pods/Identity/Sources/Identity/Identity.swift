/**
 *  Identity
 *  Copyright (c) John Sundell 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import Foundation

// MARK: - Core API

/// Protocol used to mark a given type as being identifiable, meaning
/// that it has a type-safe identifier, backed by a raw value, which
/// defaults to String.
public protocol Identifiable {
    /// The backing raw type of this type's identifier.
    associatedtype RawRepresentation = String
    /// Shorthand type alias for this type's identifier.
    typealias ID = Identifier<Self>
    /// The ID of this instance.
    var id: ID { get }
}

/// A type-safe identifier for a given Entity, backed by a raw value.
/// When backed by a `Codable` type, `Identifier` also becomes codable,
/// and will be encoded into a single value according to its raw value.
public struct Identifier<Entity: Identifiable> {
    /// The raw value that is backing this identifier.
    public let rawValue: Entity.RawRepresentation

    /// Initialize an instance with a raw value.
    public init(rawValue: Entity.RawRepresentation) {
        self.rawValue = rawValue
    }
}

// MARK: - Integer literal support

extension Identifier: ExpressibleByIntegerLiteral
          where Entity.RawRepresentation: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Entity.RawRepresentation.IntegerLiteralType) {
        rawValue = .init(integerLiteral: value)
    }
}

// MARK: - String literal support

extension Identifier: ExpressibleByUnicodeScalarLiteral
          where Entity.RawRepresentation: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Entity.RawRepresentation.UnicodeScalarLiteralType) {
        rawValue = .init(unicodeScalarLiteral: value)
    }
}

extension Identifier: ExpressibleByExtendedGraphemeClusterLiteral
          where Entity.RawRepresentation: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: Entity.RawRepresentation.ExtendedGraphemeClusterLiteralType) {
        rawValue = .init(extendedGraphemeClusterLiteral: value)
    }
}

extension Identifier: ExpressibleByStringLiteral
          where Entity.RawRepresentation: ExpressibleByStringLiteral {
    public init(stringLiteral value: Entity.RawRepresentation.StringLiteralType) {
        rawValue = .init(stringLiteral: value)
    }
}

// MARK: - Compiler-generated protocol support

extension Identifier: Equatable where Entity.RawRepresentation: Equatable {}
extension Identifier: Hashable where Entity.RawRepresentation: Hashable {}

// MARK: - Codable support

extension Identifier: Codable where Entity.RawRepresentation: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Entity.RawRepresentation.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
