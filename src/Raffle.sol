// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract Raffle {
    error Raffle__NotEnoughFunds();
    uint private immutable i_entranceFee;
    address payable [] private s_players;

    event EnteredRaffle(address indexed player);

    constructor(uint entranceFee) {
        s_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughFunds();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() {}

    function getEntranceFee() public view returns (uint) {
        return s_entranceFee;
    }
}
