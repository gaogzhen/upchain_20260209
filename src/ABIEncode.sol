// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ABIEncode {
    function test(address _contract, bytes calldata data) external {
        (bool ok, ) = _contract.call(data);
        require(ok, "call failed");
    }

    function encodeWithSignature(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encode("transfer(address,uint256)", to, amount);
    }

    function encodeWithSelector(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encode(IERC20.transfer.selector, to, amount);
    }

    function encodeCall(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }

    function encodeParameter(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encode(to, amount);
    }
}
