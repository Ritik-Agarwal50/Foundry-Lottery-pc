// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (, , , , , address vrfCoordinatorV2, ) = helperConfig
            .activeNetworkConfig();
        return createSubscription(vrfCoordinatorV2);
    }

    function createSubscription(address vrfCoordinator)
        public
        returns (uint64)
    {
        console.log("createSubscription", block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinator)
            .createSubscription();
        vm.stopBroadcast();
        console.log("Your Sub Id:", subId);
        console.log("Pleae update ur subb id in helper config");
        return subId;
    }

    function run() external returns (uint64) {
        return createSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 3 ether;

    function FundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint64 subId,
            ,
            ,
            ,
            ,
            address vrfCoordinatorV2,
            address link
        ) = helperConfig.activeNetworkConfig();
    }

    function run() external {
        FundSubscriptionUsingConfig();
    }
}
