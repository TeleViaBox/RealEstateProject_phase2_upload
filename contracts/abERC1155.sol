// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
//import "@openzepplin/RealEstate-contract/token/ERC20/extensions/ERC20.sol";
//erc721 
pragma solidity ^0.8.9;

contract RealEstate is ERC721Enumerable {
    
    struct Economics {
        uint256 housePrice;
        bool purchased;
        uint256 userBalance;
        uint256 sellerBalance;
        uint256 ethereumPayment;
        address sellerID;
        address purchaserID;
        uint256 purchaserHouseValue;
        uint256 sellerhouserights;
        uint256 purchaserhouserights;
    }
    event purchased();
    event initialized();
    //event addProperty();
    event finalized();
    event transfertransaction(); 
    
    mapping(address => Economics) public Purchaser; 
    mapping(uint256 => Economics) public propertyDetails; 
    
    uint256 public nextPropertyId = 1;
    
    address public seller;
    
    modifier onlyOwner(uint256 _propertyId) {
        require(ownerOf(_propertyId) == msg.sender, "Not the owner");
        _;
    }
    
    constructor() ERC721("RealEstate", "RE") {
        seller = msg.sender;
    }
    
    function addProperty(uint256 _housePrice, string memory _tokenURI) external returns (uint256) {
        uint256 newPropertyId = nextPropertyId++;

        _mint(msg.sender, newPropertyId);
        _setTokenURI(newPropertyId, _tokenURI);

        Economics memory economics = Economics({
            housePrice: _housePrice,
            purchased: false,
            userBalance: 0,
            sellerBalance: 0,
            sellerID:address(0),
            purchaserID: address(0),
            ethereumPayment: 0,
            purchaserHouseValue: 0,
            sellerhouserights: 0,
            purchaserhouserights:0
        });

        propertyDetails[newPropertyId] = economics;

        return newPropertyId;
    }
    
    function purchaseProperty(uint256 _propertyId) external payable {
        require(ownerOf(_propertyId) == msg.sender, "ERC721: transfer caller is not owner nor approved");

        Economics storage property = propertyDetails[_propertyId];

        require(msg.value == property.housePrice, "Incorrect Ether sent.");

        address previousOwner = ownerOf(_propertyId);
        _transfer(previousOwner, msg.sender, _propertyId);

        payable(previousOwner).transfer(msg.value);

        property.purchased = true;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(tokenId <= nextPropertyId, "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(tokenId <= nextPropertyId, "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }
    mapping (uint256 => string) private _tokenURIs;

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return owner != address(0);
    }
    /*
    function tokenconversion(address purchaserID) public view {
       
        uint value = tokenconversion(address(purchaserID).balance *(10 ** uint256(decimals))); // obtains value from external source 
        value; 
    }
    */
    function batchtransfer(uint sellerID, uint purchaserID, uint purchaserhouserights, uint sellerhouserights ) external{
        //uint uinttemporaryrights = purchaserhouserights;
        if(propertyDetails[purchaserID].purchaserhousevalue.currentowner != propertyDetails[sellerID].purchasehousevalue.previousOwner){ // when the value of the house is different from previous item after when transaction went successful
            uint uinttemporaryrights = purchaserhouserights;
            uint temporaryrights  = 0; 
            uint256 temporarysellerrights = propertyDetails[sellerID].sellerhouserights; // exchangging the house rights 
            Economics[purchaserhouserights] = temporarysellerrights; // transfer the house rights from seller to purchaser
            Economics[sellerhouserights]= 0; // setting tjhe seller house rights to none
            propertyDetails[sellerID].sellerhouserights = temporaryrights; // exchange the rights of the property 
        } //transaction went successful 
    }

}
