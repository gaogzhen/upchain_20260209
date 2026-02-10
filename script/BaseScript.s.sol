// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";

abstract contract BaseScript is Script {
    address internal deployer;
    address internal user;
    string internal mnemonic;
    uint256 internal deployerPrivateKey;

    function setUp() public virtual {
        // mnemonic = vm.envString("MNEMONIC");
        // (deployer,) = deriveRememberKey(mnemonic, 0);

        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // user = vm.addr(deployerPrivateKey);
    }

    function saveContract(string memory name, address contractAddress) public {
        string memory chainId = vm.toString(block.chainid);

        string memory finalJson = vm.serializeAddress("key", "address", contractAddress);
        string memory filePath = string.concat("deployments/", name, "_", chainId, ".json");
        vm.writeJson(finalJson, filePath);
    }   

    modifier broadcast() {
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

}