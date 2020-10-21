pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

//SPDX-License-Identifier: UNLICENSED
contract CarbonCredits is Ownable {

uint totalRegistered = 0;
uint verifiercount=0;
uint customercount = 0;
struct CarbonCreditHolder {
    string name;
    uint id;
    uint holderId;
    uint creditsHeld;
    uint pricepercredit;
    uint creditvalidityperiod;
    address _addr;
}
struct verifier {
    string name;
    string homeCountry;
    uint reg_no;
    uint license_no;
    address addr;
    bool isExist;
}
struct customer {
    string first_name;
    string last_name;
    string email;
    uint contact;
    uint _id;
}
mapping (uint => CarbonCreditHolder) public CreditHolders;
mapping (uint => verifier) public verifiers;
mapping(uint => customer) public customers;


event newCreditHolder(string name, uint holderId, uint creditsHeld, uint pricepercredit, uint creditvalidityperiod, address _addr);

function registerCreditHolder(string memory name, uint holderId, uint creditsHeld, uint pricepercredit, uint creditvalidityperiod) public {
    totalRegistered++;
    CreditHolders[totalRegistered] = CarbonCreditHolder(
        name,
        totalRegistered,
        holderId,
        creditsHeld,
        pricepercredit,
        creditvalidityperiod,
        msg.sender);
    emit newCreditHolder(name, holderId, creditsHeld, pricepercredit,creditvalidityperiod, msg.sender);
}
function registerVerifiers(string memory name, string memory homeCountry, uint reg_no, uint license_no) public {
        verifiercount++;
        // check if verifier exist already
        require(verifiers[reg_no].isExist==false, "validator already registered");
        // require(license_no == ISO database, "you dont have a license to operate");
        verifiers[verifiercount]=verifier(name,homeCountry,reg_no,license_no,msg.sender,true);
}
function registerCustomer(string memory first_name, string memory last_name, string memory email, uint contact) public{
    customercount++;
    customers[customercount] = customer(
        first_name,
        last_name,
        email,
        contact,
        customercount);
}
function getVerifiers() public view returns (verifier[] memory){
    verifier[] memory ret = new verifier[](verifiercount);
    for (uint i = 0; i < verifiercount; i++) {
        ret[i] = verifiers[i];
    }
    return ret;
}
function getCreditHoilders() public view returns (CarbonCreditHolder[] memory){
    CarbonCreditHolder[] memory ret = new CarbonCreditHolder[](verifiercount);
    for (uint i = 0; i < totalRegistered; i++) {
        ret[i] = CreditHolders[i];
    }
    return ret;
}
function getCustomerProfile(address _owner) public view onlyOwner() returns(customer[] memory) {
    _owner = msg.sender;
    customer[] memory result = new customer[](customercount);
    for (uint i = 0; i<customercount; i++){
        result[i] = customers[i];
    }
    return result;
}
  
}
