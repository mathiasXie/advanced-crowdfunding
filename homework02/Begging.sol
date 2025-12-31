// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeggingContract {

    mapping (address => uint256) donations;

    address[] donationRanking;

    address public owner;
    uint256 public immutable deadline;

    constructor(uint256 _durationInDays){
        owner = msg.sender;
        deadline = block.timestamp + (_durationInDays * 1 days);

    }
    event Donation(address donor, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function donate() public payable returns(bool){
        require(msg.value > 0, "Donation must be greater than 0");
        require(block.timestamp <= deadline, "Donation has ended");

        donations[msg.sender] += msg.value;
        emit Donation(msg.sender, msg.value);
        _updateRanking(msg.sender);
        return true;
    }

    function _updateRanking(address donor) internal {

        uint256 rankingLen = donationRanking.length;
        uint rankingCount = 3;
        bool exists = false;
        if (!exists) {
            if (rankingCount < 3) {
                donationRanking.push(donor);
            } else {
                address third = donationRanking[rankingLen - 1];
                if (donations[donor] > donations[third]) {
                    donationRanking[rankingLen - 1] = donor;
                }
            }
        }
        for (uint256 i = 0; i < donationRanking.length; i++) {
            for (uint256 j = i + 1; j < donationRanking.length; j++) {
                if (
                    donations[donationRanking[j]] >
                    donations[donationRanking[i]]
                ) {
                    (donationRanking[i], donationRanking[j]) =
                        (donationRanking[j], donationRanking[i]);
                }
            }
        }

        if (donationRanking.length > 3) {
            donationRanking.pop();
        }
    }

    function withdraw() public payable onlyOwner returns (bool){

        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        payable(owner).transfer(balance);
        return true;
    }

    function getDonation(address donor) public view returns(uint256) {
        return donations[donor];
    }

    function getTop3() external view returns (address[] memory) {
        return donationRanking;
    }
}