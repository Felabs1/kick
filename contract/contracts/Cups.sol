// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./League.sol";

contract Cups {
    struct Cup {
        uint256 cupId;
        string name;
        uint256 startDate;
        uint256 endDate;
        address[] participants;
        mapping(address => uint256) scores;
        address winner;
        bool isActive;
    }

    mapping(uint256 => Cup) public cups;
    uint256 public cupCounter;

    League public leagueContract;

    event CupCreated(uint256 indexed cupId, string name, uint256 startDate, uint256 endDate);
    event ParticipantAdded(uint256 indexed cupId, address participant);
    event ScoreUpdated(uint256 indexed cupId, address participant, uint256 score);
    event CupCompleted(uint256 indexed cupId, address winner);

    constructor(address _leagueContractAddress) {
        leagueContract = League(_leagueContractAddress);
    }

    modifier onlyLeagueCommissioner() {
        require(msg.sender == leagueContract.commissioner(), "Only the league commissioner can perform this action");
        _;
    }

    function createCup(string memory _name, uint256 _startDate, uint256 _endDate) public onlyLeagueCommissioner {
        cupCounter++;
        Cup storage newCup = cups[cupCounter];
        newCup.cupId = cupCounter;
        newCup.name = _name;
        newCup.startDate = _startDate;
        newCup.endDate = _endDate;
        newCup.isActive = true;

        emit CupCreated(cupCounter, _name, _startDate, _endDate);
    }

    function addParticipant(uint256 _cupId, address _participant) public onlyLeagueCommissioner {
        require(cups[_cupId].isActive, "Cup is not active");
        
        League.Team memory team = leagueContract.getTeamInfo(_participant);
        require(team.owner != address(0), "Participant must be a team owner in the league");
        
        cups[_cupId].participants.push(_participant);
        emit ParticipantAdded(_cupId, _participant);
    }

    function updateScore(uint256 _cupId, address _participant, uint256 _score) public onlyLeagueCommissioner {
        require(cups[_cupId].isActive, "Cup is not active");
        require(isParticipant(_cupId, _participant), "Address is not a participant in this cup");

        cups[_cupId].scores[_participant] = _score;
        emit ScoreUpdated(_cupId, _participant, _score);
    }

    function completeCup(uint256 _cupId) public onlyLeagueCommissioner {
        require(cups[_cupId].isActive, "Cup is not active");
        
        address winner = determineWinner(_cupId);
        cups[_cupId].winner = winner;
        cups[_cupId].isActive = false;

        emit CupCompleted(_cupId, winner);
    }

    function isParticipant(uint256 _cupId, address _participant) public view returns (bool) {
        for (uint i = 0; i < cups[_cupId].participants.length; i++) {
            if (cups[_cupId].participants[i] == _participant) {
                return true;
            }
        }
        return false;
    }

    function determineWinner(uint256 _cupId) internal view returns (address) {
        address winner = address(0);
        uint256 highestScore = 0;

        for (uint i = 0; i < cups[_cupId].participants.length; i++) {
            address participant = cups[_cupId].participants[i];
            uint256 score = cups[_cupId].scores[participant];
            if (score > highestScore) {
                highestScore = score;
                winner = participant;
            }
        }

        return winner;
    }

    function getCupParticipants(uint256 _cupId) public view returns (address[] memory) {
        return cups[_cupId].participants;
    }

    function getCupScores(uint256 _cupId) public view returns (address[] memory, uint256[] memory) {
        Cup storage cup = cups[_cupId];
        address[] memory participants = cup.participants;
        uint256[] memory scores = new uint256[](participants.length);

        for (uint i = 0; i < participants.length; i++) {
            scores[i] = cup.scores[participants[i]];
        }

        return (participants, scores);
    }

    function getCupWinner(uint256 _cupId) public view returns (address) {
        require(!cups[_cupId].isActive, "Cup is still active");
        return cups[_cupId].winner;
    }
}