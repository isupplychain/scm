pragma solidity ^0.4.24;
// 数字钱包
contract Token {
    address issuer;
    mapping (address => uint) balances;
    mapping(address => bool) whiteList;
    
    uint CODE_SUCCESS = 3300;
    uint CODE_INSUFFICIENT_BALANCE = 3401;
    uint CODE_INSUFFICIENT_PERMISSION = 3402;
    uint CODE_INVALID_PARAMS = 3600;
    uint OPT_ADD_WHITELIST = 3501;
    uint OPT_REMOVE_WHITELIST = 3502;
   
    constructor() public {
        issuer = msg.sender;
        whiteList[issuer] = true;
    }
    function issue(address account, uint amount) public returns(uint) {
        if (msg.sender != issuer) return CODE_INSUFFICIENT_PERMISSION;
        balances[account] += amount;
        return CODE_SUCCESS;
    }
    function transfer(address to, uint amount) public returns(uint) {
        if (balances[msg.sender] < amount) return CODE_INSUFFICIENT_BALANCE;
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return CODE_SUCCESS;
    }
    function getBalance(address account) public view returns (uint, uint) {
        if(!whiteList[msg.sender]) {
            return (CODE_INSUFFICIENT_PERMISSION, CODE_INSUFFICIENT_PERMISSION);
        }
        return (CODE_SUCCESS, balances[account]);
    }
    function updateWhiteList(address account,uint opt) public returns(uint) {
        if (msg.sender != issuer) return CODE_INSUFFICIENT_PERMISSION;
        if(opt == OPT_ADD_WHITELIST) {
            whiteList[account] = true;
        } else if(opt == OPT_REMOVE_WHITELIST) {
            whiteList[account] = false;
        } else {
            return CODE_INVALID_PARAMS;
        }
        return CODE_SUCCESS;
    }
}
