// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "./utils/ECDSA.sol";
import "./ZombsteinDapp.sol";

contract ZombsteinDappTest is DSTest {
    ZombsteinDapp dapp;
    using ECDSA for bytes32;
    address private _signerAddress = 0x02E1a5869E4649AEd2D8b92298D01e13d4236554;
    bytes32 r = 0xa277d18dd018c793f2ec601b2eba960acd58100d223e002af7cc152d860c7799;
    bytes32 s = 0x0362b84a2fdf8fc9c5987d76109ae105d282c041ac44a58b8da71658fa2e36be;
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

    function testAddToPresaleList() public {
        address[] memory a = new address[](2);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        a[1] = 0x71315fbDDdE8D5bc1573C3Df2Af670A6B51ecBeD;

        dapp.addToPresaleList(a);
        assertTrue(dapp.isInPresaleList(a[0]));
        assertTrue(dapp.isInPresaleList(a[1]));
    }

    function testNotAddedToPresaleList() public {
        address[] memory a = new address[](2);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        assertTrue(!(dapp.isInPresaleList(a[0])));
    }

    function testRemoveFromPresaleList() public {
        address[] memory a = new address[](2);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        a[1] = 0x71315fbDDdE8D5bc1573C3Df2Af670A6B51ecBeD;

        dapp.addToPresaleList(a);
        dapp.removeFromPresaleList(a);

        assertTrue(!dapp.isInPresaleList(a[0]));
        assertTrue(!dapp.isInPresaleList(a[1]));
    }

    function testTogglePresaleStatus() public {
        assertTrue(!dapp.isPresaleLive());
        dapp.togglePresaleStatus();
        assertTrue(dapp.isPresaleLive());
    }

    function testToggleMainSaleStatus() public {
        assertTrue(!dapp.isSaleLive());
        dapp.toggleMainSaleStatus();
        assertTrue(dapp.isSaleLive());
    }

    function testIsPresaler() public {
        address[] memory a = new address[](1);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;

        assertTrue(!dapp.isPresaler(a[0]));
        dapp.addToPresaleList(a);
        assertTrue(dapp.isPresaler(a[0]));
    }

    function testMint() public {
        uint16 qty = 1;
        uint8 vb = 0x1C;
        bytes32 TXHash = dapp.hashTransaction(_signerAddress, qty, _nonce);
        bytes memory sig = bytes.concat(r,s,v);
        address returnedAddress;

        emit log_address(msg.sender);
        
        dapp.toggleMainSaleStatus();

        assertTrue(dapp.mint(TXHash, sig, _nonce, qty));
    }
    
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

    function testIsPresaleLive() public {
        assertTrue(!dapp.getIsPresaleLive());
    }

    function testGift() public {
        address[] memory a = new address[](2);
        a[0] = 0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9;
        a[1] = 0x71315fbDDdE8D5bc1573C3Df2Af670A6B51ecBeD;

        dapp.gift(a);
        // why cant i get the current tokenSupply()?
        uint tokensMinted = dapp.getNumberOfTokensMinted();
        emit log_uint(tokensMinted);
        assertEq(dapp.getNumberOfTokensMinted(), 2);
    }
}
