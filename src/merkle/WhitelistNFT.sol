// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WhitelistNFT is ERC721, Ownable {
    using Strings for uint256;

    bytes32 public _merkleRoot;
    string private _baseTokenURI;

    // record total supply and next token ID for minting
    uint256 private _totalSupply;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MINT_PRICE = 0.01 ether;

    mapping(address => bool) public hasMinted;

    event SetMerkleRoot(bytes32 newMerkleRoot);
    event NFTMinted(address indexed to, uint256 tokenId);
    event BatchMinted(address[] recipients, uint256[] tokenIds);

    constructor(
        string memory baseURI
        // 移除了 initialContractURI 参数
    ) ERC721("WhitelistNFT", "WNFT") Ownable(msg.sender) {
        _baseTokenURI = baseURI;
    }

    /**
     * @dev Sets the Merkle root. Only callable by the owner.
     * @param newMerkleRoot The new Merkle root to set.
     */
    function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
        _merkleRoot = newMerkleRoot;
        emit SetMerkleRoot(newMerkleRoot);
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
    }

    /**
     * @dev Mints an NFT for a whitelisted address.
     * @param proof The Merkle proof for the sender's address.
     */
    function mint(bytes32[] calldata proof) external payable {
        require(!hasMinted[msg.sender], "Already minted");
        require(_totalSupply < MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= MINT_PRICE, "Insufficient payment");
        require(verifyProof(proof), "Invalid proof");

        hasMinted[msg.sender] = true;
        _safeMint(msg.sender, _totalSupply);
        emit NFTMinted(msg.sender, _totalSupply);
        _totalSupply++;
    }

    /**
     * @dev Mints NFTs for multiple whitelisted addresses.
     * @param recipients The addresses of the recipients.
     */
    function batchMint(address[] memory recipients) external onlyOwner {
        require(recipients.length > 0, "No recipients");
        require(
            _totalSupply + recipients.length <= MAX_SUPPLY,
            "Exceeds max supply"
        );

        uint256[] memory tokenIds = new uint256[](recipients.length);

        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            require(!hasMinted[recipient], "Recipient already minted");
            hasMinted[recipient] = true;
            tokenIds[i] = _totalSupply;
            _safeMint(recipient, _totalSupply);
            _totalSupply++;
        }
        emit BatchMinted(recipients, tokenIds);
    }

    /**
     * @dev Withdraws the contract's balance to the owner's address. Only callable by the owner.
     */
    function withdraw() external onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    /**
     * @dev Verifies the Merkle proof for the sender's address.
     * @param proof The Merkle proof to verify.
     * @return True if the proof is valid, false otherwise.
     */
    function verifyProof(bytes32[] calldata proof) internal view returns (bool) {
        return MerkleProof.verify(proof, _merkleRoot, keccak256(abi.encodePacked(msg.sender)));
    }

    /**
     * @dev Returns the URI for a given token ID.
     * @param tokenId The token ID for which to return the URI.
     * @return The URI for the specified token ID.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // 使用 ownerOf 检查 Token 是否存在。如果不存在，此函数会自动 revert。
        ownerOf(tokenId);
        
        return
            bytes(_baseTokenURI).length > 0
                ? string(abi.encodePacked(_baseTokenURI, tokenId.toString(), ".json"))
                : "";
    }

    /**
     * @dev Returns the total supply of NFTs.
     * @return The total supply of NFTs.
     */
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
}