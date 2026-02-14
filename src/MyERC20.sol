// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 定义接受代币的接口
interface ITokenReceiver {
    function tokenReceived(address from, address to, uint256 amount, bytes calldata data) external;
}

contract MyERC20 is ERC20 {
    constructor() ERC20("MyERC20", "MET") {
        _mint(msg.sender, 1000000000000000000000000);
    }

    /**
     * @dev 带回调的转账
     * @param to 接收者地址
     * @param amount 转账数量
     * @param data 回调数据
     * @return 是否成功
     */
    function transferWithCallback(address to, uint256 amount, bytes calldata data) public returns (bool) {
        _transfer(msg.sender, to, amount);
        if (to.code.length > 0) {
            ITokenReceiver(to).tokenReceived(msg.sender, to, amount, data);
        }
        return true;
    }
}