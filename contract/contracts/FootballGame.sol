// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FootballGame {
    struct Team {
        uint256 id;
        string name;
        uint256 score;
    }

    struct GameEvent {
        uint256 minute;
        string eventType; // "Goal", "YellowCard", "RedCard", "Substitution"
        uint256 teamId;
        string playerName;
    }

    struct Game {
        uint256 id;
        uint256 date;
        Team homeTeam;
        Team awayTeam;
        bool isFinished;
        address referee;
    }

    mapping(uint256 => Game) public games;
    mapping(uint256 => GameEvent[]) public gameEvents;
    uint256 public gameCount;

    event GameKicked(uint256 indexed gameId, uint256 date, string homeTeam, string awayTeam);
    event GoalScored(uint256 indexed gameId, uint256 minute, uint256 teamId, string scorerName);
    event CardIssued(uint256 indexed gameId, uint256 minute, uint256 teamId, string playerName, string cardType);
    event Substitution(uint256 indexed gameId, uint256 minute, uint256 teamId, string playerOut, string playerIn);
    event GameFinished(uint256 indexed gameId, uint256 homeScore, uint256 awayScore);

    function kickGame(
        uint256 _date,
        uint256 _homeTeamId,
        string memory _homeTeamName,
        uint256 _awayTeamId,
        string memory _awayTeamName,
        address _referee
    ) public returns (uint256) {
        gameCount++;
        games[gameCount] = Game({
            id: gameCount,
            date: _date,
            homeTeam: Team({
                id: _homeTeamId,
                name: _homeTeamName,
                score: 0
            }),
            awayTeam: Team({
                id: _awayTeamId,
                name: _awayTeamName,
                score: 0
            }),
            isFinished: false,
            referee: _referee
        });

        emit GameKicked(gameCount, _date, _homeTeamName, _awayTeamName);
        return gameCount;
    }

    function addGoal(uint256 _gameId, uint256 _minute, bool _isHomeTeam, string memory _scorerName) public {
        require(!games[_gameId].isFinished, "Game is already finished");
        
        Game storage game = games[_gameId];
        if (_isHomeTeam) {
            game.homeTeam.score++;
            emit GoalScored(_gameId, _minute, game.homeTeam.id, _scorerName);
        } else {
            game.awayTeam.score++;
            emit GoalScored(_gameId, _minute, game.awayTeam.id, _scorerName);
        }

        gameEvents[_gameId].push(GameEvent({
            minute: _minute,
            eventType: "Goal",
            teamId: _isHomeTeam ? game.homeTeam.id : game.awayTeam.id,
            playerName: _scorerName
        }));
    }

    function addCard(uint256 _gameId, uint256 _minute, bool _isHomeTeam, string memory _playerName, string memory _cardType) public {
        require(!games[_gameId].isFinished, "Game is already finished");
        require(keccak256(abi.encodePacked(_cardType)) == keccak256(abi.encodePacked("Yellow")) || 
                keccak256(abi.encodePacked(_cardType)) == keccak256(abi.encodePacked("Red")), 
                "Invalid card type");

        Game storage game = games[_gameId];
        uint256 teamId = _isHomeTeam ? game.homeTeam.id : game.awayTeam.id;

        gameEvents[_gameId].push(GameEvent({
            minute: _minute,
            eventType: string(abi.encodePacked(_cardType, "Card")),
            teamId: teamId,
            playerName: _playerName
        }));

        emit CardIssued(_gameId, _minute, teamId, _playerName, _cardType);
    }

    function addSubstitution(uint256 _gameId, uint256 _minute, bool _isHomeTeam, string memory _playerOut, string memory _playerIn) public {
        require(!games[_gameId].isFinished, "Game is already finished");

        Game storage game = games[_gameId];
        uint256 teamId = _isHomeTeam ? game.homeTeam.id : game.awayTeam.id;

        gameEvents[_gameId].push(GameEvent({
            minute: _minute,
            eventType: "Substitution",
            teamId: teamId,
            playerName: string(abi.encodePacked(_playerOut, " -> ", _playerIn))
        }));

        emit Substitution(_gameId, _minute, teamId, _playerOut, _playerIn);
    }

    function finishGame(uint256 _gameId) public {
        require(!games[_gameId].isFinished, "Game is already finished");
        
        Game storage game = games[_gameId];
        game.isFinished = true;

        emit GameFinished(_gameId, game.homeTeam.score, game.awayTeam.score);
    }

    function getGame(uint256 _gameId) public view returns (Game memory) {
        require(_gameId > 0 && _gameId <= gameCount, "Invalid game ID");
        return games[_gameId];
    }

    function getGameEvents(uint256 _gameId) public view returns (GameEvent[] memory) {
        require(_gameId > 0 && _gameId <= gameCount, "Invalid game ID");
        return gameEvents[_gameId];
    }

    function getGameScore(uint256 _gameId) public view returns (uint256, uint256) {
        require(_gameId > 0 && _gameId <= gameCount, "Invalid game ID");
        Game memory game = games[_gameId];
        return (game.homeTeam.score, game.awayTeam.score);
    }
}