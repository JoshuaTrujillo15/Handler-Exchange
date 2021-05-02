//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interfaces/IHandlerExchange.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HandlerExchange is IHandlerExchange, ERC20 {

    modifier gigExists(uint256 _gigId) {
        require(gigDatabase.length > _gigId, "gig does not exist");
        _;
    }

    modifier onlyClient(uint256 _gigId, address _account) {
        require(
            gigDatabase[_gigId].client == _account,
            "only the client can perform this action"
        );
        _;
    }

    modifier onlyContractor(uint256 _gigId, address _account) {
        require(
            gigDatabase[_gigId].contractor == _account,
            "only the contractor can perform this action"
        );
        _;
    }

    modifier onlyClientOrContractor(uint256 _gigId, address _account) {
        require(
            gigDatabase[_gigId].contractor == _account ||
            gigDatabase[_gigId].client == _account,
            "only the client or contractor may perform this action"
        );
        _;
    }

    modifier onlyHandler(uint256 _gigId, address _account) {
        require(
            gigDatabase[_gigId].handler == _account,
            "only the handler may perform this action"
        );
        _;
    }

    modifier handlerActive(address _account) {
        require(handlers[_account].fee > 0, "inactive handler");
        _;
    }

    address owner;
    GigStruct[] gigDatabase;
    OfferStruct[] offerDatabase;
    mapping(address => HandlerStruct) handlers;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 100000 * (10 ** 18));
    }

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
        uint256 _price,
        uint8 _initialRelease
    )
        public
        override
        handlerActive(_handler)
        returns (bool)
    {
        require(_price > 0, "price is zero");
        require(_initialRelease < 100, "initial release is not 0% to 99%");
        require(_client != address(0x00), "client is zero address");
        require(_client != address(this), "client is this contract");
        require(_handler != address(0x00), "handler is zero address");
        require(_handler != address(this), "handler is this contract");
        require(_handler != msg.sender, "handler is contractor");

        GigStruct memory gig;
        gig.contractor = msg.sender;
        gig.client = _client;
        gig.handler = _handler;
        gig.price = _price;
        gig.handlerFee = getHandler(_handler).fee;
        gig.initialRelease = _initialRelease;
        gig.active = false;
        gig.cancelled = false;
        gig.refunded = false;
        gig.complete = false;

        gigDatabase.push(gig);

        emit LogCreateGig(
            gigDatabase.length - 1,
            msg.sender,
            _client,
            _handler,
            _price,
            gig.handlerFee,
            _initialRelease
        );

        return true;
    }

    function acceptGig(uint256 _gigId)
        public
        override
        gigExists(_gigId)
        onlyClient(_gigId, msg.sender)
        returns (bool accepted)
    {
        GigStruct memory gig = gigDatabase[_gigId];

        require(!gig.active, "gig is already active");
        require(gig.cancelled, "gig is cancelled");
        require(gig.refunded, "gig is refunded");
        require(gig.complete, "gig is complete");

        uint256 clientAllowance = allowance(msg.sender, gig.handler);
        uint256 totalCost = gig.price + gig.handlerFee;

        require(clientAllowance >= totalCost, "insufficient allowance");

        accepted = transferFrom(msg.sender, gig.handler, totalCost);
        gigDatabase[_gigId].active = true;

        emit LogAcceptGig(_gigId, gig.handler);

        return accepted;
    }

    function cancelGig(uint256 _gigId)
        public
        override
        gigExists(_gigId)
        onlyClientOrContractor(_gigId, msg.sender)
        returns (bool)
    {
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.active, "gig is inactive");
        require(!gig.cancelled, "gig is cancelled");
        require(!gig.refunded, "gig is refunded");
        require(!gig.complete, "gig is complete");

        gigDatabase[_gigId].cancelled = true;

        emit LogCancelGig(_gigId, gig.handler);

        return true;
    }

    function gigComplete(uint256 _gigId)
        public
        override
        gigExists(_gigId)
        onlyClient(_gigId, msg.sender)
        returns (bool)
    {
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.active, "gig is inactive");
        require(!gig.cancelled, "gig is cancelled");
        require(!gig.refunded, "gig is refunded");
        require(!gig.complete, "gig is complete");

        gigDatabase[_gigId].complete = true;
        
        emit LogCompleteGig(_gigId, gig.handler);

        return true;
    }

    function getGig(uint256 _gigId)
        public
        view
        override
        gigExists(_gigId)
        returns (
        address contractor,
        address client,
        address handler,
        uint256 price,
        uint256 handlerFee,
        uint8 initialRelease,
        bool active,
        bool cancelled,
        bool refunded,
        bool complete
    ) {
        require(gigDatabase.length > _gigId, "gig does not exist");
        GigStruct memory gig = gigDatabase[_gigId];
        return (
            gig.contractor,
            gig.client,
            gig.handler,
            gig.price,
            gig.handlerFee,
            gig.initialRelease,
            gig.active,
            gig.cancelled,
            gig.refunded,
            gig.complete
        );
    }

    function activateHandler(uint256 _fee)
        public
        override
        returns (bool activated)
    {
        activated = setHandlerFee(_fee);
        return activated;
    }

    function deactivateHandler()
        public
        override
        handlerActive(msg.sender)
        returns (bool)
    {
        handlers[msg.sender].fee = 0;
        return true;
    }

    function setHandlerFee(uint256 _fee)
        public
        override
        returns (bool)
    {
        require(_fee > 0, "fee cannot be zero");
        handlers[msg.sender].fee = _fee;
        return true;
    }

    function getHandler(address _handler)
        public
        view
        override
        returns (HandlerStruct memory handler)
    {
        handler = handlers[_handler];
        return handler;
    }

    function reportHandler(address _handler)
        public
        override
        handlerActive(_handler)
        returns (bool)
    {
        require(msg.sender != _handler, "sender is the handler");
        handlers[_handler].issues += 1;
        return true;
    }

    function releaseInitial(uint256 _gigId)
        public
        override
        gigExists(_gigId)
        onlyHandler(_gigId, msg.sender)
        returns (bool released)
    {
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.active, "gig is inactive");
        require(!gig.cancelled, "gig is cancelled");
        require(!gig.refunded, "gig is refunded");
        require(!gig.complete, "gig is complete");

        uint256 handlerAllowance = allowance(msg.sender, gig.contractor);
        uint256 initialPayment = (gig.price * gig.initialRelease) / 100;

        require(
            handlerAllowance >= initialPayment,
            "handler allowance insufficient"
        );

        released = transferFrom(msg.sender, gig.contractor, initialPayment);

        return released;
    }

    function releaseFinal(uint256 _gigId)
        public
        override
        gigExists(_gigId)
        onlyHandler(_gigId, msg.sender)
        returns (bool released)
    {
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.active, "gig is inactive");
        require(!gig.cancelled, "gig is cancelled");
        require(!gig.refunded, "gig is refunded");
        require(gig.complete, "gig is not complete");

        uint256 handlerAllowance = allowance(msg.sender, gig.contractor);
        uint256 finalPayment = (gig.price * (100 - gig.initialRelease)) / 100;

        require(
            handlerAllowance >= finalPayment,
            "handler allowance insufficient"
        );

        released = transferFrom(msg.sender, gig.contractor, finalPayment);

        gigDatabase[_gigId].active = false;
        gigDatabase[_gigId].complete = true;

        return released;
    }

    function refundFinal(uint256 _gigId)
        public
        override
        gigExists(_gigId)
        onlyHandler(_gigId, msg.sender)
        returns (bool refunded)
    {
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.active, "gig is inactive");
        require(gig.cancelled, "gig is cancelled");
        require(!gig.refunded, "gig is refunded");
        require(!gig.complete, "gig is complete");

        uint256 handlerAllowance = allowance(msg.sender, gig.contractor);
        uint256 refundPayment = (gig.price * (100 - gig.initialRelease)) / 100;

        require(
            handlerAllowance >= refundPayment,
            "handler allowance insufficient"
        );

        refunded = transferFrom(msg.sender, gig.contractor, refundPayment);

        gigDatabase[_gigId].refunded = true;

        return refunded;
    }
}