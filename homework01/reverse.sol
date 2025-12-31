// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ReverseString {

    function reverse(string memory _str) public pure returns(string memory) {

        bytes memory strBytes = bytes(_str);
        
        string memory reversedStr = new string(strBytes.length);
        bytes memory reversedBytes = bytes(reversedStr);

        for (uint i = 0; i < strBytes.length; i++) {
            reversedBytes[i] = strBytes[strBytes.length - 1 - i];
        }
        return string(reversedBytes);
    }
}