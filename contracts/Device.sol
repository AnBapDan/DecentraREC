// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract DeviceFactory{

    struct Device {
        address wallet;
        string cpe;
        uint maxBuyPrice;
        uint minSellPrice;
        bool enabled;
    }

    Device[] public devices;

    mapping (uint => address) public deviceToOwner;
    mapping (string => bool) public cpeInUse;
    mapping (address => uint8) ownerDeviceCount;


    event NewDevice(address indexed deviceOwner, string indexed cpe, uint deviceId, uint timestamp);
    event DeleteDevice(address indexed deviceOwner, string indexed cpe, uint deviceId, uint timestamp);
    event UpdatedPriceDevice(uint indexed deviceId, uint256 newBuyPrice, uint256 newSellPrice, uint timestamp);

    function createDevice(address _wallet, string memory _cpe, uint _maxBuyPrice, uint _minSellPrice) external {

        require(cpeInUse[_cpe] == false, "CPE ALREADY IN USE");
        require(ownerDeviceCount[msg.sender]<=255, "DEVICE LIMIT ACHIEVED");

        devices.push(Device(_wallet, _cpe, _maxBuyPrice, _minSellPrice, true));
        uint deviceId = devices.length - 1;
        deviceToOwner[deviceId] = msg.sender;
        ownerDeviceCount[msg.sender]++;   
        cpeInUse[_cpe] = true;

        emit NewDevice(msg.sender, _cpe, deviceId ,block.timestamp);

    }

    function deleteDevice(uint256 _removeDevice) external {
        require(_removeDevice <= devices.length -1 , " ID OUT OF BOUNDS");
        require(deviceToOwner[_removeDevice] == address(0), "Device does not exists.");
        require(deviceToOwner[_removeDevice] == msg.sender, "This is not your device. Oops...");

        delete deviceToOwner[_removeDevice];
        Device storage beingDisabled = devices[_removeDevice];
        beingDisabled.enabled = false;
        ownerDeviceCount[msg.sender]--;

        emit DeleteDevice(msg.sender, beingDisabled.cpe , _removeDevice, block.timestamp);
    }

    function getDevice(uint256 _device) external view returns (address wallet, string memory cpe, uint maxBuyPrice,uint minSellPrice, bool enabled){
        Device memory dev = devices[_device];
        return (dev.wallet, dev.cpe, dev.maxBuyPrice, dev.minSellPrice, dev.enabled);
    }

    function updateDevicePrice(uint256 _deviceId, uint256 _newBuyPrice, uint256 _newSellPrice) external {

        require(_deviceId <= devices.length -1 , " ID OUT OF BOUNDS");
        require(deviceToOwner[_deviceId] == msg.sender, "This is not your device. Oops...");


        emit UpdatedPriceDevice(_deviceId, _newBuyPrice, _newSellPrice, block.timestamp);
    }
}