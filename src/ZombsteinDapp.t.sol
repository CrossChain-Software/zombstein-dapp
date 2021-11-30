// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./ZombsteinDapp.sol";

contract ZombsteinDappTest is DSTest {
    ZombsteinDapp dapp;
    address private _signerAddress = 0x0000000000000000000000000000000000000000;
    address _nonSignerAddress = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
    string private __nonce = 0xDEADBEEF;

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
        assertTrue(!dapp.isPresaleLive);
        dapp.togglePresaleStatus();
        assertTrue(dapp.isPresaleLive);
    }

    // test toggleMainSaleStatus
    function testToggleMainSaleStatus() public {
        assertTrue(!dapp.isSaleLive);
        dapp.toggleMainSaleStatus();
        assertTrue(dapp.isSaleLive);
    }

    // test setSignerAddress
    // test setSignerAddress
    // test setProvenanceHash
    // test setContractURI
    // test setTokenBaseURI
    // test isPresaler
    // test presalePurchasedCount
    // test getNumberOfTokensMinted
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
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);
        dapp.toggleMainSaleStatus();

        assertTrue(dapp.mint(hash, _signerAddress, _nonce, qty));
    }

    function testMintNotLive() public {
        // test setup code
        uint16 qty = 1;
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);

        assertTrue(!dapp.mint(hash, _signerAddress, _nonce, qty));
    }

    function testMintDuringPresale() public {
        // test setup code
        uint16 qty = 1;
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);
        dapp.toggleMainSaleStatus();
        dapp.togglePresaleStatus();

        assertTrue(!dapp.mint(hash, _signerAddress, _nonce, qty));
    }

    function testMintFromNonSigner() public {
        // test setup code
        uint16 qty = 1;
        address a = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        bytes32 hash = hashTransaction(a, qty, _nonce);
        dapp.toggleMainSaleStatus();

        assertTrue(!dapp.mint(hash, a, _nonce, qty));
    }

    function testMintFromUsed_nonce() public {
        // test setup code
        uint16 qty = 1;
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);
        dapp.toggleMainSaleStatus();
        dapp.mint(hash, _signerAddress, _nonce, qty);

        assertTrue(!dapp.mint(hash, _signerAddress, _nonce, qty));
    }

    function testMintFromBadHashTransactionTokenQuantity() public {
        // test setup code
        uint16 qty = 1;
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);
        dapp.toggleMainSaleStatus();

        assertTrue(!dapp.mint(hash, _signerAddress, _nonce, 2));
    }

    function testMintFromBadHashtransaction_nonce() public {
        // test setup code
        uint16 qty = 1;
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);
        dapp.toggleMainSaleStatus();

        assertTrue(!dapp.mint(hash, _signerAddress, 0xBEEFDEAD, qty));
    }

    function testMintFromBadHashTransactionSignerAddress() public {
        // test setup code
        uint16 qty = 1;
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);
        dapp.toggleMainSaleStatus();

        assertTrue(!dapp.mint(hash, _signerAddress, 0xBEEFDEAD, qty));
    }

    function testMintExceedingMaxTokensPerTransaction() public {
        // test setup code
        uint16 qty = 10;
        bytes32 hash = hashTransaction(_signerAddress, qty, _nonce);
        dapp.toggleMainSaleStatus();

        assertTrue(!dapp.mint(hash, _signerAddress, _nonce, qty));
    }

    function TestMintExceedingPublicMaxTokens() public {
        // test setup code
        uint32 nonce = 0xDEADBEEF;
        uint16 qty = 5;
        uint16 maxTxnCount = 6600/5-1;
        dapp.toggleMainSaleStatus();
        // Mint just up to the max amount of tokens 
        for(uint i = 0; i < maxTxnCount; i++) {
            bytes32 hash = hashTransaction(_signerAddress, qty, nonce);
            dapp.mint(hash, _signerAddress, qty, nonce);
            nonce++;
        }
        bytes32 hash = hashTransaction(_signerAddress, qty, nonce);
        assertTrue(!dapp.mint(hash, _signerAddress, qty, nonce));
    }

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

    /*
    test the presaleMintFunctionality
    // Why isn't the transaction hash checked?
    */

    function testIsPresaleLive() public {
        // test setup code
        uint16 qty = 1;
        address a = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        bytes32 hash = hashTransaction(a, qty, _nonce);

        dapp.addToPresaleList(a);
        dapp.togglePresaleStatus();

        assertTrue(dapp.mint(hash, a, _nonce, qty));
    }

    function testIsPresaleLiveNonMember() public {
        // test setup code
        uint16 qty = 1;
        address a = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        bytes32 hash = hashTransaction(a, qty, _nonce);

        // begin tests
        assertTrue(!dapp.mint(hash, a, _nonce, qty));
    }

    /* test gift()
        - make sure gifts don't exceed max supply
            - is there a max amount of gifts?
        - make sure token balances are equal after gifting
            - gifted + _tokenSupply.current() <= maxAmount
    */

}
