// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract InsureX is IERC20 {
    string public name = "InsureX";
    string public symbol = "IsX";
    uint8 public decimals = 18;
    uint256 public override totalSupply;
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;
    
    uint256 constant tokenPrice = 0.001 ether;
    uint256 constant initialSupply = 1000000 * 10 **18;
    
    constructor() {
        totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }
    
    function buyTokens() public payable {
        uint256 amount = msg.value / tokenPrice;
        require(amount > 0, "Insufficient amount");
        require(amount <= balanceOf[address(this)], "Not enough tokens in contract");
        balanceOf[address(this)] -= amount;
        balanceOf[msg.sender] += amount;
        emit Transfer(address(this), msg.sender, amount);
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");
        _transfer(sender, recipient, amount);
        allowance[sender][msg.sender] -= amount;
        return true;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(balanceOf[sender] >= amount, "Insufficient balance");
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }
}