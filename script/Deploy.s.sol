// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <=0.9.0;

import { BaseScript } from "./Base.s.sol";
import { DeploymentConfig } from "./DeploymentConfig.s.sol";

import { SNTV2 } from "../src/SNTV2.sol";
import { SNTTokenController } from "../src/SNTTokenController.sol";

contract Deploy is BaseScript {
    function run() public returns (SNTV2, SNTTokenController, DeploymentConfig) {
        DeploymentConfig deploymentConfig = new DeploymentConfig(broadcaster);
        (, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits) =
            deploymentConfig.activeNetworkConfig();

        vm.startBroadcast(broadcaster);
        SNTV2 sntV2 = new SNTV2(tokenName, decimalUnits, tokenSymbol, true);
        SNTTokenController controller = new SNTTokenController(payable(address(sntV2)), false);
        sntV2.changeController(payable(address(controller)));
        vm.stopBroadcast();

        return (sntV2, controller, deploymentConfig);
    }
}
