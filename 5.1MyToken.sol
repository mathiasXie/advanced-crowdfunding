// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {

    string public name;
    string public sybol;
    uint8 public decimals;
    uint256 public totalSupply;

    bool public transferEnable;

    address public immutable owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowences;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _sybol, uint8 _decimals, uint256 _supplies) {
        name = _name;
        sybol = _sybol;
        decimals = _decimals;
        totalSupply = _supplies * 10**_decimals;

        transferEnable = true;
        owner = msg.sender;

        balanceOf[owner] = totalSupply;

        emit Transfer(address(0), owner, totalSupply);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "can not transfer to zero address");
        require(amount > 0, "invalid amount");
        require(balanceOf[msg.sender] >= amount, "insuffcient balance");

        balanceOf[to] += amount;
        balanceOf[msg.sender] -= amount;

        emit  Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "can not approve to zero address");
        require(amount > 0, "invalid amount");

        allowences[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "from cannot be zero address");
        require(to != address(0), "to cannot be zero address");
        require(balanceOf[from] >= amount, "insuffcient balance");
        require(allowences[from][msg.sender] >= amount, "insuffcient allowence");

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowences[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function showMyBalance() public view returns (uint256) {
        return balanceOf[msg.sender];
    }

    function mint(address to, uint256 amount) public returns(bool){
        require(msg.sender == owner, "only the owner can mint tokens");
        require(to != address(0), "to cannot be zero address");
        require(amount > 0, "invalid amount");

        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
        return true;
    }

    function burn(uint256 amount) public returns(bool) {
        require(amount > 0, "invalid amount");
        require(balanceOf[msg.sender] >= amount, "insuffcient balance to burn");

        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

}