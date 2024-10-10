// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FootballTeam {
    struct Player {
        uint256 id;
        string name;
        uint256 age;
        string position;
        uint256 skillLevel; // 1-100
        bool isActive;
    }

    struct Team {
        uint256 id;
        string name;
        address owner;
        uint256 foundedYear;
        string homeStadium;
        uint256 overallRating; // 1-100
        uint256[] playerIds;
        uint256 wins;
        uint256 draws;
        uint256 losses;
        uint256 goalsScored;
        uint256 goalsConceded;
    }

    mapping(uint256 => Team) public teams;
    mapping(uint256 => Player) public players;
    uint256 public teamCount;
    uint256 public playerCount;

    event TeamCreated(uint256 indexed teamId, string name, address owner);
    event PlayerAdded(uint256 indexed teamId, uint256 indexed playerId, string name);
    event PlayerRemoved(uint256 indexed teamId, uint256 indexed playerId);
    event TeamStatsUpdated(uint256 indexed teamId, uint256 wins, uint256 draws, uint256 losses);

    function createTeam(string memory _name, uint256 _foundedYear, string memory _homeStadium) public returns (uint256) {
        teamCount++;
        teams[teamCount] = Team({
            id: teamCount,
            name: _name,
            owner: msg.sender,
            foundedYear: _foundedYear,
            homeStadium: _homeStadium,
            overallRating: 50, // Default rating
            playerIds: new uint256[](0),
            wins: 0,
            draws: 0,
            losses: 0,
            goalsScored: 0,
            goalsConceded: 0
        });

        emit TeamCreated(teamCount, _name, msg.sender);
        return teamCount;
    }

    function addPlayer(uint256 _teamId, string memory _name, uint256 _age, string memory _position, uint256 _skillLevel) public {
        require(teams[_teamId].owner == msg.sender, "Only team owner can add players");
        require(_skillLevel > 0 && _skillLevel <= 100, "Skill level must be between 1 and 100");

        playerCount++;
        players[playerCount] = Player({
            id: playerCount,
            name: _name,
            age: _age,
            position: _position,
            skillLevel: _skillLevel,
            isActive: true
        });

        teams[_teamId].playerIds.push(playerCount);
        updateTeamRating(_teamId);

        emit PlayerAdded(_teamId, playerCount, _name);
    }

    function removePlayer(uint256 _teamId, uint256 _playerId) public {
        require(teams[_teamId].owner == msg.sender, "Only team owner can remove players");
        require(players[_playerId].isActive, "Player is not active");

        players[_playerId].isActive = false;

        // Remove player from team
        uint256[] storage teamPlayers = teams[_teamId].playerIds;
        for (uint256 i = 0; i < teamPlayers.length; i++) {
            if (teamPlayers[i] == _playerId) {
                teamPlayers[i] = teamPlayers[teamPlayers.length - 1];
                teamPlayers.pop();
                break;
            }
        }

        updateTeamRating(_teamId);

        emit PlayerRemoved(_teamId, _playerId);
    }

    function updateTeamRating(uint256 _teamId) internal {
        uint256 totalSkill = 0;
        uint256 playerCount = 0;

        for (uint256 i = 0; i < teams[_teamId].playerIds.length; i++) {
            Player storage player = players[teams[_teamId].playerIds[i]];
            if (player.isActive) {
                totalSkill += player.skillLevel;
                playerCount++;
            }
        }

        if (playerCount > 0) {
            teams[_teamId].overallRating = totalSkill / playerCount;
        } else {
            teams[_teamId].overallRating = 0;
        }
    }

    function updateTeamStats(uint256 _teamId, bool _isWin, bool _isDraw, uint256 _goalsScored, uint256 _goalsConceded) public {
        require(teams[_teamId].owner == msg.sender, "Only team owner can update stats");

        if (_isWin) {
            teams[_teamId].wins++;
        } else if (_isDraw) {
            teams[_teamId].draws++;
        } else {
            teams[_teamId].losses++;
        }

        teams[_teamId].goalsScored += _goalsScored;
        teams[_teamId].goalsConceded += _goalsConceded;

        emit TeamStatsUpdated(_teamId, teams[_teamId].wins, teams[_teamId].draws, teams[_teamId].losses);
    }

    function getTeam(uint256 _teamId) public view returns (Team memory) {
        require(_teamId > 0 && _teamId <= teamCount, "Invalid team ID");
        return teams[_teamId];
    }

    function getPlayer(uint256 _playerId) public view returns (Player memory) {
        require(_playerId > 0 && _playerId <= playerCount, "Invalid player ID");
        return players[_playerId];
    }

    function getTeamPlayers(uint256 _teamId) public view returns (Player[] memory) {
        require(_teamId > 0 && _teamId <= teamCount, "Invalid team ID");
        
        uint256[] memory teamPlayerIds = teams[_teamId].playerIds;
        Player[] memory teamPlayers = new Player[](teamPlayerIds.length);

        for (uint256 i = 0; i < teamPlayerIds.length; i++) {
            teamPlayers[i] = players[teamPlayerIds[i]];
        }

        return teamPlayers;
    }
}