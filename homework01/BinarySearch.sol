// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BinarySearch {


    function search(uint256[] memory arr, uint256 target) public pure returns (uint){

        if (arr.length == 0) {
            return type(uint256).max;
        }

        uint256 left = 0;
        uint256 right = arr.length - 1;

        while (left <= right) {
            uint256 mid = left + (right - left) / 2;

            if (arr[mid] == target) {
                return mid;
            }

            if (arr[mid] < target) {
                left = mid + 1;
            } else {
                if (mid == 0) {
                    break; // 防止 right = mid - 1 下溢
                }
                right = mid - 1;
            }
        }

        return type(uint256).max;
    }

}