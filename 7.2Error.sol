// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ErrorExample {

    error InvalidX(uint256 x);

    function test(uint256 x) public pure {

        if(x < 10){
            revert InvalidX(x);
        }

    }
}