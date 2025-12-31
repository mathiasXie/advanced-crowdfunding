// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 注意：这是简化版本，实际使用时应导入 @openzeppelin/contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// 使用OpenZeppelin风格的代币合约
contract MyToken is ERC20, Ownable, Pausable {
    constructor() ERC20("My Token", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, 1000 * 10**decimals());
    }

    // 重写transfer函数，添加暂停功能
    function transfer(address to, uint256 amount) public override whenNotPaused returns (bool) {
        return super.transfer(to, amount);
    }

    // onlyOwner修饰符确保只有所有者可以调用
    function pause() public onlyOwner {
        _pause();
    }
    
    function unpause() public onlyOwner {
        _unpause();
    }
}