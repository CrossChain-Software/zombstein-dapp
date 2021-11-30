// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./ZombsteinDapp.sol";

contract ZombsteinDappTest is DSTest {
    ZombsteinDapp dapp;

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

    /*

    test withdraw
    test lockMetadata
    test togglePresaleStatus
    test toggleMainSaleStatus
    test setSignerAddress
    test setSignerAddress
    test setProvenanceHash
    test setContractURI
    test setTokenBaseURI
    test isPresaler
    test presalePurchasedCount
    test getNumberOfTokensMinted
    test contractURI
    test tokenBaseURI

    // test hashTransaction()

    // test matchAddressSigner()  
    Make sure the signing address is correct from the frontend
        - _signerAddress
        - test that matchAddressSigner returns true if the address is the signer, false if not

    // test mint()
    Make sure a txn is hashed correctly
    Test minting against different variables:
        - isSaleLive
        - isPresaleLive
        - make sure that direct minting is not allowed
        - Test nonce functionality
        - Test the hash transaction is correct
        - Test token supply doesn't exceed max
        - test public amount minted + tokenQuantity <= publicSaleAmount
        - test max tokens per transaction
        - test that the right, too much, or too little ether was added

        - test that the before/after token supplies are correct
        - test the gas usage for optimization
        - figure out what the fuck nonces do

    // test gift()
        - make sure gifts don't exceed max supply
            - is there a max amount of gifts?
        - make sure token balances are equal after gifting
            - gifted + _tokenSupply.current() <= maxAmount
    */

}
