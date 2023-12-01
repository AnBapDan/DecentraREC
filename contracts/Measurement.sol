// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

interface DeviceInterface{
    function isCPEUsed(string memory cpe) external view returns (bool);
    function getDevice(uint256 _device) external view returns (address wallet, string memory cpe, uint maxBuyPrice,uint minSellPrice, bool enabled);
}

contract MeasurementFactory is Ownable{

    ///Structure definition
    struct Measurement {
        uint256 timestamp;
        uint256 activeImport;
        uint256 activeExport;
        uint256 reactiveInductive;
        uint256 reactiveCapacitive;
    }

    uint256 interval = 15 minutes;

    mapping( address => Measurement ) latestMeasurement;

    /// Event declaration for Measurements
    event NewMeasurement(address indexed device,uint256 activeImport, uint256 activeExport,uint256 reactiveInductive,uint256 reactiveCapacitive, uint256 timestamp);

    ///Constructor
    constructor(address _deviceContract) Ownable(msg.sender){
        /// Locate and Load Devices 
        deviceContract = DeviceInterface(_deviceContract);
    }

    ///Contract imports
    DeviceInterface deviceContract; 
    function setDeviceContractAddress(address _address) external onlyOwner{
        deviceContract = DeviceInterface(_address);
    }

    function insertMeasurement(uint256 _device, uint256 _activeImport, uint256 _activeExport, uint256 _reactiveInductive,uint256 _reactiveCapacitive) external hasPermission( _device ){
        require(_activeImport >= latestMeasurement[msg.sender].activeImport,"activeImport cannot be lower than previous measurement.");
        require(_activeExport >= latestMeasurement[msg.sender].activeExport,"activeExport cannot be lower than previous measurement.");
        require(_reactiveInductive >= latestMeasurement[msg.sender].reactiveInductive,"reactiveInductive cannot be lower than previous measurement.");
        require(_reactiveCapacitive >= latestMeasurement[msg.sender].reactiveCapacitive,"reactiveCapacitive cannot be lower than previous measurement.");
        uint256 timestamp = _roundToNearestInterval(block.timestamp);
        //need to verify timestamp += interval and create bid
        emit NewMeasurement(msg.sender,_activeImport,_activeExport,_reactiveInductive,_reactiveCapacitive,timestamp);
        latestMeasurement[msg.sender] = Measurement(timestamp,_activeImport,_activeExport,_reactiveInductive,_reactiveCapacitive);
    }



    modifier hasPermission(uint256 _device){
        address wallet;
        string memory cpe;
        bool enabled;
        (wallet,cpe,,,enabled) = deviceContract.getDevice( _device);
        require(enabled,"DEVICE NOT ENABLED");
        require(deviceContract.isCPEUsed(cpe),"CPE NOT ENABLED");
        _;
    }

    function setInterval(uint256 newInterval) external onlyOwner{
        interval = newInterval;
    }

    function _roundToNearestInterval(uint256 timestamp) private view returns (uint256) {
        // Calculate the number of seconds past the last midnight
        uint256 secondsSinceMidnight = timestamp % 1 days;

        uint256 remainder = secondsSinceMidnight % interval;

        bool roundUp = remainder > (interval/ 2); 

        uint256 roundedTimestamp;
        if (roundUp) {
            roundedTimestamp = timestamp + (interval - remainder);
        } else {
            roundedTimestamp = timestamp - remainder;
        }

        return roundedTimestamp;
    }
}

