// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeArray {


    function merge(uint256[] memory arr1, uint256[] memory arr2) public pure returns(uint256[] memory){

        uint256 arr1Len = arr1.length;
        uint256 arr2Len = arr2.length;

        uint256[] memory mergedArr = new uint256[](arr1Len + arr2Len);
        uint i = 0;
        uint j = 0;
        uint k = 0;

        while(i < arr1Len && j < arr2Len) {
            if(arr1[i] <= arr2[j]){
                mergedArr[k] = arr1[i];
                i++;
            }else {
                mergedArr[k] = arr2[j];
                j++;
            }
            k++;
        }

        while(i < arr1Len) {
            mergedArr[k] = arr1[i];
            i++;
            k++;
        }

        while(j < arr2Len) {
            mergedArr[k] = arr2[j];
            j++;
            k++;
        }

        return mergedArr;
    }
}