// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

contract Season {
    struct SeasonInfo {
        string league;
        string season;
        string startDate;
        string endDate;
    }

    struct SeasonRecords {
        string biggestWin;
        string highestScoringGame;
        string longestWinningStreak;
        string longestUnbeatenRun;
    }

    struct Transfers {
        string[] summer_transfer_window;
        string[] winter_transfer_window;
    }

    struct Injuries {
        string longest_injury;
        string most_injury_prone_team;
    }

    struct DisciplinaryRecord {
        string most_red_cards;
        string most_yellow_cards;
        string team_fair_play_awards;
    }

    struct EuropeanQualification {
        string[] championsLeague;
        string[] europaLeague;
        string[] conferenceLeague;
    }

    string[] public relegatedTeams;

    struct EndOfSeasonAwards {
        string playerOfTheSeasonAward;
        string youngPlayerOfTheSeason;
        string managerOfTheSeason;
        string goalOfTheSeason;
    }

    struct Player {
        string name;
        uint goals;
        uint assists;
        uint cleanSheets;
        uint saves;
    }

    struct Team {
        string name;
        Player[] players;
        uint points;
        uint lastFiveMatchesPoints; // track last five matches' points
    }

    Team[] public leagueTable;

    // Add a team to the league table
    // function addTeam(string memory _name) public {
    //     Team memory newTeam;
    //     newTeam.name = _name;
    //     newTeam.players = new Player[](0);
    //     newTeam.points = 0;git pu
    //     newTeam.lastFiveMatchesPoints = 0;
    //     leagueTable.push(newTeam);
    // }

    // Add a player to a specific team
    function addPlayerToTeam(uint _teamIndex, string memory _name, uint _goals, uint _assists, uint _cleanSheets, uint _saves) public {
        leagueTable[_teamIndex].players.push(Player(_name, _goals, _assists, _cleanSheets, _saves));
    }

    // Method to find top scorers
    function findTopScorers() public view returns (string memory topScorerName, uint topGoals) {
        topGoals = 0;
        string memory topScorerNameTemp;
        for (uint i = 0; i < leagueTable.length; i++) {
            for (uint j = 0; j < leagueTable[i].players.length; j++) {
                if (leagueTable[i].players[j].goals > topGoals) {
                    topGoals = leagueTable[i].players[j].goals;
                    topScorerNameTemp = leagueTable[i].players[j].name;
                }
            }
        }
        return (topScorerNameTemp, topGoals);
    }

    // Method to fetch the league table
    function fetchLeagueTable() public view returns (Team[] memory) {
        return leagueTable;
    }

    // Method to find the top assisters
    function findTopAssisters() public view returns (string memory topAssisterName, uint topAssists) {
        topAssists = 0;
        string memory topAssisterNameTemp;
        for (uint i = 0; i < leagueTable.length; i++) {
            for (uint j = 0; j < leagueTable[i].players.length; j++) {
                if (leagueTable[i].players[j].assists > topAssists) {
                    topAssists = leagueTable[i].players[j].assists;
                    topAssisterNameTemp = leagueTable[i].players[j].name;
                }
            }
        }
        return (topAssisterNameTemp, topAssists);
    }

    // Method to find the top goalkeepers
    function findTopGoalkeepers() public view returns (string memory topGoalkeeperName, uint topCleanSheets) {
        topCleanSheets = 0;
        string memory topGoalkeeperNameTemp;
        for (uint i = 0; i < leagueTable.length; i++) {
            for (uint j = 0; j < leagueTable[i].players.length; j++) {
                if (leagueTable[i].players[j].cleanSheets > topCleanSheets) {
                    topCleanSheets = leagueTable[i].players[j].cleanSheets;
                    topGoalkeeperNameTemp = leagueTable[i].players[j].name;
                }
            }
        }
        return (topGoalkeeperNameTemp, topCleanSheets);
    }

    // Method to find the number of clean sheets
    function findCleanSheets() public view returns (string memory teamName, uint cleanSheets) {
        cleanSheets = 0;
        string memory teamNameTemp;
        for (uint i = 0; i < leagueTable .length; i++) {
            uint teamCleanSheets = 0;
            for (uint j = 0; j < leagueTable[i].players.length; j++) {
                teamCleanSheets += leagueTable[i].players[j].cleanSheets;
            }
            if (teamCleanSheets > cleanSheets) {
                cleanSheets = teamCleanSheets;
                teamNameTemp = leagueTable[i].name;
            }
        }
        return (teamNameTemp, cleanSheets);
    }

    // Method to find the team name with its data for the last five matches
    function findTeamLastFiveMatchesData(string memory _teamName) public view returns (string memory name, uint lastFivePoints) {
        for (uint i = 0; i < leagueTable.length; i++) {
            if (keccak256(abi.encodePacked(leagueTable[i].name)) == keccak256(abi.encodePacked(_teamName))) {
                return (leagueTable[i].name, leagueTable[i].lastFiveMatchesPoints);
            }
        }
        return ("", 0);
    }
}