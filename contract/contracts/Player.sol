// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

contract Player {
    enum Position {QB, RB, WR, TE, K, DEF}

    enum Status {Active, Injured, Suspended}

    struct PlayerData {
        uint256 id;
        string name;
        Position position;
        string nflTeam;
        Status status;
        uint256 totalpoints;
    }

    mapping(uint256 => PlayerData) public players;

    uint256 private playerIdCounter;

    event PlayerAdded(uint256 indexed playerId, string name, Position position);
    event PlayerStatusUpdated(uint256 indexed playerId, Status newStatus);

    function addPlayer(string memory _name, Position _position, string memory _nflTeam) public returns (uint256) {
        playerIdCounter++;
        uint256 newPlayerId = playerIdCounter;

        players[newPlayerId] = PlayerData({
            id: newPlayerId,
            name: _name,
            position: _position,
            nflTeam: _nflTeam,
            status: Status.Active,
            totalPoints: 0
        });

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

}