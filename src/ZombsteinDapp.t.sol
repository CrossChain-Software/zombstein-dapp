// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./ZombsteinDapp.sol";

contract ZombsteinDappTest is DSTest {
    ZombsteinDapp dapp;
    address private _signerAddress = 0x02E1a5869E4649AEd2D8b92298D01e13d4236554;
    bytes32 r = 0x2d7e2b1526a2c8d66514cfa90f9c97b3869a71bca8c646b15e349cb9079f5fc4;
    bytes32 s = 0x4389dcfe9581327a53578f45bd72bfbfae3748201d55becf7503a51ee4fba108;
    bytes1  v = 0x1c;
    string private _nonce = "DEADBEEF";

    function setUp() public {
        dapp = new ZombsteinDapp();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }

    function test_addToPresaleList() public {
        address[] memory a = new address[](2);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        a[1] = 0x71315fbDDdE8D5bc1573C3Df2Af670A6B51ecBeD;

        dapp.addToPresaleList(a);
        assertTrue(dapp.isInPresaleList(a[0]));
        assertTrue(dapp.isInPresaleList(a[1]));
    }

    function test_notAddedToPresaleList() public {
        address[] memory a = new address[](2);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        assertTrue(!(dapp.isInPresaleList(a[0])));
    }

    function test_removeFromPresaleList() public {
        address[] memory a = new address[](2);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        a[1] = 0x71315fbDDdE8D5bc1573C3Df2Af670A6B51ecBeD;

        dapp.addToPresaleList(a);
        dapp.removeFromPresaleList(a);

        assertTrue(!dapp.isInPresaleList(a[0]));
        assertTrue(!dapp.isInPresaleList(a[1]));
    }

    // test withdraw
    // test lockMetadata
    // test togglePresaleStatus
    function testTogglePresaleStatus() public {
        assertTrue(!dapp.isPresaleLive());
        dapp.togglePresaleStatus();
        assertTrue(dapp.isPresaleLive());
    }

    // test toggleMainSaleStatus
    function testToggleMainSaleStatus() public {
        assertTrue(!dapp.isSaleLive());
        dapp.toggleMainSaleStatus();
        assertTrue(dapp.isSaleLive());
    }

    // test setSignerAddress
    // test setSignerAddress
    // test setProvenanceHash
    // test setContractURI
    // test setTokenBaseURI
    // test isPresaler
    function testIsPresaler() public {
        // test setup code
        address[] memory a = new address[](1);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;

        assertTrue(!dapp.isPresaler(a[0]));
        dapp.addToPresaleList(a);
        assertTrue(dapp.isPresaler(a[0]));
    }

    // test presalePurchasedCount
    // test contractURI
    // test tokenBaseURI

    /*
    // test hashTransaction()

    // test matchAddressSigner()  
    Make sure the signing address is correct from the frontend
        - _signerAddress
        - test that matchAddressSigner returns true if the address is the signer, false if not

    */

    /* test mint()
    Make sure a txn is hashed correctly
    Test minting against different variables:
        - isSaleLive
        - isPresaleLive
        - make sure that direct minting is not allowed (requires presale testing)
        - Test the hash transaction is correct
        - Test token supply doesn't exceed max
        - test public amount minted + tokenQuantity <= publicSaleAmount
        - test max tokens per transaction
        - test that the right, too much, or too little ether was added
        - test that the before/after token supplies are correct
        - test the gas usage for optimization
    */

    function testMint() public {
        // test setup code
        uint16 qty = 1;
        bytes32 TXHash = 0x1cad0e3f84ff77055c3c13c7ded4e8fcd3b259956583a3be7e5dcb39ee2ab5f6;
        dapp.toggleMainSaleStatus();
        emit log_bytes(bytes.concat(r, s, v));
        assertTrue(dapp.mint(TXHash, bytes.concat(r, s, v), _nonce, qty));
    }

    // function testNumberOfTokensMinted() public {
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
    //     dapp.toggleMainSaleStatus();

    //     assertEq(dapp.getNumberOfTokensMinted(), 0);
    //     assertTrue(dapp.mint(TXHash, bytes.concat(_signature), _nonce, qty));
    //     assertEq(dapp.getNumberOfTokensMinted(), qty);
    // }

    // function testMintNotLive() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), _nonce, qty));
    // }

    // function testMintDuringPresale() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
    //     dapp.toggleMainSaleStatus();
    //     dapp.togglePresaleStatus();

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), _nonce, qty));
    // }

    // function testMintFromNonSigner() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     address a = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
    //     bytes32 TXHash = dapp.hashTransaction(a, qty, _nonce);
    //     dapp.toggleMainSaleStatus();

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), _nonce, qty));
    // }

    // function testMintFromUsedNonce() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
    //     dapp.toggleMainSaleStatus();
    //     dapp.mint(TXHash, bytes.concat(_signature), _nonce, qty);

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), _nonce, qty));
    // }

    // function testMintFromBadHashTransactionTokenQuantity() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
    //     dapp.toggleMainSaleStatus();

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), _nonce, 2));
    // }

    // function testMintFromBadHashtransaction_nonce() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
    //     dapp.toggleMainSaleStatus();

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), "BEEFDEAD", qty));
    // }

    // function testMintFromBadHashTransactionSignerAddress() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 1;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
    //     dapp.toggleMainSaleStatus();

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), "BEEFDEAD", qty));
    // }

    // function testMintExceedingMaxTokensPerTransaction() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     uint16 qty = 10;
    //     bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
    //     dapp.toggleMainSaleStatus();

    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), _nonce, qty));
    // }

    // function testMintExceedingPublicMaxTokens() public {
    //     // test setup code
    //     bytes32 _signature = 0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd;
    //     string memory nonce = "DEADBEEF";
    //     uint16 qty = 5;
    //     uint16 maxTxnCount = 6600/5;
    //     bytes32 TXHash = 0;
    //     dapp.toggleMainSaleStatus();
    //     // Mint just up to the max amount of tokens 
    //     for(uint i = 0; i < maxTxnCount; i++) {
    //         TXHash = dapp.hashTransaction(_signerAddress, qty, nonce);
    //         dapp.mint(TXHash, bytes.concat(_signature), nonce, qty);
    //         nonce = string(abi.encodePacked(nonce, "A"));
    //     }
    //     TXHash = dapp.hashTransaction(_signerAddress, qty, nonce);
    //     assertTrue(!dapp.mint(TXHash, bytes.concat(_signature), nonce, qty));
    // }

    // TODO: This needs presale to be fixed/discussed
    // function TestMintExceedingMaxTokens() public {
    //     // test setup code
    //     uint32 nonce = 0xDEADBEEF;
    //     uint16 qty = 5;
    //     uint16 maxTxnCount = 6600/5-1;
    //     dapp.toggleMainSaleStatus();
    //     // Mint just up to the max amount of tokens 
    //     for(uint i = 0; i < maxTxnCount; i++) {
    //         bytes32 hash = hashTransaction(_signerAddress, qty, nonce);
    //         dapp.mint(hash, _signerAddress, qty, nonce);
    //         nonce++;
    //     }
    //     bytes32 hash = hashTransaction(_signerAddress, qty, nonce);
    //     assertTrue(!dapp.mint(hash, _signerAddress, qty, nonce));
    // }

    // How to test price/value sent by message? Is that needed?

    /*
    test the presaleMintFunctionality
    // Why isn't the transaction hash checked?
    */

    function testIsPresaleLive() public {
    }

    function testIsPresaleLiveNonMember() public {
    }

    /* test gift()
        - make sure gifts don't exceed max supply
            - is there a max amount of gifts?
        - make sure token balances are equal after gifting
            - gifted + _tokenSupply.current() <= maxAmount
    */

}
