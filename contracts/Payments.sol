// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

interface DeviceInterface{
    function isCPEUsed(string memory cpe) external view returns (bool);
    function getDevice(uint256 _device) external view returns (address wallet, string memory cpe, uint maxBuyPrice,uint minSellPrice, bool enabled);
}

contract Payments is Ownable{

    event NewPayment(uint64 indexed id, address indexed buyer, address indexed seller, uint16 wh, uint256 totalPrice, uint timestamp);
    event ConfirmedPayment(uint64 indexed id, address buyer, address seller);

    struct Payment{
        uint64 id;
        address buyer;
        address seller;
        uint16 wh;
        uint256 totalPrice;
        uint timestamp;
    }

    ///Contract imports
    DeviceInterface deviceContract; 
    function setDeviceContractAddress(address _address) external onlyOwner{
        deviceContract = DeviceInterface(_address);
    }

    constructor(address _deviceContract) Ownable(msg.sender){
        /// Locate and Load Devices 
        deviceContract = DeviceInterface(_deviceContract);
    }


    function insertPayment(Payment[] memory _incomingPayments) external onlyOwner{        
        for(uint16 i = 0; i< _incomingPayments.length; i++){
            Payment memory beingEmitted = _incomingPayments[i];
            emit NewPayment(beingEmitted.id,beingEmitted.buyer,beingEmitted.seller, beingEmitted.wh, beingEmitted.totalPrice, beingEmitted.timestamp);
        }   
    }

    address wallet;
    function confirmPayment(uint256 _device, Payment calldata _confirmedPayment) external hasPermission(_device){
        require(wallet == msg.sender, "You are not allowed to confirm this payment");
        emit ConfirmedPayment(_confirmedPayment.id, msg.sender, _confirmedPayment.seller);

    }

    modifier hasPermission(uint256 _device){
        string memory cpe;
        bool enabled;
        (wallet,cpe,,,enabled) = deviceContract.getDevice( _device);
        require(enabled,"DEVICE NOT ENABLED");
        require(deviceContract.isCPEUsed(cpe),"CPE NOT ENABLED");
        _;
    }
}