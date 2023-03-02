// SPDX-License-Identifier: MIT

//Marketplace 

//User can buy and sell data to each other
//Use zero knowledge proof to verify the data

//Should we provide economic incentive to pin the data

//Data has a description type 

//Users can buy data based upon the desciption type 
//To go further, can provide zero knowledge proof tests on the
//..data to make sure it's sufficient enough 

//Data also has a CID 
//We'll send the CID to the other user when they buy the data 

//Code re-entrancy attack protection 
//Code oracle attack protection 

//Smart Contract Security: 
//Always call external contracts as last step 
//Mutex locking 

//*Make sure to call all state changes before using an external contract* 



pragma solidity ^0.8.7;

error DataMarketplace_NotApprovedForMarketplace();
error DataMarketplace_PriceMustBeAboveZero();
error DataMarketplace_AlreadyListed(address dataAddress, uint256 dataId); 
error DataMarketplace_NotListed(address dataAddress, uint256 dataId); 
error DataMarketplace_PriceNotMet(address dataAddress, uint256 dataId, uint256 price);
error DataMarketplace_NoProceeds(); 
error DataMarketplace_TransferFailed();
error DataMarkeptlace_NotOwner(); 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ERC721, ReentrancyGuard {

    constructor() ERC721("DataMarketplace", "DMP") {}

    //Structure for the listing of the data 
    struct Listing {
        uint256 price; 
        address seller; 
    }

    event Datalisted(
        address indexed seller, 
        address indexed dataAddress, 
        uint256 indexed dataId, 
        uint256 price
    ); 

    event DataBought(
        address indexed buyer, 
        address indexed dataAddress, 
        uint256 indexed dataId, 
        uint256 price
    );

    event DataCanceled(
        address indexed seller, 
        address indexed dataAddress, 
        uint256 indexed dataId, 
        uint256 price
    );

    // Data Contract Adress -> Data Id -> Listing
    mapping(address => mapping(uint256 => Listing)) private s_listings;
    mapping(address => uint256) private s_proceeds;

    modifier notListed(
        address dataAddress, 
        uint256 dataId, 
        address owner
    ) {
        Listing memory listing = s_listings[dataAddress][dataId]; 
        if (listing.price > 0) {
            revert DataMarketplace_AlreadyListed(dataAddress, dataId);
        }
        _;
    }

    modifier isOwner(
        address dataAddress, 
        uint256 dataId, 
        address spender
    ) {
        IERC721 dataNft = IERC721(dataAddress);
        address owner = dataNft.ownerOf(dataId);
        if (spender != owner) {
            revert DataMarkeptlace_NotOwner();
        }
        _;
    }

    modifier isListed(address dataAddress, uint256 dataId) {
        Listing memory listing = s_listings[dataAddress][dataId];
        if (listing.price <= 0) {
            revert DataMarketplace_NotListed(dataAddress, dataId);
        }
        _; 
    }

    function listData(
        address dataAddress, 
        uint256 dataId, 
        uint256 price
    ) external 
    notListed(dataAddress, dataId, msg.sender) 
    isOwner(dataAddress, dataId, msg.sender) {
        if (price <= 0){
            revert DataMarketplace_PriceMustBeAboveZero();
        }
        IERC721 dataNft = IERC721(dataAddress);
        if (dataNft.getApproved(dataId) != address(this)) {
            revert DataMarketplace_NotApprovedForMarketplace();
        }
        s_listings[dataAddress][dataId] = Listing(price, msg.sender);
        emit Datalisted(msg.sender, dataAddress, dataId, price); 

    }

    function buyData(address dataAddress, uint256 dataId) 
    external 
    payable
    nonReentrant 
    isListed(dataAddress, dataId) {
        Listing memory listedData = s_listings[dataAddress][dataId]; 
        if(msg.value < listedData.price) {
            revert DataMarketplace_PriceNotMet(dataAddress, dataId, listedData.price); 
        }
        s_proceeds[listedData.seller] = s_proceeds[listedData.seller] + msg.value;
        delete (s_listings[dataAddress][dataId]);
        IERC721(dataAddress).safeTransferFrom(listedData.seller, msg.sender, dataId);
        
        //Make sure user (seller) withdraws the money
        emit DataBought(msg.sender, dataAddress, dataId, listedData.price); 
    }

    function cancelListing (address dataAddress, uint256 dataId, uint256 price) external isOwner(dataAddress, dataId, msg.sender) isListed(dataAddress, dataId) {
        delete (s_listings[dataAddress][dataId]);
        emit DataCanceled(msg.sender,dataAddress, dataId, price);
    }

    function updateListing(
        address dataAddress, 
        uint256 dataId, 
        uint256 newPrice
    ) external isListed(dataAddress, dataId) isOwner(dataAddress, dataId, msg.sender) {
        s_listings[dataAddress][dataId].price = newPrice;
        emit Datalisted(msg.sender, dataAddress, dataId, newPrice);
    }

    function withdrawProceeds() external {
        uint256 proceeds = s_proceeds[msg.sender];
        if (proceeds <= 0) {
            revert DataMarketplace_NoProceeds();
        }
        s_proceeds[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: proceeds}("");
        if(!success) {
            revert DataMarketplace_TransferFailed();
        }
    }
    
    // function transferDataKey() {

    // }

    // function dataURI(uint256) public {

    // }

    //Get the particular listing 
    function getListing(address dataAddress, uint256 dataId) external view returns (Listing memory) {
        return s_listings[dataAddress][dataId];
    }

    //Get how much in proceeds the user has
    function getProceeds(address seller) external view returns (uint256) {
        return s_proceeds[seller];
    }

}