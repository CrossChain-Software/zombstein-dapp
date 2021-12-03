// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "./contracts/ERC721.sol";
import "./utils/Ownable.sol";
import "./utils/ECDSA.sol";
import "./utils/Counters.sol";

contract ZombsteinDapp is ERC721, Ownable {
    using ECDSA for bytes32;
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenSupply;


    // instead of using all of the uint256 variables up here,
    // we need to make a NFTMarketInitStruct which uses a set of
    // uint256 variables
    // use less booleans and use bits instead

    uint256 public constant teamAmount = 8;
    uint256 public constant internalWitholdLimit = 80;
    uint256 public constant preSaleAmount = 2200;
    uint256 public constant publicSaleAmount = 6600;
    uint256 public constant maxAmount = teamAmount + internalWitholdLimit + preSaleAmount + publicSaleAmount;
    uint256 public constant price = 0.08 ether;
    uint256 public constant maxPerTx = 5;

    mapping(address => bool) public presalerList;
    mapping(address => uint256) public presalerListPurchases;
    mapping(string => bool) private _usedNonces;

    string private _contractURI;
    string private _tokenBaseURI = "";
    address private _signerAddress = 0x02E1a5869E4649AEd2D8b92298D01e13d4236554;

    string public proof;
    uint256 public giftedAmount = 0;
    uint256 public presaleAmountMinted = 0;
    uint256 public publicAmountMinted = 0;
    uint256 public presalePurchaseLimit = 5;
    bool public isPresaleLive = false;
    bool public isSaleLive = false;
    bool public isLocked = true;

    constructor() ERC721("Zombstein", "ZOMB") {}

    modifier notLocked {
        require(!isLocked, "Contract metadata methods are locked");
        _;
    }

    function addToPresaleList(address[] calldata userEntries) external onlyOwner {
        for(uint256 i = 0; i < userEntries.length; i++) {
            address userEntry = userEntries[i];
            require(userEntry != address(0), "null address");
            require(!presalerList[userEntry], "duplicate entry");
            
            presalerList[userEntry] = true;
        }
    }

    function isInPresaleList(address presaler) external view returns (bool) {
        return presalerList[presaler];
    }

    function removeFromPresaleList(address[] calldata userEntries) external onlyOwner {
        for (uint256 i = 0; i < userEntries.length; i++) {
            address userEntry = userEntries[i];
            require(userEntry != address(0), "null address");

            presalerList[userEntry] = false;
        }
    }

    function hashTransaction(address sender, uint256 qty, string memory nonce) public returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(sender, qty, nonce))));
    }

    /// @return True if the signer address is the same as the one in the contract
    function matchAddressSigner(bytes32 hash, bytes memory signature) public view returns (bool) {
        return _signerAddress == hash.toEthSignedMessageHash().recover(signature);
    }

    function mint(bytes32 hash, bytes memory signature, string memory nonce, uint256 tokenQuantity) external payable returns (bool) {
        require(isSaleLive, "Sale is not live");
        require(!isPresaleLive, "Only whitelisted, presale members are allowed to buy tokens right now");
        /// @dev Signing address has to come from the frontend- does this mean that the address is forwarded from the frontend or another contract?
        require(matchAddressSigner(hash, signature), "Direct mint is disallowed");
        require(!_usedNonces[nonce], "Nonce already used");
        require(hashTransaction(msg.sender, tokenQuantity, nonce) == hash, "Invalid transaction hash");
        require(_tokenSupply.current() < maxAmount, "Max amount exceeded");
        require(publicAmountMinted + tokenQuantity <= publicSaleAmount, "Public sale amount exceeded");
        require(tokenQuantity <= maxPerTx, "Max amount per transaction exceeded");
        require(price * tokenQuantity <= msg.value, "Not enough ether");
        

        for (uint256 i = 0; i < tokenQuantity; i++) {
            publicAmountMinted++;
            _tokenSupply.increment();
            _safeMint(msg.sender, _tokenSupply.current());
        }
        
        _usedNonces[nonce] = true;
        return true;
    }

    function presaleMint(bytes32 hash, bytes memory signature, string memory nonce, uint256 tokenQuantity) external payable returns (bool) {
        require(!isPresaleLive && isSaleLive, "Presale is not live");
        require(presalerList[msg.sender], "Only presale members are allowed to buy tokens right now");
        require(!_usedNonces[nonce], "Nonce already used");
        require(matchAddressSigner(hash, signature), "Direct mint is disallowed");
        require(_tokenSupply.current() < maxAmount, "NFTs are sold out!");
        require(presalerListPurchases[msg.sender] + tokenQuantity <= presalePurchaseLimit, "Cannot mint more than your allocated amount");
        require(price * tokenQuantity <= msg.value, "Not enough ether sent to purchase NFTs");

        for (uint256 i = 0; i < tokenQuantity; i++) {
            presaleAmountMinted++;
            presalerListPurchases[msg.sender]++;
            _tokenSupply.increment();
            _safeMint(msg.sender, _tokenSupply.current());
        }

        _usedNonces[nonce] = true;
        return true;
    }


    function gift(address[] calldata receivers) external onlyOwner {
        // amount minted + gift receivers array of addresses <= 8888
        // works if they are receiving one nft
        require(_tokenSupply.current() + receivers.length <= maxAmount, "Max amount exceeded");
        require(giftedAmount + receivers.length <= internalWitholdLimit, "No more gifts left");

        for (uint256 i = 0; i < receivers.length; i++) {
            giftedAmount++;
            // _safeMint(receivers[i], _tokenSupply.increment());
            _safeMint(receivers[i], _tokenSupply.current());
        }
    }

    /// @notice Need to test for re-entrancy
    function withdraw() external onlyOwner {
        // do we need to check for the balance of the contract?
        payable(msg.sender).transfer(address(this).balance);
    }

    function lockMetadata() external onlyOwner {
        isLocked = true;
    }

    function togglePresaleStatus() external onlyOwner {
        isPresaleLive = !isPresaleLive;
    }

    function toggleMainSaleStatus() external onlyOwner {
        isSaleLive = !isSaleLive;
    }

    function setSignerAddress(address addr) external onlyOwner {
        _signerAddress = addr;
    }

    function setProvenanceHash(string calldata hash) external onlyOwner notLocked {
        proof = hash;
    }

    function setContractURI(string calldata uri) external onlyOwner notLocked {
        _contractURI = uri;
    }

    function setTokenBaseURI(string calldata uri) external onlyOwner notLocked {
        _tokenBaseURI = uri;
    }

    function isPresaler(address addr) external view returns (bool) {
        return presalerList[addr];
    }

    //////////////////////// @dev Getters ////////////////////////

    function presalePurchasedCount(address addr) external view returns (uint256) {
        return presalerListPurchases[addr];
    }

    function getNumberOfTokensMinted() public view returns (uint256) {
        return _tokenSupply.current();
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    function tokenBaseURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
    }
}
