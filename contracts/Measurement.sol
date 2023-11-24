// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DeviceInterface{
    mapping (string => bool) public cpeInUse;
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

    /// Event declaration for Measurements
    event AddedDevice(address newDev,uint256 timestamp);
    event RemovedDevice(address removedDev,uint256 timestamp);

    event NewMeasurement(address indexed device,uint256 activeImport, uint256 activeExport,uint256 reactiveInductive,uint256 reactiveCapacitive, uint256 timestamp);

    ///Constructor
    constructor(address _deviceContract){
        /// Locate and Load Devices 
        deviceContract = DeviceInterface(_deviceContract);
    }

    ///Contract imports
    DeviceInterface deviceContract; 
    function setDeviceContractAddress(address _address) external onlyOwner{
        deviceContract = DeviceInterface(_address);
    }


    ///Code implementation
    function addDevice(address newDev) external onlyOwner{
        require(allowedDevices[newDev] == false, "This device is already authorized.");
        allowedDevices[newDev] = true;
        devices.push(newDev);
        emit AddedDevice(newDev, block.timestamp);
    }

    function removeDevice(address oldDevice) external onlyOwner{
        require(allowedDevices[oldDevice] == true, "This device is not registered.");
        delete allowedDevices[oldDevice];
        devices.pop(oldDevice);
        emit RemovedDevice(oldDevice, block.timestamp);
    }

    function insertMeasurement(uint256 _device, uint256 _activeImport, uint256 _activeExport, uint256 _reactiveInductive,uint256 _reactiveCapacitive) hasPermission( _device ){
        require(_activeImport >= deviceMeasurements[msg.sender][deviceMeasurements[msg.sender].length - 1].activeImport,"activeImport cannot be lower than previous measurement.")
        require(_activeExport >= deviceMeasurements[msg.sender][deviceMeasurements[msg.sender].length - 1].activeExport,"activeExport cannot be lower than previous measurement.")
        require(_reactiveInductive >= deviceMeasurements[msg.sender][deviceMeasurements[msg.sender].length - 1].reactiveInductive,"reactiveInductive cannot be lower than previous measurement.")
        require(_reactiveCapacitive >= deviceMeasurements[msg.sender][deviceMeasurements[msg.sender].length - 1].reactiveCapacitive,"reactiveCapacitive cannot be lower than previous measurement.")
        uint256 timestamp = block.timestamp;
        deviceMeasurements[msg.sender].push(Measurement(timestamp,_activeImport,_activeExport,_reactiveInductive,_reactiveCapacitive));
        emit NewMeasurement(msg.sender,_activeImport,_activeExport,_reactiveInductive,_reactiveCapacitive,timestamp);
    }



    modifier hasPermission(uint256 _device){
        address wallet;
        string memory cpe;
        bool enabled;
        (wallet,cpe,,,enabled) = deviceContract.getDevice( _device);
        require(enabled,"DEVICE NOT ENABLED");
        require(deviceContract.cpeInUse[cpe],"CPE NOT ENABLED");
        _;
    }


}

