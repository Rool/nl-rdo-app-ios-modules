/*
* Copyright (c) 2022 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import HTTPSecurityObjC

/// Security check for backend communication
public class CMSSignatureValidator: SignatureValidation {
	
	var trustedSigners: [SigningCertificate]
	let x509Validator = X509Validator()
	
	public init(trustedSigners: [SigningCertificate] = []) {
		
		self.trustedSigners = trustedSigners
	}
	
	/// Validate a CMS signature
	/// - Parameters:
	///   - signature: the signature to validate
	///   - content: the signed content
	/// - Returns: True if the signature is a valid CMS Signature
	///   See: https://en.wikipedia.org/wiki/Cryptographic_Message_Syntax
	public func validate(signature: Data, content: Data) -> Bool {
		
		for signer in trustedSigners {
			
			let certificateData = signer.getCertificateData()
			
			if let subjectKeyIdentifier = signer.subjectKeyIdentifier,
			   !x509Validator.validateSubjectKeyIdentifier(subjectKeyIdentifier, forCertificateData: certificateData) {
//				logError("validateSubjectKeyIdentifier(subjectKeyIdentifier) failed")
				return false
			}
			
			if let serial = signer.rootSerial,
			   !x509Validator.validateSerialNumber( serial, forCertificateData: certificateData) {
//				logError("validateSerialNumber(serial) is invalid")
				return false
			}
			
			if x509Validator.validateCMSSignature(
				signature,
				contentData: content,
				certificateData: certificateData,
				authorityKeyIdentifier: signer.authorityKeyIdentifier,
				requiredCommonNameContent: signer.commonName ?? "") {
				return true
			}
		}
		return false
	}
}

public struct SigningCertificate {

	/// The name of the certificate
	public let name: String

	/// The certificate
	public let certificate: String

	/// The required common name
	public var commonName: String?

	/// The required authority Key
	public var authorityKeyIdentifier: Data?

	/// The required subject key
	public let subjectKeyIdentifier: Data?

	/// The serial number
	public let rootSerial: UInt64?
	
	public init(name: String, certificate: String, commonName: String? = nil, authorityKeyIdentifier: Data? = nil, subjectKeyIdentifier: Data? = nil, rootSerial: UInt64? = nil) {
		self.name = name
		self.certificate = certificate
		self.commonName = commonName
		self.authorityKeyIdentifier = authorityKeyIdentifier
		self.subjectKeyIdentifier = subjectKeyIdentifier
		self.rootSerial = rootSerial
	}

	/// Get the certificate data
	/// - Returns: the certificate data
	public func getCertificateData() -> Data {

		return Data(certificate.utf8)
	}
}
