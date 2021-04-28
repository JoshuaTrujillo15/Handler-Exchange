//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interfaces/IHandlerExchange.sol";
import "./TokenStream.sol";

contract HandlerExchange is IHandlerExchange {

    modifier gigExists(uint256 _gigId) {
        require(gigDatabase.length > _gigId, "gig does not exist");
        _;
    }

    modifier onlyClient(uint256 _gigId, address _addr) {
        require(
            gigDatabase[_gigId].client == _addr,
            "only the client can perform this action"
        );
        _;
    }

    modifier onlyContractor(uint256 _gigId, address _addr) {
        require(
            gigDatabase[_gigId].contractor == _addr,
            "only the contractor can perform this action"
        );
        _;
    }

    modifier onlyClientOrContractor(uint256 _gigId, address _addr) {
        require(
            gigDatabase[_gigId].contractor == _addr ||
            gigDatabase[_gigId].client == _addr,
            "only the client or contractor may perform this action"
        );
        _;
    }

    modifier handlerActive(address _addr) {
        require(handlerFees[_addr] > 0, "inactive handler");
        _;
    }

    GigStruct[] gigDatabase;
    OfferStruct[] offerDatabase;
    TokenStream streamingProvider = new TokenStream();

    mapping(address => uint256) handlerFees;

    constructor() { }

    function createOffer(
        string memory _personalName,
        string memory _personalTitle,
        string memory _service,
        string memory _emailAddress,
        bytes4 _primaryColor,
        bytes4 _secondaryColor
    ) public override returns (bool) {

        OfferStruct memory offer;
        offer.contractor = msg.sender;
        offer.personalName = _personalName;
        offer.personalTitle = _personalTitle;
        offer.service = _service;
        offer.emailAddress = _emailAddress;
        offer.primaryColor = _primaryColor;
        offer.secondaryColor = _secondaryColor;
        offer.active = true;

        offerDatabase.push(offer);

        emit LogCreateOffer(
            offerDatabase.length - 1,
            msg.sender,
            _personalName,
            _personalTitle,
            _service,
            _emailAddress
        );

        return true;
    }

    function createGig(
        address _client,
        address _handler,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _price
    )
        public
        override
        handlerActive(_handler)
        returns (bool)
    {
        require(_price > 0, "price must be greater than zero");
        require(_client != address(0x00), "client may not be zero address");
        require(_client != address(this), "client may not be this contract");
        require(_handler != address(0x00), "handler may not be zero address");
        require(_handler != address(this), "handler may not be this contract");
        require(_handler != msg.sender, "contractor can not be handler");
        require(_startBlock > block.number, "startBlock must be a future block");
        require(_stopBlock > _startBlock, "stopBlock must be after startBlock");

        GigStruct memory gig;
        gig.contractor = msg.sender;
        gig.client = _client;
        gig.handler = _handler;
        gig.startBlock = _startBlock;
        gig.stopBlock = _stopBlock;
        gig.price = _price;
        gig.handlerFee = getHandlerFee(_handler);

        

    }

    function gigResponse(bool _accept) public override returns (bool) {

    }

    function cancelGig(uint256 _gigId) public override returns (bool) {

    }

    function getGig(uint256 _gigId) public view override returns (
        address contractor,
        address client,
        address handler,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 price,
        uint256 handlerFee,
        bool active,
        bool cancelled,
        bool complete
    ) {
        require(gigDatabase.length > _gigId, "gig does not exist");
        return (
            gigDatabase[_gigId].contractor,
            gigDatabase[_gigId].client,
            gigDatabase[_gigId].handler,
            gigDatabase[_gigId].startBlock,
            gigDatabase[_gigId].stopBlock,
            gigDatabase[_gigId].price,
            gigDatabase[_gigId].handlerFee,
            gigDatabase[_gigId].active,
            gigDatabase[_gigId].cancelled,
            gigDatabase[_gigId].complete
        );
    }

    function getHandlerFee(address _handler) 
        public
        view
        override
        handlerActive(_handler)
        returns (uint256) 
    {
        return handlerFees[_handler];
    }

    function setHandlerFee(
        address _handler,
        uint256 _fee
    ) public override returns (bool) {
        require(_handler == msg.sender, "only hander can set their fee");
        require(_fee >= 1 && _fee <= 100, "fee must be 1 to 100");
        handlerFees[_handler] = _fee;
        return true;
    }

    function deactivateHandler(address _handler)
        public
        override
        handlerActive(_handler)
        returns (bool)
    {
        handlerFees[_handler] = 0;
        return true;
    }

}