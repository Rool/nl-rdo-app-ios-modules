/*
* Copyright (c) 2022 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

public enum CorrectionLevel: String {
	
	case low = "L" // 7% of data bytes can be restored.
	case medium = "M" // 15% of data bytes can be restored.
	case quartile = "Q" // 25% of data bytes can be restored.
	case high = "H" // 30% of data bytes can be restored.
}

extension Data {

	/// Generate a QR image
	/// - Returns: QR image of the data
	func generateQRCode(correctionLevel: CorrectionLevel = .medium) -> UIImage? {

		if let filter = CIFilter(name: "CIQRCodeGenerator") {
			filter.setValue(self, forKey: "inputMessage")
			filter.setValue(correctionLevel.rawValue, forKey: "inputCorrectionLevel")
			let transform = CGAffineTransform(scaleX: 3, y: 3)

			if let output = filter.outputImage?.transformed(by: transform) {
				return UIImage(ciImage: output)
			}
		}
		return nil
	}
}
