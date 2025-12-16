// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract crowdfunding {

    enum State {
        Fundraising, // 募资中
        Successed,   // 成功
        Failed,      // 失败
        Withdraw     // 已提现
    }

    address public immutable owner;
    uint256 public immutable goalAmount;
    uint256 public immutable deadline;
    uint256 public constant MIN_CONTRIBUTION = 0.1 ether;

    State public currentState;
    mapping(address => uint256) public contributions;
    uint256 public currentRaiseAmount;

    constructor(uint256 _goalAmount, uint256 _durationInDays){
        owner = msg.sender;
        goalAmount = _goalAmount;

        deadline = block.timestamp + (_durationInDays * 1 days);
        //deadline = block.timestamp + (_durationInDays * 1 minutes);

        currentState = State.Fundraising;
    }

    modifier _ownerChecker {
        require(msg.sender == owner, "only owner can call this function");
        _;
    }
    modifier stateChecker(State _state) {
        if(deadline < block.timestamp && currentState == State.Fundraising && currentRaiseAmount < goalAmount){
            currentState = State.Failed;
        }
        require(_state == currentState, "invalid state for this operation");
        _;
    }

    event StateChange(State _state);
    event ContributionReceived(address sender,uint256 value,uint256 currentAmount);
    event FundsWithDraw(uint256 amount,address owner,uint256 timestamp);
    event RefundIssue(uint256 amount,address refunder,uint256 timestamp);

    function contribute() public payable stateChecker(State.Fundraising) {
        require(msg.value >= MIN_CONTRIBUTION,"contribution must be at least MIN_CONTRIBUTION");
        require(block.timestamp <= deadline, "contribution already ended");

        contributions[msg.sender] += msg.value;
        currentRaiseAmount += msg.value;

        if(currentRaiseAmount >= goalAmount) {
            currentState = State.Successed;
            emit StateChange(currentState);
        }
        emit ContributionReceived(msg.sender, msg.value, currentRaiseAmount);
    }

    function withDraw() public payable _ownerChecker stateChecker(State.Successed) {

        currentState = State.Withdraw;
        emit StateChange(currentState);

        uint256 amount = currentRaiseAmount;
        (bool success,) = payable(owner).call{value:amount}("");
        require(success, "withdraw failed");
        emit FundsWithDraw(amount,owner,block.timestamp);
    }

    function refund() public payable  stateChecker(State.Failed) {

        uint256 contributionAmount = contributions[msg.sender];
        require(contributionAmount > 0, "contribution not found");

        contributions[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value:contributionAmount}("");
        require(success,"refund failed");

        emit RefundIssue(contributionAmount,msg.sender,block.timestamp);
    }

    function getState() public view returns(State){
        if(currentState == State.Fundraising && deadline < block.timestamp){
            if(currentRaiseAmount >= goalAmount){
                return State.Successed;
            }else{
                return State.Failed;
            }
        }
        return currentState;
    }
}