# LunhCheck

A description of this package.



Introduction



Installation



Usage

```swift
import LunhCheck

let validAlphabet = "BCFGJLQRSTUVXYZ23456789"
let checker = LuhnCheck(alphabet: validAlphabet)

checker.luhnModN("2SX4XLGGXUB6V94") // true
checker.luhnModN("2SX4XLGGXUB6V84") // false (invalid token)
checker.luhnModN("ASX4XLGGXUB6V94") // false (invalid char not in validAlphabet)

```

License

License is released under the EUPL 1.2 license. [See LICENSE](https://github.com/minVWS/nl-papatoki-lunhcheck-ios/blob/master/LICENSE.txt) for details.

Credits

