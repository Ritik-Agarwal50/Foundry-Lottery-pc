// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {Raffle} from "../../src/Raffle.sol";
import {console, Test} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test {
    event RaffleEnter(address indexed player);

    Raffle raffle;
    HelperConfig helperConfig;

    uint64 subscriptionId;
    bytes32 gasLane; // keyHash
    uint256 interval;
    uint256 entranceFee;
    uint32 callbackGasLimit;
    address vrfCoordinatorV2;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_BALANCE = 10 ether;

    modifier playerEnter() {
        vm.prank(PLAYER);
        vm.deal(PLAYER, STARTING_BALANCE);
        _;
    }

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();
        (
            subscriptionId,
            gasLane, // keyHash
            interval,
            entranceFee,
            callbackGasLimit,
            vrfCoordinatorV2
        ) = helperConfig.activeNetworkConfig();
    }

    function testRaffleInitializedsInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRaffleRevertsWhenYouDontHaveEnoughBalance()
        public
        playerEnter
    {
        //vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle__SendMoreToEnterRaffle.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsWhenTheyEntered() public playerEnter {
        raffle.enterRaffle{value: entranceFee}();
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }

    function testEmitsEventsOnEntrance() public playerEnter {
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEnter(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
    }

    function cantEbterWhenRaffleIsCalculating() public playerEnter {
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        raffle.performUpkeep("");
        vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        
    }
}