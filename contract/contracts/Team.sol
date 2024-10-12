// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IKickPlayerNFT {
    function ownerOf(uint256 tokenId) external view returns (address);
    function getPlayerRating(uint256 tokenId) external view returns (uint256);
}

contract FootballTeam {
    IKickPlayerNFT public kickPlayerNFT;

    enum Position { GK, DEF, MID, FWD }

    struct Team {
        uint256 id;
        string name;
        address owner;
        uint256 foundedYear;
        string homeStadium;
        uint256 overallRating; // 1-100
        uint256 wins;
        uint256 draws;
        uint256 losses;
        uint256 goalsScored;
        uint256 goalsConceded;
    }

    mapping(uint256 => Team) public teams;
    mapping(uint256 => mapping(Position => uint256[])) public teamPlayers;
    uint256 public teamCount;

    // Maximum players per position
    uint256 constant MAX_GOALKEEPERS = 3;
    uint256 constant MAX_DEFENDERS = 6;
    uint256 constant MAX_MIDFIELDERS = 6;
    uint256 constant MAX_FORWARDS = 4;

    event TeamCreated(uint256 indexed teamId, string name, address owner);
    event PlayerAdded(uint256 indexed teamId, uint256 indexed playerTokenId, Position position);
    event PlayerRemoved(uint256 indexed teamId, uint256 indexed playerTokenId, Position position);
    event TeamStatsUpdated(uint256 indexed teamId, uint256 wins, uint256 draws, uint256 losses);

    constructor(address _kickPlayerNFTAddress) {
        kickPlayerNFT = IKickPlayerNFT(_kickPlayerNFTAddress);
    }

    function createTeam(string memory _name, uint256 _foundedYear, string memory _homeStadium) public returns (uint256) {
        teamCount++;
        teams[teamCount] = Team({
            id: teamCount,
            name: _name,
            owner: msg.sender,
            foundedYear: _foundedYear,
            homeStadium: _homeStadium,
            overallRating: 50, // Default rating
            wins: 0,
            draws: 0,
            losses: 0,
            goalsScored: 0,
            goalsConceded: 0
        });

        emit TeamCreated(teamCount, _name, msg.sender);
        return teamCount;
    }

    function addPlayer(uint256 _teamId, uint256 _playerTokenId, Position _position) public {
        require(teams[_teamId].owner == msg.sender, "Only team owner can add players");
        require(kickPlayerNFT.ownerOf(_playerTokenId) == msg.sender, "You must own the player NFT");

        uint256[] storage positionPlayers = teamPlayers[_teamId][_position];
       require(positionPlayers.length < getMaxPlayersForPosition(_position), "Maximum players reached for this position");

        positionPlayers.push(_playerTokenId);
        updateTeamRating(_teamId);

        emit PlayerAdded(_teamId, _playerTokenId, _position);
    }

    function removePlayer(uint256 _teamId, uint256 _playerTokenId, Position _position) public {
        require(teams[_teamId].owner == msg.sender, "Only team owner can remove players");

        uint256[] storage positionPlayers = teamPlayers[_teamId][_position];
        for (uint256 i = 0; i < positionPlayers.length; i++) {
            if (positionPlayers[i] == _playerTokenId) {
                positionPlayers[i] = positionPlayers[positionPlayers.length - 1];
                positionPlayers.pop();
                updateTeamRating(_teamId);
                emit PlayerRemoved(_teamId, _playerTokenId, _position);
                return;
            }
        }
        revert("Player not found in the team");
    }

    function updateTeamRating(uint256 _teamId) internal {
        uint256 totalRating = 0;
        uint256 playerCount = 0;

        // for (uint8 i = 0; i <= uint8(Position.FWD); i++) {
        //     Position position = Position(i);
        //     uint256[] storage positionPlayers = teamPlayers[_teamId][position];
        //     for (uint256 j = 0; j < positionPlayers.length; j++) {
        //         totalRating += kickPlayerNFT.getPlayerRating(positionPlayers[j]);
        //         playerCount++;
        //     }
        // }

        if (playerCount > 0) {
            teams[_teamId].overallRating = totalRating / playerCount;
        } else {
            teams[_teamId].overallRating = 0;
        }
    }

    function getTeamPlayers(uint256 _teamId, Position _position) public view returns (uint256[] memory) {
        return teamPlayers[_teamId][_position];
    }


    function getMaxPlayersForPosition(Position _position) public pure returns (uint256) {
        if (_position == Position.GK) return MAX_GOALKEEPERS;
        if (_position == Position.DEF) return MAX_DEFENDERS;
        if (_position == Position.MID) return MAX_MIDFIELDERS;
        if (_position == Position.FWD) return MAX_FORWARDS;
        revert("Invalid position");
    }
}