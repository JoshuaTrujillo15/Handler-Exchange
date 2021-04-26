//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract HandlerX {

    // ----- STRUCTS ----- //

    // For client created gigs
    struct GigStruct {
        address contractor;
        address client;
        address handler;
        string service;
        uint256 amount;
        uint256 duration;
        uint256 increments;
        uint256 handlerFee;
        bool active;
        bool refunding;
        bool complete;
        bool contractorAccepted;
    }

    // For offers written by contractors
    struct OfferStruct {
        address contractor;
        string personalName;
        string personalTitle;
        string service;
        string emailAddress;
        bytes4 primaryColor;
        bytes4 secondaryColor;
    }

    // For indexing the Gig in a database
    struct GigIndex {
        address user;
        uint256 index;
    }

    // For indexing the Offer in a database
    struct OfferIndex {
        address contractor;
        uint256 index;
    }

    // ---- DECLARATIONS ----- //

    address payable public owner;

    // addresses default to 0, handler fee MUST NOT equal 0 to be valid
    mapping(address => uint256) HandlerFee;

    // ----- EVENTS ----- //
    event LogCreateOffer(address indexed _contractor);

    event LogCreateGig(address indexed _contractor, address indexed _client, address indexed _handler, string _service, uint256 amount, uint256 duration);


    // ----- FUNCTIONS ----- //
    // FOR CONTRACTORS
    function createOffer(
        string calldata _personalName,
        string calldata _personalTitle,
        string calldata _service,
        string calldata _emailAddress,
        bytes4 _primaryColor,
        bytes4 _secondaryColor
    )
        public
        returns (bool)
    {
        OfferStruct memory offer;
        OfferIndex memory offerIndex;

        offer.contractor = msg.sender;
        offer.personalName = _personalName;
        offer.personalTitle = _personalTitle;
        offer.service = _service;
        offer.emailAddress = _emailAddress;
        offer.primaryColor = _primaryColor;
        offer.secondaryColor = _secondaryColor;
        
        // offerIndex.user = msg.sender;
        // offerIndex.index = offerDatabase[msg.sender].length;

        
    }

    // FOR CLIENTS

    function createGig(
        address _contractor,
        address _handler,
        bytes32 _service,
        uint256 _amount,
        uint256 _duration,
        uint256 _increments
    )
        public
        payable
        returns (bool)
    {
        require(msg.value > 0 && msg.sender != _handler, "`msg.sender` Can Not Be The Handler");
        require(isHandlerRegistered(_handler), "Handler Not Registered");

        GigStruct memory gig;
        gig.contractor = _contractor;
        gig.client = msg.sender;
        gig.handler = _handler;
        gig.service = _service;
        gig.amount = _amount;
        gig.duration = _duration;
        gig.increments = _increments;
        gig.handlerFee = getHandlerFee(_handler, msg.value);
        gig.active = true;
        gig.refunding = false;
        gig.complete = false;
        gig.contractorAccepted = false;
        // GigDatabase[msg.sender].push(gig);
        return true;
    }

    function registerHandler(address _handler, uint256 _fee) public returns (bool) {
        require(!isHandlerRegistered(_handler), "Handler Already Registered");
        require(_fee >= 1 && _fee <= 100, "Handler Fee Must Be 1 to 100 (0.1 percent to 10 percent, increment of 0.1 percent)");

        HandlerFee[_handler] = _fee;

        return true;
    }

    function isHandlerRegistered(address _handler) private view returns (bool) {
        return HandlerFee[_handler] == 0 ? false : true;
    }

    function getHandlerFee(address _handler, uint256 _value) public view returns (uint256) {
        return HandlerFee[_handler] * _value / 1000;
    }

    function acceptGig() public returns (bool) {

    }
}