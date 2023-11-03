// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { Test } from "forge-std/Test.sol";
import { Deploy } from "../script/Deploy.s.sol";
import { DeploymentConfig } from "../script/DeploymentConfig.s.sol";

import { NotEnoughBalance } from "@vacp2p/minime/contracts/MiniMeBase.sol";
import { SNTV2 } from "../src/SNTV2.sol";
import { SNTTokenController } from "../src/SNTTokenController.sol";

contract TestSNTV2 is Test {
    SNTV2 internal sntV2;
    SNTTokenController internal controller;
    DeploymentConfig internal deploymentConfig;

    address internal deployer;

    function setUp() public virtual {
        Deploy deployment = new Deploy();
        (sntV2, controller, deploymentConfig) = deployment.run();
        (address _deployer,,,) = deploymentConfig.activeNetworkConfig();
        deployer = _deployer;
    }

    function testDeployment() public {
        (, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits) =
            deploymentConfig.activeNetworkConfig();

        assertEq(sntV2.name(), tokenName);
        assertEq(sntV2.symbol(), tokenSymbol);
        assertEq(sntV2.decimals(), decimalUnits);
        assertEq(sntV2.totalSupply(), 0);
        assertEq(sntV2.controller(), address(controller));

        assertEq(controller.owner(), deployer);
    }
}

contract TestGenerateTokens is TestSNTV2 {
    function setUp() public override {
        TestSNTV2.setUp();
    }

    function test_RevertWhen_FaucetIsClosed() public {
        // ensure faucet is closed
        vm.prank(deployer);
        controller.setOpen(false);

        vm.expectRevert(SNTTokenController.SNTTokenController_NotOpen.selector);
        controller.generateTokens(address(this), 100);
    }

    function test_GenerateTokensAsOwner() public {
        vm.startPrank(deployer);
        controller.setOpen(false);

        uint256 balanceBefore = sntV2.balanceOf(address(this));
        assertEq(balanceBefore, 0);

        controller.generateTokens(address(this), 100);
        uint256 balanceAfter = sntV2.balanceOf(address(this));
        assertEq(balanceAfter, 100);
    }

    function test_GenerateTokensOpenFaucet() public {
        // ensure faucet is open
        vm.prank(deployer);
        controller.setOpen(true);

        uint256 balanceBefore = sntV2.balanceOf(address(this));
        assertEq(balanceBefore, 0);

        controller.generateTokens(address(this), 100);
        uint256 balanceAfter = sntV2.balanceOf(address(this));
        assertEq(balanceAfter, 100);
    }
}

contract TestDestroyTokens is TestSNTV2 {
    function setUp() public override {
        TestSNTV2.setUp();
    }

    function test_RevertWhen_FaucetIsClosed() public {
        // ensure faucet is closed
        vm.prank(deployer);
        controller.setOpen(false);

        vm.expectRevert(SNTTokenController.SNTTokenController_NotOpen.selector);
        controller.destroyTokens(address(this), 100);
    }

    function test_RevertWhen_NotEnoughBalance() public {
        // ensure faucet is closed
        vm.prank(deployer);
        controller.setOpen(true);

        vm.expectRevert(NotEnoughBalance.selector);
        controller.destroyTokens(address(this), 100);
    }

    function test_DestroyTokensAsOwner() public {
        // ensure faucet is open
        vm.startPrank(deployer);
        controller.setOpen(false);

        uint256 balanceBefore = sntV2.balanceOf(address(this));
        assertEq(balanceBefore, 0);

        controller.generateTokens(address(this), 100);
        uint256 balanceAfter = sntV2.balanceOf(address(this));
        assertEq(balanceAfter, 100);

        controller.destroyTokens(address(this), 100);
        balanceAfter = sntV2.balanceOf(address(this));
        assertEq(balanceAfter, 0);
    }

    function test_DestroyTokenFaucetIsOpen() public {
        // ensure faucet is open
        vm.prank(deployer);
        controller.setOpen(true);

        uint256 balanceBefore = sntV2.balanceOf(address(this));
        assertEq(balanceBefore, 0);

        controller.generateTokens(address(this), 100);
        uint256 balanceAfter = sntV2.balanceOf(address(this));
        assertEq(balanceAfter, 100);

        controller.destroyTokens(address(this), 100);
        balanceAfter = sntV2.balanceOf(address(this));
        assertEq(balanceAfter, 0);
    }
}
