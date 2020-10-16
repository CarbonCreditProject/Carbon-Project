pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './carboncredits.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

contract CreditToken is CarbonCredits,ERC20{
    uint totalsupply;
    uint supply;
    uint8 private _decimals;
    
    constructor() ERC20("Carbon", "C") public {
        _decimals = 0;
    }
    mapping(address => uint) public BalanceOf;
    mapping(address => uint) public approvedCredits;
    mapping(address => uint) public tokensApprovedForBurn;
    modifier onlyVerifier() {
        require(msg.sender == verifiers[verifiercount].addr);
        _;
    }
    modifier onlyCreditHolder() {
        require(msg.sender == CreditHolders[totalRegistered]._addr);
        _;
    }
    function approveCreditsHeld(address _holder) public onlyVerifier{
        uint cred = CreditHolders[totalRegistered].creditsHeld;
        approvedCredits[_holder]+= cred;
    }

    function createCarbonToken() public onlyCreditHolder() returns(uint) {
        address Owner = CreditHolders[totalRegistered]._addr;
        supply = approvedCredits[Owner];
        totalsupply = totalsupply.add(supply);
        BalanceOf[Owner] = BalanceOf[Owner].add(supply);
        _mint(msg.sender, supply);
        return totalsupply;
    }
    function transferCredits(address to, uint value) public onlyCreditHolder() {
        _transfer(msg.sender, to, value);
        BalanceOf[msg.sender] = BalanceOf[msg.sender].sub(value);
        BalanceOf[to] = BalanceOf[to].add(value);
    }
    function transferCreditsFrom(address from, address to, uint value) public {
        transferFrom(from, to, value);
        BalanceOf[from] = BalanceOf[from].sub(value);
        BalanceOf[to] = BalanceOf[to].add(value);
    }
    function approveBurn(uint carbonTokens, address holder) public onlyVerifier{
        tokensApprovedForBurn[holder]+=carbonTokens;
    }
    function burnTokens() public onlyOwner() {
        _burn(msg.sender, tokensApprovedForBurn[msg.sender]);
        totalsupply = totalsupply.sub(tokensApprovedForBurn[msg.sender]);
        BalanceOf[msg.sender] = BalanceOf[msg.sender].sub(tokensApprovedForBurn[msg.sender]);
    }
}
