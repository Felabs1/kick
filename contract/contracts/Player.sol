// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26; 

contract Player {
    enum Position {QB, RB, WR, TE, K, DEF}

    enum Status {Active, Injured, Suspended}
    enum InjuryServerity {Minor, Moderate, Severe}

    struct PlayerData {
        uint256 id;
        string name;
        Position position;
        string nflTeam;
        Status status;
        uint256 totalpoints;
    }

    struct PerformanceStats {
        uint256 passingYards;
        uint256 rushingYards;
        uint256 receivingYards;
        uint256 totalTouchdowns;
        uint256 fumbles;
        uint256 interceptions;
    }

    struct InjuryDetails {
        string injuryType;
        InjuryServerity severity;
        uint256 estimatedRecoveryTime;
    }

    mapping(uint256 => PlayerData) public players;
    mapping(uint256 => PerformanceStats) public playerStats;
    mapping(uint256 => InjuryDetails) public playerInjuries;
    mapping(uint256 => uint256[]) public playerGameHistory;

    uint256 private playerIdCounter;

    event PlayerAdded(uint256 indexed playerId, string name, Position position);
    event PlayerStatusUpdated(uint256 indexed playerId, Status newStatus);
    event PlayerStatsUpdated(uint256 indexed playerId, uint256 passingYards, uint256 rushingYards, uint256 receivingYards);
    event PlayerInjuryReported(uint256 indexed playerId, string injuryType, InjuryServerity severity);
    event PlayerGameRecorded(uint256 indexed playerId, uint256 gameId, uint256 points);

    function addPlayer(string memory _name, Position _position, string memory _nflTeam) public returns (uint256) {
        playerIdCounter++;
        uint256 newPlayerId = playerIdCounter;

        players[newPlayerId] = PlayerData(
            newPlayerId,
            _name,
            _position,
            _nflTeam,
            Status.Active,
            0
        );

        emit PlayerAdded(newPlayerId, _name, _position);
        return newPlayerId;
    }

    function updatePlayerStatus(uint256 _playerId, Status _newStatus) public {
        require(players[_playerId].id != 0, "Player does not exist");
        players[_playerId].status = _newStatus;
        emit PlayerStatusUpdated(_playerId, _newStatus);
    }

    function updatePlayerPoints(uint256 _playerId, uint256 _points) public {
        require(players[_playerId].id != 0, "Player does not exist");
        players[_playerId].totalpoints += _points;
    }

    function getPlayer(uint256 _playerId) public view returns (PlayerData memory) {
        require(players[_playerId].id != 0, "Player does not exist");
        return players[_playerId];
    }

    function updatePlayerStats(
        uint256 _playerId, 
        uint256 _passingYards, 
        uint256 _rushingYards, 
        uint256 _receivingYards, 
        uint256 _totalTouchdowns, 
        uint256 _fumbles, 
        uint256 _interceptions) public {

        require(players[_playerId].id != 0, "Player does not exist");
        playerStats[_playerId] = PerformanceStats({
            passingYards: _passingYards,
            rushingYards: _rushingYards,
            receivingYards: _receivingYards,
            totalTouchdowns: _totalTouchdowns,
            fumbles: _fumbles,
            interceptions: _interceptions
        });

        emit PlayerStatsUpdated(_playerId, _passingYards, _rushingYards, _receivingYards);
    }

    function reportPlayerInjury(uint256 _playerId, string memory _injuryType, InjuryServerity _severity, uint256 _estimatedRecoveryTime) public {
        require(players[_playerId].id != 0, "Player does not exist");
        playerInjuries[_playerId] = InjuryDetails({
            injuryType: _injuryType,
            severity: _severity,
            estimatedRecoveryTime: _estimatedRecoveryTime
        });
        players[_playerId].status = Status.Injured;

        emit PlayerInjuryReported(_playerId, _injuryType, _severity);
    }

    function recordPlayerGame(uint256 _playerId, uint256 _gameId, uint256 _points) public {
        require(players[_playerId].id !=0, "Player does not exist");
        playerGameHistory[_playerId].push(_gameId);
        updatePlayerPoints(_playerId, _points);

        emit PlayerGameRecorded(_playerId, _gameId, _points);
    }

    function getPlayerStats(uint256 _playerId) public view returns (PerformanceStats memory) {
        require(players[_playerId].id != 0, "Player does not exist");
        return playerStats[_playerId];
    }

    function getPlayerInjuryDetails(uint256 _playerId) public view returns (InjuryDetails memory) {
        require(players[_playerId].id != 0, "Player does not exist");
        return playerInjuries[_playerId];
    }

    function getPlayerGameHistory(uint256 _playerId) public view returns (uint256[] memory) {
        require(players[_playerId].id != 0, "Player does not exist");
        return playerGameHistory[_playerId];
    }

}