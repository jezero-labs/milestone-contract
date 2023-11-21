// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MileNFT is ERC721, ERC721Enumerable, ERC721URIStorage {
    address private _owner;
    uint256 private _nextTokenId;
    uint256 private _basePrice = 5e15; // 0.005 ETH in wei

    struct NFTData {
        string geography;
        string location;
        string geoTag;
        string user;
        string title;
        string description;
        string cover;
        uint256 randomNumber;
    }

    mapping(uint256 => NFTData) private _nftData;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "MileNFT: caller is not the owner");
        _;
    }

    function safeMint(
        string memory uri,
        NFTData memory nftData
    ) public payable {
        require(msg.value >= _basePrice, "MileNFT: Insufficient funds");

        uint256 tokenId = _getNextTokenId();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
        _nftData[tokenId] = nftData;
    }

    function getNFTData(uint256 tokenId) public view returns (NFTData memory) {
        return _nftData[tokenId];
    }

    function getNextTokenId() public view returns (uint256) {
        return _getNextTokenId();
    }

    function _getNextTokenId() private view returns (uint256) {
        return _nextTokenId;
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
