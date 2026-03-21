// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract StorageCompact {
    uint8 x;
    uint8 y;

    function foo() public {
        x = 1;
        y = 2;
    }
}
