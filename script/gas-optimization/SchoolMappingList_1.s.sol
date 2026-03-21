// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "../BaseScript.s.sol";
import {SchoolMappingList} from "../../src/gas-optimization/SchoolMappingList.sol";

contract SchoolMappingListScript is BaseScript {
    SchoolMappingList public schoolMappingList;

    function run() public broadcast {
        saveAbi("SchoolMappingList");
        schoolMappingList = new SchoolMappingList();
        saveContract("SchoolMappingList", address(schoolMappingList));
    }
}
