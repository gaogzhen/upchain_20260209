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
        string memory filePath = string.concat("deployments/address/", name, "_", chainId, ".json");
        vm.writeJson(finalJson, filePath);
    }

    /// @notice 将指定合约的 ABI 导出到 deployments/abi/<contractName>.json（标准 JSON 格式，需先 forge build，运行脚本时加 --ffi）
    function saveAbi(string memory contractName) public {
        string[] memory cmd = new string[](5);
        cmd[0] = "forge";
        cmd[1] = "inspect";
        cmd[2] = contractName;
        cmd[3] = "abi";
        cmd[4] = "--json";
        bytes memory result = vm.ffi(cmd);
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/deployments/abi/", contractName, ".json");
        vm.writeFile(path, string(result));
    }

    modifier broadcast() {
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

}