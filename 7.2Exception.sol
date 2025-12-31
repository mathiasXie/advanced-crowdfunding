// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "7.2Callee.sol";

contract Caller {
    Callee public callee;

    constructor(address _callee) {
        callee = Callee(_callee);
    }

    function testOk() external view returns (uint256) {
        try callee.ok() returns (uint256 v) {
            return v;
        } catch {
            return 0;
        }
    }

    function testRequireError() external view returns (string memory) {
        try callee.failWithRequire() {
            return "success";
        } catch Error(string memory reason) {
            // 捕获 require / revert(string)
            return reason;
        } catch {
            return "unknown error";
        }
    }

    function testCustomError() external view returns (uint256) {
        try callee.failWithCustomError() {
            return 0;
        } catch (bytes memory lowLevelData) {
            // 自定义 error 只能这样接
            bytes4 selector;
            assembly {
                selector := mload(add(lowLevelData, 32))
            }

            if (selector == CustomError.selector) {
                uint256 code;
                assembly {
                    code := mload(add(lowLevelData, 36))
                }
                return code;
            }

            return 9999;
        }
    }

    function testPanic() external view returns (uint256) {
        try callee.failWithPanic() {
            return 0;
        } catch Panic(uint256 code) {
            // assert / overflow / divide by zero
            return code;
        }
    }
}