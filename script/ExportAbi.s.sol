// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./BaseScript.s.sol";

/// @notice 仅导出合约 ABI 到 deployments/abi/
/// 用法: forge build && forge script script/ExportAbi.s.sol --ffi
contract ExportAbi is BaseScript {
    function setUp() public override {
        // 仅导出 ABI 时不依赖 PRIVATE_KEY，避免未设置时 revert
        deployerPrivateKey = 0;
    }

    function run() public {
        saveAbi("Counter");
        // 新增合约时在此追加: saveAbi("YourContract");
    }
}
