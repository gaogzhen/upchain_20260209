// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop is Ownable {
    IERC20 public token;
    bytes32 public merkleRoot;

    // 记录已经领取过的地址
    mapping(address => bool) public hasClaimed;

    event SetMerkleRoot(bytes32 newMerkleRoot);
    event Claimed(address indexed account, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    /**
     * @dev 设置默克尔根
     */
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
        emit SetMerkleRoot(_merkleRoot);
    }

    /**
     * @dev 领取空头
     * @param amount 领取的代币数量
     * @param proof 默克尔证明 
     */
    function claim(uint256 amount, bytes32[] calldata proof) external {
        require(!hasClaimed[msg.sender], "Already claimed");
        require(verifyProof(msg.sender, amount, proof), "Invalid proof");

        hasClaimed[msg.sender] = true;
        token.transfer(msg.sender, amount);
        emit Claimed(msg.sender, amount);
    } 

    /**
     * @dev 验证默克尔证明
     * @param account 领取地址
     * @param amount 领取的代币数量
     * @param proof 默克尔证明
     * @return 验证结果
     */
    function verifyProof(address account, uint256 amount, bytes32[] calldata proof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(account, amount));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

    /**
     * @dev 提取剩余代币
     */
    function withdrawTokens() external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(owner(), balance), "Transfer failed");
    }
}
