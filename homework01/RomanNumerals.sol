// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RomanNumerals {

    /* 整数 转 罗马数字 */
    function intToRoman(uint256 num) public pure returns (string memory) {
        require(num > 0 && num < 4000, "out of range");

        uint256[13] memory values = [
            uint256(1000), 900, 500, 400,
            100, 90, 50, 40,
            10, 9, 5, 4,
            1
        ];

        string[13] memory symbols = [
            "M", "CM", "D", "CD",
            "C", "XC", "L", "XL",
            "X", "IX", "V", "IV",
            "I"
        ];

        bytes memory result;

        for (uint256 i = 0; i < values.length; i++) {
            while (num >= values[i]) {
                num -= values[i];
                result = abi.encodePacked(result, symbols[i]);
            }
        }

        return string(result);
    }

    /* 罗马数字 转 整数 */
    function romanToInt(string memory s) public pure returns (uint256) {
        bytes memory b = bytes(s);
        require(b.length > 0, "empty string");

        uint256 total = 0;
        uint256 i = 0;

        while (i < b.length) {
            uint256 curr = _value(b[i]);

            if (i + 1 < b.length) {
                uint256 next = _value(b[i + 1]);
                if (curr < next) {
                    total += (next - curr);
                    i += 2;
                    continue;
                }
            }

            total += curr;
            i++;
        }

        require(total > 0 && total < 4000, "invalid roman");
        return total;
    }

    /* ========== 单字符映射 ========== */
    function _value(bytes1 c) internal pure returns (uint256) {
        if (c == "I") return 1;
        if (c == "V") return 5;
        if (c == "X") return 10;
        if (c == "L") return 50;
        if (c == "C") return 100;
        if (c == "D") return 500;
        if (c == "M") return 1000;
        revert("invalid roman char");
    }
}
