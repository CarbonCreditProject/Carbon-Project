pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './credittoken.sol';

//SPDX-License-Identifier: UNLICENSED
contract Certification is CreditToken {
    constructor() public { }
    string public constant _name = 'Gold Standard';
    string public constant _symbol = 'GS';
    
  mapping (uint => address) internal idToOwner;
  mapping (uint => address) internal idToApproval;
  mapping (address => uint) private ownerToNFTokenCount;
  mapping (address => uint) public burnedTokens;
  
  function addBurnedTokens(address holder) public {
    if (burnTokens() == true) {
        uint burnedtok = tokensApprovedForBurn[holder];
        burnedTokens[holder]+=burnedtok;
    }
  }

    function mint(address _to,uint256 _tokenId) internal virtual
  {
    require(_to != address(0), "ZERO_ADDRESS");
    require(idToOwner[_tokenId] == address(0), "NFT_ALREADY_EXISTS");
    require(burnedTokens[_to] > 20);

    _addNFToken(_to, _tokenId);

    emit Transfer(address(0), _to, _tokenId);
  }
  function _addNFToken(
    address _to,
    uint256 _tokenId
  )
    internal
    virtual
  {
    require(idToOwner[_tokenId] == address(0), "NFT_ALREADY_EXISTS");

    idToOwner[_tokenId] = _to;
    ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
  }
}
