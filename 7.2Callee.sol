// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error CustomError(uint256 code);

contract Callee {
    function ok() external pure returns (uint256) {
        return 42;
    }

    function failWithRequire() external pure {
        require(false, "require failed");
    }

    function failWithCustomError() external pure {
        revert CustomError(1001);
    }

    function failWithPanic() external pure {
        assert(false); // 会触发 Panic(uint256)
    }
}