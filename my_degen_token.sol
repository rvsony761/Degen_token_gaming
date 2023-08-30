// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/Ownable.sol";
pragma solidity ^0.8.0;

contract DegenToken {
    string public tokenName;
    string public tokenSymbol;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => string[]) private _purchases;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        tokenName = "Degen";
        tokenSymbol = "DGN";
        owner = msg.sender;
    }

    function transfer(address _receiver, uint256 amount) external returns (bool success) {
        require(_receiver != address(0), "Invalid recipient address");
        require(amount <= balanceOf[msg.sender], "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[_receiver] += amount;

        emit Transfer(msg.sender, _receiver, amount);
        return true;
    }

    function approve(address _spender, uint256 amount) external returns (bool success) {
        require(_spender != address(0), "Invalid spender address");

        allowance[msg.sender][_spender] = amount;

        emit Approval(msg.sender, _spender, amount);
        return true;
    }

    function transferFrom(address _from, address _receiver, uint256 _amount) external returns (bool success) {
        require(_receiver != address(0), "Invalid recipient address");
        require(_amount <= balanceOf[_from], "Insufficient balance");
        require(_amount <= allowance[_from][msg.sender], "Insufficient allowance");

        balanceOf[_from] -= _amount;
        balanceOf[_receiver] += _amount;
        allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _receiver, _amount);
        return true;
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool success) {
        require(_to != address(0), "Invalid recipient address");

        balanceOf[_to] += _amount;
        totalSupply += _amount;

        emit Transfer(address(0), _to, _amount);
        return true;
    }

    function getPurchases(address account) public view returns (string[] memory) {
        return _purchases[account];
    }

    function redeem(string memory itemName, uint256 value) public {
        address sender = msg.sender;
        uint256 senderBalance = balanceOf[sender];
        require(senderBalance >= value, "Insufficient balance");

        balanceOf[sender] -= value;
        _purchases[sender].push(itemName);

        emit Transfer(sender, address(this), value);
    }

    function burn(uint256 _amount) external returns (bool success) {
        require(_amount <= balanceOf[msg.sender], "Insufficient balance");

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit Transfer(msg.sender, address(0), _amount);
        return true;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
