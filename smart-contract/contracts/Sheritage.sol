pragma solidity 0.8.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "./FAMtoken.sol";

contract Sheritage is Ownable, FAMtoken{

    uint public periodTime;
    
    constructor(uint _periodeTime){
        periodTime = _periodeTime;
        super;
    }
    
    struct User {
      address userAddress;
      uint getPercent;
      uint addressCounter;
      bool initialized;
    }
    
    uint totalpercent;
    
    mapping (address => User) public userStructs;
    
    address[] userAddresses;
    
    modifier checkPeriod{
        require(block.timestamp >= periodTime, "Can't be release yet!");
        _;
    }
    
  function addUser(address _userAddress, uint _getPercent) public onlyOwner{
        require(!userStructs[_userAddress].initialized);
        totalpercent += _getPercent;
        require(totalpercent <= 100, '100% over');
    
        userStructs[_userAddress].userAddress = _userAddress;
        userStructs[_userAddress].getPercent = _getPercent;
        userStructs[_userAddress].addressCounter = 0;
        userStructs[_userAddress].initialized = true;
        userAddresses.push(_userAddress);
    }
    
    function getAllUsers() external view returns ( address[] memory) {
        return userAddresses;
    }
    
    function releaseAsset() external payable checkPeriod{
        uint alreadyReleasePercent = 0;
        
        for(uint i = 0; i < userAddresses.length ; i++){
            if(userStructs[userAddresses[i]].addressCounter == 1){
                alreadyReleasePercent += userStructs[userAddresses[i]].getPercent;
            }
        }
            
        require(userStructs[msg.sender].userAddress == msg.sender, 'Address need to be add fisrt!');
        require(userStructs[msg.sender].addressCounter == 0, 'Only Once!');
        _transfer(address(this), payable(msg.sender), balanceOf(address(this))*userStructs[msg.sender].getPercent/(100-alreadyReleasePercent)); 
        userStructs[msg.sender].addressCounter++;
    }
    
} 
