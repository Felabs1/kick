// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract FootballManagers {
    struct PersonalInfo {
        string name;
        uint256 age;
        string nationality;
    }

    struct ManagerialSkills {
        uint256 tacticalAbility;
        uint256 playerManagement;
        uint256 youngPlayerDevelopment;
        uint256 motivationAbility;
        uint256 disciplineManagement;
        uint256 financialManagement;
        uint256 mediaHandling;
    }

    struct CareerStats {
        uint256 experience; // in years
        uint256 reputation;
        uint256[] managedTeams;
        uint256[] trophiesWon;
        uint256 totalMatchesManaged;
        uint256 totalWins;
        uint256 totalDraws;
        uint256 totalLosses;
    }

    struct ManagerStyle {
        string[] preferredFormations;
        string preferredPlayingStyle;
        string[] specialties;
    }

    struct FinancialInfo {
        uint256 lastContractValue;
        uint256 careerEarnings;
    }

    struct Manager {
        PersonalInfo personalInfo;
        ManagerialSkills skills;
        CareerStats careerStats;
        ManagerStyle style;
        FinancialInfo financials;
        uint256 lastSeasonPerformance;
    }

    mapping(address => Manager) public managers;
    mapping(address => bool) public registeredManagers;
    uint256 public managerCount;

    // Default starting values for manager skills
    uint256 public constant DEFAULT_SKILL_VALUE = 50;

    event ManagerAdded(address indexed managerAddress, string name);
    event ManagerUpdated(address indexed managerAddress, string name);
    event ManagerSkillsImproved(address indexed managerAddress, uint256 tacticalAbility, uint256 playerManagement, uint256 youngPlayerDevelopment);

    function addManager(
        string memory _name,
        uint256 _age,
        string memory _nationality,
        uint256 _experience,
        string[] memory _preferredFormations,
        string memory _preferredPlayingStyle,
        string[] memory _specialties
    ) public {
        require(!registeredManagers[msg.sender], "Manager already registered");

        managers[msg.sender] = Manager({
            personalInfo: PersonalInfo({
                name: _name,
                age: _age,
                nationality: _nationality
            }),
            skills: ManagerialSkills({
                tacticalAbility: DEFAULT_SKILL_VALUE,
                playerManagement: DEFAULT_SKILL_VALUE,
                youngPlayerDevelopment: DEFAULT_SKILL_VALUE,
                motivationAbility: DEFAULT_SKILL_VALUE,
                disciplineManagement: DEFAULT_SKILL_VALUE,
                financialManagement: DEFAULT_SKILL_VALUE,
                mediaHandling: DEFAULT_SKILL_VALUE
            }),
            careerStats: CareerStats({
                experience: _experience,
                reputation: 50,
                managedTeams: new uint256[](0),
                trophiesWon: new uint256[](0),
                totalMatchesManaged: 0,
                totalWins: 0,
                totalDraws: 0,
                totalLosses: 0
            }),
            style: ManagerStyle({
                preferredFormations: _preferredFormations,
                preferredPlayingStyle: _preferredPlayingStyle,
                specialties: _specialties
            }),
            financials: FinancialInfo({
                lastContractValue: 0,
                careerEarnings: 0
            }),
            lastSeasonPerformance: 50
        });

        registeredManagers[msg.sender] = true;
        managerCount++;

        emit ManagerAdded(msg.sender, _name);
    }

    function updateManagerStyle(string[] memory _preferredFormations, string memory _preferredPlayingStyle) public {
        require(registeredManagers[msg.sender], "Manager does not exist");

        Manager storage manager = managers[msg.sender];
        manager.style.preferredFormations = _preferredFormations;
        manager.style.preferredPlayingStyle = _preferredPlayingStyle;

        emit ManagerUpdated(msg.sender, manager.personalInfo.name);
    }

    function improveManagerSkills(uint256 _tacticalImprovement, uint256 _playerManagementImprovement, uint256 _youngPlayerDevelopmentImprovement) public {
        require(registeredManagers[msg.sender], "Manager does not exist");
        
        Manager storage manager = managers[msg.sender];
        
        manager.skills.tacticalAbility = min(manager.skills.tacticalAbility + _tacticalImprovement, 100);
        manager.skills.playerManagement = min(manager.skills.playerManagement + _playerManagementImprovement, 100);
        manager.skills.youngPlayerDevelopment = min(manager.skills.youngPlayerDevelopment + _youngPlayerDevelopmentImprovement, 100);

        emit ManagerSkillsImproved(msg.sender, manager.skills.tacticalAbility, manager.skills.playerManagement, manager.skills.youngPlayerDevelopment);
    }

    function updateCareerStats(
        uint256 _matchesManaged,
        uint256 _wins,
        uint256 _draws,
        uint256 _losses,
        uint256 _lastContractValue,
        uint256 _lastSeasonPerformance
    ) public {
        require(registeredManagers[msg.sender], "Manager does not exist");

        Manager storage manager = managers[msg.sender];
        manager.careerStats.totalMatchesManaged += _matchesManaged;
        manager.careerStats.totalWins += _wins;
        manager.careerStats.totalDraws += _draws;
        manager.careerStats.totalLosses += _losses;
        manager.financials.lastContractValue = _lastContractValue;
        manager.financials.careerEarnings += _lastContractValue;
        manager.lastSeasonPerformance = _lastSeasonPerformance;

        // Simple reputation adjustment based on performance
        if (_lastSeasonPerformance > 75) {
            manager.careerStats.reputation = min(manager.careerStats.reputation + 5, 100);
        } else if (_lastSeasonPerformance < 25) {
            manager.careerStats.reputation = max(manager.careerStats.reputation - 5, 0);
        }
    }

    function addTrophyToManager(uint256 _trophyId) public {
        require(registeredManagers[msg.sender], "Manager does not exist");

        Manager storage manager = managers[msg.sender];
        manager.careerStats.trophiesWon.push(_trophyId);
        manager.careerStats.reputation = min(manager.careerStats.reputation + 2, 100);
    }

    function getManager(address _managerAddress) public view returns (Manager memory) {
        require(registeredManagers[_managerAddress], "Manager does not exist");
        return managers[_managerAddress];
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }

    function max(uint256 a, uint256 b) private pure returns (uint256) {
        return a > b ? a : b;
    }

        function updatePersonalInfo(uint256 _newAge) public {
        require(registeredManagers[msg.sender], "Manager does not exist");
        managers[msg.sender].personalInfo.age = _newAge;
    }

    function improveSpecificSkill(string memory _skillName, uint256 _improvement) public {
        require(registeredManagers[msg.sender], "Manager does not exist");
        Manager storage manager = managers[msg.sender];
        
        if (keccak256(abi.encodePacked(_skillName)) == keccak256(abi.encodePacked("motivationAbility"))) {
            manager.skills.motivationAbility = min(manager.skills.motivationAbility + _improvement, 100);
        } else if (keccak256(abi.encodePacked(_skillName)) == keccak256(abi.encodePacked("disciplineManagement"))) {
            manager.skills.disciplineManagement = min(manager.skills.disciplineManagement + _improvement, 100);
        } else if (keccak256(abi.encodePacked(_skillName)) == keccak256(abi.encodePacked("financialManagement"))) {
            manager.skills.financialManagement = min(manager.skills.financialManagement + _improvement, 100);
        } else if (keccak256(abi.encodePacked(_skillName)) == keccak256(abi.encodePacked("mediaHandling"))) {
            manager.skills.mediaHandling = min(manager.skills.mediaHandling + _improvement, 100);
        } else {
            revert("Invalid skill name");
        }
    }

    function addManagedTeam(uint256 _teamId) public {
        require(registeredManagers[msg.sender], "Manager does not exist");
        managers[msg.sender].careerStats.managedTeams.push(_teamId);
    }

    function updateFinancials(uint256 _newContractValue) public {
        require(registeredManagers[msg.sender], "Manager does not exist");
        Manager storage manager = managers[msg.sender];
        manager.financials.careerEarnings += _newContractValue - manager.financials.lastContractValue;
        manager.financials.lastContractValue = _newContractValue;
    }

    function addSpecialty(string memory _newSpecialty) public {
        require(registeredManagers[msg.sender], "Manager does not exist");
        managers[msg.sender].style.specialties.push(_newSpecialty);
    }

    function getManagerWinRate(address _managerAddress) public view returns (uint256) {
        require(registeredManagers[_managerAddress], "Manager does not exist");
        Manager memory manager = managers[_managerAddress];
        if (manager.careerStats.totalMatchesManaged == 0) {
            return 0;
        }
        return (manager.careerStats.totalWins * 100) / manager.careerStats.totalMatchesManaged;
    }

    function compareManagers(address _manager1, address _manager2) public view returns (address) {
        require(registeredManagers[_manager1] && registeredManagers[_manager2], "One or both managers do not exist");
        
        uint256 score1 = calculateManagerScore(_manager1);
        uint256 score2 = calculateManagerScore(_manager2);
        
        return score1 > score2 ? _manager1 : _manager2;
    }

    function calculateManagerScore(address _managerAddress) private view returns (uint256) {
        Manager memory manager = managers[_managerAddress];
        return 
            manager.skills.tacticalAbility +
            manager.skills.playerManagement +
            manager.skills.youngPlayerDevelopment +
            manager.careerStats.reputation +
            (manager.careerStats.trophiesWon.length * 5) +
            getManagerWinRate(_managerAddress);
    }

    function getManagerTrophyCount(address _managerAddress) public view returns (uint256) {
        require(registeredManagers[_managerAddress], "Manager does not exist");
        return managers[_managerAddress].careerStats.trophiesWon.length;
    }

    function isEligibleForPromotion(address _managerAddress) public view returns (bool) {
        require(registeredManagers[_managerAddress], "Manager does not exist");
        Manager memory manager = managers[_managerAddress];
        return 
            manager.careerStats.reputation >= 75 &&
            getManagerWinRate(_managerAddress) > 60 &&
            manager.careerStats.trophiesWon.length > 0;
    }

}