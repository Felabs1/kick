// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract LeagueManagement {
    struct League {
        uint256 leagueId;
        string name;
        address commissioner;
        uint256 maxTeams;
        uint256 seasonStartDate;
        uint256 seasonEndDate;
        uint256 joiningFee;
        uint256 prizPool;
        LeagueStatus status;
        uint256[] teamIds;
        mapping(uint256 => bool) isTeamInLeague;
        mapping(uint256 => mapping(uint256 => uint256)) weeklyScores;
    }

    enum LeagueStatus { Open, InProgress, Completed }

    mapping(uint256 => League) public leagues;
    uint256 public leagueCounter;

    event LeagueCreated(uint256 indexed leagueId, string name, address commissioner);
    event TeamJoined(uint256 indexed leagueId, uint256 indexed teamId);
    event LeagueStatusUpdated(uint256 indexed leagueId, LeagueStatus newStatus);
    event WeeklyScoreUpdated(uint256 indexed leagueId, uint256 indexed week, uint256 indexed teamId, uint256 score);
    event LeagueWinnerPaid(uint256 indexed leagueId, uint256 indexed winningTeamId, uint256 prizeAmount);

    modifier onlyCommissioner(uint256 _leagueId) {
        require(leagues[_leagueId].commissioner == msg.sender, "Only the commissioner can perform this action");
        _;
    }

    modifier leagueExists(uint256 _leagueId) {
        require(leagues[_leagueId].leagueId == _leagueId, "League does not exist");
        _;
    }

    function createLeague(
        string memory _name,
        uint256 _maxTeams,
        uint256 _seasonStartDate,
        uint256 _seasonEndDate,
        uint256 _joiningFee
    ) public returns (uint256) {
        leagueCounter++;
        uint256 newLeagueId = leagueCounter;

        League storage newLeague = leagues[newLeagueId];
        newLeague.leagueId = newLeagueId;
        newLeague.name = _name;
        newLeague.commissioner = msg.sender;
        newLeague.maxTeams = _maxTeams;
        newLeague.seasonStartDate = _seasonStartDate;
        newLeague.seasonEndDate = _seasonEndDate;
        newLeague.joiningFee = _joiningFee;
        newLeague.status = LeagueStatus.Open;

        emit LeagueCreated(newLeagueId, _name, msg.sender);
        return newLeagueId;
    }

    function joinLeague(uint256 _leagueId, uint256 _teamId) public payable leagueExists(_leagueId) {
        League storage league = leagues[_leagueId];
        require(league.status == LeagueStatus.Open, "League is not open for joining");
        require(league.teamIds.length < league.maxTeams, "League is full");
        require(!league.isTeamInLeague[_teamId], "Team already in the league");
        require(msg.value == league.joiningFee, "Incorrect joining fee");

        league.teamIds.push(_teamId);
        league.isTeamInLeague[_teamId] = true;
        league.prizPool += msg.value;

        emit TeamJoined(_leagueId, _teamId);
    }

    function updateLeagueStatus(uint256 _leagueId, LeagueStatus _newStatus) 
        public 
        onlyCommissioner(_leagueId) 
        leagueExists(_leagueId) 
    {
        leagues[_leagueId].status = _newStatus;
        emit LeagueStatusUpdated(_leagueId, _newStatus);
    }

    function updateWeeklyScore(uint256 _leagueId, uint256 _week, uint256 _teamId, uint256 _score) 
        public 
        onlyCommissioner(_leagueId) 
        leagueExists(_leagueId) 
    {
        require(leagues[_leagueId].isTeamInLeague[_teamId], "Team is not in the league");
        leagues[_leagueId].weeklyScores[_week][_teamId] = _score;
        emit WeeklyScoreUpdated(_leagueId, _week, _teamId, _score);
    }

    function getWeeklyScores(uint256 _leagueId, uint256 _week) 
        public 
        view 
        leagueExists(_leagueId) 
        returns (uint256[] memory, uint256[] memory) 
    {
        League storage league = leagues[_leagueId];
        uint256[] memory scores = new uint256[](league.teamIds.length);

        for (uint i = 0; i < league.teamIds.length; i++) {
            scores[i] = league.weeklyScores[_week][league.teamIds[i]];
        }

        return (league.teamIds, scores);
    }

    function getLeagueStandings(uint256 _leagueId) 
        public 
        view 
        leagueExists(_leagueId) 
        returns (uint256[] memory, uint256[] memory) 
    {
        League storage league = leagues[_leagueId];
        uint256[] memory teamIds = league.teamIds;
        uint256[] memory totalScores = new uint256[](teamIds.length);

        for (uint i = 0; i < teamIds.length; i++) {
            uint256 teamId = teamIds[i];
            uint256 totalScore = 0;
            for (uint week = league.seasonStartDate; week <= league.seasonEndDate; week++) {
                totalScore += league.weeklyScores[week][teamId];
            }
            totalScores[i] = totalScore;
        }

        // Sort teams by total score (descending)
        for (uint i = 0; i < teamIds.length - 1; i++) {
            for (uint j = 0; j < teamIds.length - i - 1; j++) {
                if (totalScores[j] < totalScores[j + 1]) {
                    (teamIds[j], teamIds[j + 1]) = (teamIds[j + 1], teamIds[j]);
                    (totalScores[j], totalScores[j + 1]) = (totalScores[j + 1], totalScores[j]);
                }
            }
        }

        return (teamIds, totalScores);
    }

    function payLeagueWinner(uint256 _leagueId) 
        public 
        onlyCommissioner(_leagueId) 
        leagueExists(_leagueId) 
    {
        League storage league = leagues[_leagueId];
        require(league.status == LeagueStatus.Completed, "League is not completed");
        require(league.prizPool > 0, "No prize pool available");

        (uint256[] memory rankedTeamIds, ) = getLeagueStandings(_leagueId);
        require(rankedTeamIds.length > 0, "No teams in the league");

        uint256 winningTeamId = rankedTeamIds[0];
        uint256 prizeAmount = league.prizPool;
        league.prizPool = 0;

        // Here you would typically transfer the prize to the winning team's contract or owner
        // For simplicity, we're just emitting an event
        emit LeagueWinnerPaid(_leagueId, winningTeamId, prizeAmount);

        // In a real implementation, you would add code here to transfer the funds
        // payable(winningTeamOwner).transfer(prizeAmount);
    }

    function getLeagueInfo(uint256 _leagueId) 
        public 
        view 
        leagueExists(_leagueId) 
        returns (
            string memory name,
            address commissioner,
            uint256 maxTeams,
            uint256 seasonStartDate,
            uint256 seasonEndDate,
            uint256 joiningFee,
            uint256 prizPool,
            LeagueStatus status,
            uint256 teamCount
        ) 
    {
        League storage league = leagues[_leagueId];
        return (
            league.name,
            league.commissioner,
            league.maxTeams,
            league.seasonStartDate,
            league.seasonEndDate,
            league.joiningFee,
            league.prizPool,
            league.status,
            league.teamIds.length
        );
    }
}