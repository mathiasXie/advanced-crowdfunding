// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


library MyMath {

    function add(uint256 a,uint256 b) public pure returns(uint256) {
        uint256 c = a + b;
        require(c > a , "error");
        return c;
    }

}

library ExternalLib {
    
    function add(uint256 a,uint256 b) external pure returns(uint256) {
        uint256 c = a + b;
        require(c > a , "error");
        return c;
    }
}

contract LibStudy {

    function add(uint256 a,uint256 b) public pure returns(uint256) {
        return MyMath.add(a, b);
    }

    using MyMath for uint256;

    function addWithUsing(uint256 a,uint256 b) public pure returns(uint256) {
        return a.add(b);
    }

    function addWithExt(uint256 a,uint256 b) public pure returns(uint256) {
        return ExternalLib.add(a, b);
    }
}