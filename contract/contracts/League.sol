// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Player.sol";

contract League {

    struct Team {
        address owner;
        string name;
        uint256[] playerIds;
        uint256 totalPoints;
    }

    struct LeagueSettings {
        uint256 maxTeams;
        uint256 teamSize;
        uint256 seasonStartDate;
        uint256 seasonEndDate;
    }

    enum LeagueStatus { Open, InProgress, Completed }

    uint256 public leagueId;
    string public leagueName;
    address public commissioner;
    LeagueStatus public status;
    LeagueSettings public settings;

    mapping(address => Team) public teams;
    mapping(uint256 => mapping(address => uint256)) public weeklyScores;
    address[] public teamAddresses;

    Player public playerContract;

    event LeagueCreated(uint256 indexed leagueId, string name, address commissioner);
    event TeamJoined(uint256 indexed leagueId, address indexed teamOwner, string teamName);
    event PlayerDrafted(uint256 indexed leagueId, address indexed teamOwner, uint256 playerId);
    event LeagueStatusUpdated(uint256 indexed leagueId, LeagueStatus newStatus);
     event WeeklyScoreUpdated(uint256 indexed week, address indexed teamOwner, uint256 score);


    constructor(
        uint256 _leagueId,
        string memory _leagueName,
        address _commissioner,
        uint256 _maxTeams,
        uint256 _teamSize,
        uint256 _seasonStartDate,
        uint256 _seasonEndDate,
        address _playerContractAddress
    ) {
        leagueId = _leagueId;
        leagueName = _leagueName;
        commissioner = _commissioner;
        status = LeagueStatus.Open;
        settings = LeagueSettings({
            maxTeams: _maxTeams,
            teamSize: _teamSize,
            seasonStartDate: _seasonStartDate,
            seasonEndDate: _seasonEndDate
        });
        playerContract = Player(_playerContractAddress);

        emit LeagueCreated(leagueId, leagueName, commissioner);
    }

    modifier onlyCommissioner() {
        require(msg.sender == commissioner, "Only the commissioner can perform this action");
        _;
    }

    modifier leagueOpen() {
        require(status == LeagueStatus.Open, "League is not open for joining");
        _;
    }

    function joinLeague(string memory _teamName) public leagueOpen {
        require(teamAddresses.length < settings.maxTeams, "League is full");
        require(teams[msg.sender].owner == address(0), "Team already exists");

        teams[msg.sender] = Team({
            owner: msg.sender,
            name: _teamName,
            playerIds: new uint256[](0),
            totalPoints: 0
        });
        teamAddresses.push(msg.sender);

        emit TeamJoined(leagueId, msg.sender, _teamName);
    }

    function draftPlayer(uint256 _playerId) public {
        require(status == LeagueStatus.InProgress, "League is not in progress");
        require(teams[msg.sender].owner != address(0), "Team does not exist");
        require(teams[msg.sender].playerIds.length < settings.teamSize, "Team is full");

        require(playerContract.getPlayer(_playerId).id != 0, "Player does not exist");
        for (uint i = 0; i < teamAddresses.length; i++) {
            require(!isPlayerInTeam(teamAddresses[i], _playerId), "Player already drafted");
        }

        teams[msg.sender].playerIds.push(_playerId);
        emit PlayerDrafted(leagueId, msg.sender, _playerId);
    }

    function isPlayerInTeam(address _teamOwner, uint256 _playerId) internal view returns (bool) {
        uint256[] memory teamPlayerIds = teams[_teamOwner].playerIds;
        for (uint i = 0; i < teamPlayerIds.length; i++) {
            if (teamPlayerIds[i] == _playerId) {
                return true;
            }
        }
        return false;
    }

    function updateLeagueStatus(LeagueStatus _newStatus) public onlyCommissioner {
        status = _newStatus;
        emit LeagueStatusUpdated(leagueId, _newStatus);
    }

    function getTeamInfo(address _teamOwner) public view returns (Team memory) {
        require(teams[_teamOwner].owner != address(0), "Team does not exist");
        return teams[_teamOwner];
    }

    function getAllTeams() public view returns (address[] memory) {
        return teamAddresses;
    }

    function getWeeklyScores(uint256 _week) public view returns (address[] memory, uint256[] memory) {
        address[] memory teamOwners = new address[](teamAddresses.length);
        uint256[] memory scores = new uint256[](teamAddresses.length);

        for (uint i = 0; i < teamAddresses.length; i++) {
            teamOwners[i] = teamAddresses[i];
            scores[i] = weeklyScores[_week][teamAddresses[i]];
        }

        return (teamOwners, scores);
    }

    function getLeagueStandings() public view returns (address[] memory, uint256[] memory) {
        address[] memory teamOwners = new address[](teamAddresses.length);
        uint256[] memory totalScores = new uint256[](teamAddresses.length);

        for (uint i = 0; i < teamAddresses.length; i++) {
            teamOwners[i] = teamAddresses[i];
            totalScores[i] = teams[teamAddresses[i]].totalPoints;
        }

        for (uint i = 0; i < teamOwners.length - 1; i++) {
            for (uint j = 0; j < teamOwners.length - i - 1; j++) {
                if (totalScores[j] < totalScores[j + 1]) {
                    (teamOwners[j], teamOwners[j + 1]) = (teamOwners[j + 1], teamOwners[j]);
                    (totalScores[j], totalScores[j + 1]) = (totalScores[j + 1], totalScores[j]);
                }
            }
        }

        return (teamOwners, totalScores);
    }

    function replaceInjuredPlayer(uint256 _injuredPlayerId, uint256 _newPlayerId) public {
        require(teams[msg.sender].owner != address(0), "Team does not exist");
        require(playerContract.getPlayer(_injuredPlayerId).status == Player.Status.Injured, "Player is not injured");
        require(playerContract.getPlayer(_newPlayerId).status == Player.Status.Active, "New player is not active");

        uint256[] storage teamPlayerIds = teams[msg.sender].playerIds;
        bool playerFound = false;

        for (uint i = 0; i < teamPlayerIds.length; i++) {
            if (teamPlayerIds[i] == _injuredPlayerId) {
                teamPlayerIds[i] = _newPlayerId;
                playerFound = true;
                break;
            }
        }

        require(playerFound, "Injured player not found in team");
        emit PlayerDrafted(leagueId, msg.sender, _newPlayerId);
    }

}