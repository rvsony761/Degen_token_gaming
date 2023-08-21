// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
contract DegenToken {
    string public tokenname;
    string public tokensymbol;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        tokenname = "Degen";
        tokensymbol = "DGN";
        owner = msg.sender;
        
    }

    function transfer(address _sender, uint256 amount) external returns (bool success) {
        require(_sender != address(0), "Invalid recipient address");
        require(amount <= balanceOf[msg.sender], "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[_sender] += amount;

    
        return true;
    }
    

    function approve(address _user, uint256 amount) external returns (bool success) {
        require(_user != address(0), "Invalid spender address");

        allowance[msg.sender][_user] = amount;

        return true;
    }

    function transferFrom(address _sender, address _receiver, uint256 _amount) external returns (bool success) {
        require(_receiver != address(0), "Invalid recipient address");
        require(_amount <= balanceOf[_sender], "Insufficient balance");
        require(_amount <= allowance[_sender][msg.sender], "Insufficient allowance");

        balanceOf[_sender] -= _amount;
        balanceOf[_receiver] += _amount;
        allowance[_sender][msg.sender] -= _amount;

        return true;
    }

    function mint(address _atwhich, uint256 _amount) external onlyOwner returns (bool success) {
        require(_atwhich != address(0), "Invalid recipient address");

        balanceOf[_atwhich] += _amount;
        totalSupply += _amount;

        return true;
    }

    function redeem(uint256 _amount) external returns (bool success) {
        require(_amount <= balanceOf[msg.sender], "Insufficient balance");

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        return true;
    }
    function burn(uint256 _amount) external returns (bool success) {
        require(_amount <= balanceOf[msg.sender], "Insufficient balance");

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        return true;
    }
}
