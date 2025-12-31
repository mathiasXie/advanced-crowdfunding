// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Voting is Ownable {

    using Strings for string;

    mapping (string => uint256) votes;

    mapping (address => bool) voteMapping;

    string[] candidates;
    address[] voters;

    constructor() Ownable(msg.sender) {}

    //一个vote函数，允许用户投票给某个候选人
    function vote(string memory candidate) public returns(bool) {
        require(!candidate.equal(""), "candidate cannot be empty");
        require(!voteMapping[msg.sender], "you already voted");
        
        if(votes[candidate] == 0){
            candidates.push(candidate);
        }
        if(!voteMapping[msg.sender]){
            voters.push(msg.sender);
        }
        voteMapping[msg.sender] = true;
        votes[candidate] += 1;
        return true;
    }

    //一个getVotes函数，返回某个候选人的得票数
    function getVotes(string memory candidate) public view returns(uint256) {
        return votes[candidate];
    }

    //一个resetVotes函数，重置所有候选人的得票数
    function resetVotes() public onlyOwner returns(bool) {

        uint256 candidateLen = candidates.length;
        for(uint256 i=0; i < candidateLen; i++){
            delete votes[candidates[i]];
        }
        uint256 voterLen = voters.length;
        for(uint256 i=0; i < voterLen; i++){
            delete voteMapping[voters[i]];
        }
        return true;
    }

}