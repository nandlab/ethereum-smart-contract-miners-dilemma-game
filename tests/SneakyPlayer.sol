// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "remix_tests.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./Player.sol";
import "hardhat/console.sol";


contract SneakyPlayer is Player {
    uint ctr;
    
    constructor(PrisonersDilemmaGame _prisonersDilemma) payable Player(_prisonersDilemma) {}

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(
            block.timestamp, address(this), ctr
        )));
    }

    function doAction() external override onlyOwner nonReentrant {
        // Start by cooperating, then mirror the oppenent's behaviour
        PrisonersDilemmaGame.Action lastOpponentAction = prisonersDilemma.getPlayerState(opponent).lastAction;
        PrisonersDilemmaGame.Action action = PrisonersDilemmaGame.Action.Cooperate;
        if (lastOpponentAction != PrisonersDilemmaGame.Action.None) {
            action = lastOpponentAction;
        }
        // Defect in 10% of the cases, even if the opponent cooperated
        if (random() % 10 == 0) {
            action = PrisonersDilemmaGame.Action.Defect;
        }
        prisonersDilemma.submitAction(action);
        ctr++;
    }
}
