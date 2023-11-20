// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract block721 is ERC721Enumerable {
    struct Economics {
        uint256 housePrice;
        bool isForSale;
        uint256 userBalance;
        uint256 sellerBalance;
        uint256 ethereumPayment;
        address sellerID;
        address purchaserID;
        uint256 purchaserHouseValue;
    }

    mapping(uint256 => Economics) public propertyDetails;

    event PropertyAdded(uint256 tokenId, uint256 housePrice);
    event PropertyPurchased(uint256 tokenId, address purchaser);
    event PropertyRemoved(uint256 tokenId);

    constructor() ERC721("RealEstate", "RE") {}

    function addProperty(uint256 _housePrice) external returns (uint256) {
        uint256 tokenId = totalSupply() + 1; // totalSupply() comes from ERC721Enumerable

        _mint(msg.sender, tokenId);

        Economics memory newEconomics = Economics({
            housePrice: _housePrice,
            isForSale: true,
            userBalance: 0,
            sellerBalance: 0,
            ethereumPayment: 0,
            sellerID: msg.sender,
            purchaserID: address(0),
            purchaserHouseValue: 0
        });

        propertyDetails[tokenId] = newEconomics;

        emit PropertyAdded(tokenId, _housePrice);

        return tokenId;
    }

    function purchaseProperty(uint256 _tokenId) external payable {
        Economics storage property = propertyDetails[_tokenId];

        require(property.isForSale, "Property is not for sale");
        require(msg.value == property.housePrice, "Incorrect Ether sent.");
        require(property.sellerID != msg.sender, "Seller cannot purchase their own property");

        _transfer(ownerOf(_tokenId), msg.sender, _tokenId);

        payable(property.sellerID).transfer(msg.value);

        property.isForSale = false;
        property.purchaserID = msg.sender;

        emit PropertyPurchased(_tokenId, msg.sender);
    }

    function removeProperty(uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "Caller is not the owner");
        require(propertyDetails[_tokenId].isForSale, "Property is not listed for sale");

        _burn(_tokenId);


        delete propertyDetails[_tokenId];

        emit PropertyRemoved(_tokenId);
    }
}