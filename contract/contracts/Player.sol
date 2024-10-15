// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


contract KickPlayerNFT is ERC721, Ownable, ReentrancyGuard {
    uint256 private _nextTokenId;

    enum Position { GK, DEF, MID, FWD }
    enum Status { Active, Injured, Suspended }

    struct PlayerData {
        uint256 id;
        string name;
        Position position;
        string club;
        Status status;
        uint16 age;
        uint16 height; // in cm
        uint16 weight; // in kg
    }

    struct PhysicalAttributes {
        uint8 pace;
        uint8 acceleration;
        uint8 stamina;
        uint8 strength;
        uint8 agility;
        uint8 balance;
    }

    struct TechnicalAttributes {
        uint8 ballControl;
        uint8 dribbling;
        uint8 shortPassing;
        uint8 longPassing;
        uint8 shotPower;
        uint8 finishing;
        uint8 heading;
        uint8 volleys;
    }

    struct MentalAttributes {
        uint8 vision;
        uint8 positioning;
        uint8 reactions;
        uint8 composure;
        uint8 aggression;
        uint8 interceptions;
    }

    struct GoalkeeperAttributes {
        uint8 diving;
        uint8 handling;
        uint8 kicking;
        uint8 reflexes;
        uint8 positioning;
    }

    struct CareerStats {
        uint16 appearances;
        uint16 goals;
        uint16 assists;
        uint16 cleanSheets;
    }

    struct MarketListing {
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => PlayerData) public players;
    mapping(uint256 => PhysicalAttributes) public physicalAttributes;
    mapping(uint256 => TechnicalAttributes) public technicalAttributes;
    mapping(uint256 => MentalAttributes) public mentalAttributes;
    mapping(uint256 => GoalkeeperAttributes) public goalkeeperAttributes;
    mapping(uint256 => CareerStats) public careerStats;
    mapping(uint256 => MarketListing) public marketListings;

    event PlayerMinted(uint256 indexed tokenId, string name, Position position);
    event PlayerAttributesUpdated(uint256 indexed tokenId);
    event PlayerListed(uint256 indexed tokenId, uint256 price);
    event PlayerUnlisted(uint256 indexed tokenId);
    event PlayerSold(uint256 indexed tokenId, address from, address to, uint256 price);

    constructor(address initialOwner) ERC721("Kick Player NFT", "KICKPLAYER") Ownable(initialOwner) {}

    function mintPlayer(
        string memory _name,
        Position _position,
        string memory _club,
        uint16 _age,
        uint16 _height,
        uint16 _weight
    ) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);

        players[tokenId] = PlayerData({
            id: tokenId,
            name: _name,
            position: _position,
            club: _club,
            status: Status.Active,
            age: _age,
            height: _height,
            weight: _weight
        });

        emit PlayerMinted(tokenId, _name, _position);
        return tokenId;
    }

    function setPhysicalAttributes(
        uint256 _tokenId,
        uint8 _pace,
        uint8 _acceleration,
        uint8 _stamina,
        uint8 _strength,
        uint8 _agility,
        uint8 _balance
    ) public onlyOwner {
        require(_ownerOf(_tokenId) != address(0), "Player does not exist");
        physicalAttributes[_tokenId] = PhysicalAttributes({
            pace: _pace,
            acceleration: _acceleration,
            stamina: _stamina,
            strength: _strength,
            agility: _agility,
            balance: _balance
        });
        emit PlayerAttributesUpdated(_tokenId);
    }

    function setTechnicalAttributes(
        uint256 _tokenId,
        uint8 _ballControl,
        uint8 _dribbling,
        uint8 _shortPassing,
        uint8 _longPassing,
        uint8 _shotPower,
        uint8 _finishing,
        uint8 _heading,
        uint8 _volleys
    ) public onlyOwner {
        require(_exists(_tokenId), "Player does not exist");
        technicalAttributes[_tokenId] = TechnicalAttributes({
            ballControl: _ballControl,
            dribbling: _dribbling,
            shortPassing: _shortPassing,
            longPassing: _longPassing,
            shotPower: _shotPower,
            finishing: _finishing,
            heading: _heading,
            volleys: _volleys
        });
        emit PlayerAttributesUpdated(_tokenId);
    }

    function setMentalAttributes(
        uint256 _tokenId,
        uint8 _vision,
        uint8 _positioning,
        uint8 _reactions,
        uint8 _composure,
        uint8 _aggression,
        uint8 _interceptions
    ) public onlyOwner {
        require(_exists(_tokenId), "Player does not exist");
        mentalAttributes[_tokenId] = MentalAttributes({
            vision: _vision,
            positioning: _positioning,
            reactions: _reactions,
            composure: _composure,
            aggression: _aggression,
            interceptions: _interceptions
        });
        emit PlayerAttributesUpdated(_tokenId);
    }

    function setGoalkeeperAttributes(
        uint256 _tokenId,
        uint8 _diving,
        uint8 _handling,
        uint8 _kicking,
        uint8 _reflexes,
        uint8 _positioning
    ) public onlyOwner {
        require(_exists(_tokenId), "Player does not exist");
        require(players[_tokenId].position == Position.GK, "Player is not a goalkeeper");
        goalkeeperAttributes[_tokenId] = GoalkeeperAttributes({
            diving: _diving,
            handling: _handling,
            kicking: _kicking,
            reflexes: _reflexes,
            positioning: _positioning
        });
        emit PlayerAttributesUpdated(_tokenId);
    }

    function updateCareerStats(
        uint256 _tokenId,
        uint16 _appearances,
        uint16 _goals,
        uint16 _assists,
        uint16 _cleanSheets
    ) public onlyOwner {
        require(_exists(_tokenId), "Player does not exist");
        CareerStats storage stats = careerStats[_tokenId];
        stats.appearances += _appearances;
        stats.goals += _goals;
        stats.assists += _assists;
        stats.cleanSheets += _cleanSheets;
    }


    function getPlayer(uint256 _tokenId) public view returns (PlayerData memory) {
        require(_exists(_tokenId), "Player does not exist");
        return players[_tokenId];
    }

    function getPhysicalAttributes(uint256 _tokenId) public view returns (PhysicalAttributes memory) {
        require(_exists(_tokenId), "Player does not exist");
        return physicalAttributes[_tokenId];
    }

    function getTechnicalAttributes(uint256 _tokenId) public view returns (TechnicalAttributes memory) {
        require(_exists(_tokenId), "Player does not exist");
        return technicalAttributes[_tokenId];
    }

    function getMentalAttributes(uint256 _tokenId) public view returns (MentalAttributes memory) {
        require(_exists(_tokenId), "Player does not exist");
        return mentalAttributes[_tokenId];
    }

    function getGoalkeeperAttributes(uint256 _tokenId) public view returns (GoalkeeperAttributes memory) {
        require(_exists(_tokenId), "Player does not exist");
        require(players[_tokenId].position == Position.GK, "Player is not a goalkeeper");
        return goalkeeperAttributes[_tokenId];
    }

    function getCareerStats(uint256 _tokenId) public view returns (CareerStats memory) {
        require(_exists(_tokenId), "Player does not exist");
        return careerStats[_tokenId];
    }

    // New marketplace functions
    function listPlayer(uint256 _tokenId, uint256 _price) public {
        require(_ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(_price > 0, "Price must be greater than zero");
        marketListings[_tokenId] = MarketListing(_price, true);
        emit PlayerListed(_tokenId, _price);
    }

    function unlistPlayer(uint256 _tokenId) public {
        require(_ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(marketListings[_tokenId].isListed, "Player not listed");
        delete marketListings[_tokenId];
        emit PlayerUnlisted(_tokenId);
    }

    function buyPlayer(uint256 _tokenId) public payable nonReentrant {
        MarketListing memory listing = marketListings[_tokenId];
        require(listing.isListed, "Player not listed for sale");
        require(msg.value >= listing.price, "Insufficient payment");

        address seller = _ownerOf(_tokenId);
        _safeTransfer(seller, msg.sender, _tokenId, "");

        // Transfer the payment to the seller
        (bool sent, ) = payable(seller).call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        delete marketListings[_tokenId];

        emit PlayerSold(_tokenId, seller, msg.sender, msg.value);
    }

    function transferFrom(
            address from,
            address to,
            uint256 tokenId
        ) public virtual override {
            super.transferFrom(from, to, tokenId);
            _unlistPlayerIfListed(tokenId);
        }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        super.safeTransferFrom(from, to, tokenId, data);
        _unlistPlayerIfListed(tokenId);
    }

    function _unlistPlayerIfListed(uint256 tokenId) internal {
        if (marketListings[tokenId].isListed) {
            delete marketListings[tokenId];
            emit PlayerUnlisted(tokenId);
        }
    }

        // Implement _exists function to check if player exists
    function _exists(uint256 _tokenId) internal view returns (bool) {
        return players[_tokenId].id != 0; // Check for valid player ID
    }

}