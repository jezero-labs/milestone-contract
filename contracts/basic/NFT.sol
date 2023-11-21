// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MilestoneNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    uint256 private _basePrice = 0.005 ether;
    uint256 private _currentStakedAmount;

    struct NFTData {
        string geography;
        string location;
        string geoTag;
        string user;
        string title;
        string description;
        string cover;
        uint256 randomNumber;
        uint256 stakedAmount;
    }

    mapping(uint256 => NFTData) public nftData;
    mapping(address => uint256) public stakers;

    constructor(
        address initialOwner
    ) ERC721("Milestone NFT", "MNFT") Ownable(initialOwner) {}

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://ipfs.io/ipfs/Qmf6kQMtH9ehoMK8gbHz5PrpegJ2VYiVoPMUWoqhAHUvV3/";
    }

    function safeMint(
        address to,
        string memory uri,
        string memory geography,
        string memory location,
        string memory geoTag,
        string memory user,
        string memory title,
        string memory description,
        string memory cover,
        uint256 randomNumber
    ) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        nftData[tokenId] = NFTData({
            geography: geography,
            location: location,
            geoTag: geoTag,
            user: user,
            title: title,
            description: description,
            cover: cover,
            randomNumber: randomNumber,
            stakedAmount: 0
        });
    }

    function stake() external payable {
        require(msg.value > 0, "Must stake a non-zero amount");

        uint256 stakedAmount = _currentStakedAmount > 0
            ? _currentStakedAmount
            : _basePrice;
        require(msg.value == stakedAmount, "Incorrect stake amount");

        stakers[msg.sender] += msg.value;
        nftData[_nextTokenId - 1].stakedAmount += msg.value;
        _currentStakedAmount += msg.value;

        if (_currentStakedAmount >= _basePrice * 2) {
            _increasePrice();
        }
    }

    function _increasePrice() private {
        _basePrice = _basePrice * 2;
        _currentStakedAmount = 0;
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
