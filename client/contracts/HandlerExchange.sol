//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interfaces/IHandlerExchange.sol";
import "./HandlerXToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HandlerExchange is IHandlerExchange {

    IERC20 private _token;

    GigStruct[] gigDatabase;
    OfferStruct[] offerDatabase;
    HandlerStruct[] handlerDatabase;

    constructor() {
        _token = new HandlerXToken();
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

    function getOffer(uint256 _offerId)
        public
        view
        override
        returns (OfferStruct memory)
    {
        require(offerDatabase.length > _offerId);
        return offerDatabase[_offerId];
    }

    function getOfferBatch()
        public
        view
        override
        returns (OfferStruct[] memory)
    {
        return offerDatabase;
    }

    function createGig(
        address _client,
        uint256 _handlerId,
        uint256 _price,
        uint8 _initialRelease
    )
        public
        override
        returns (bool)
    {
        require(handlerExists(_handlerId));
        HandlerStruct memory handler = handlerDatabase[_handlerId];

        require(handler.fee > 0, "inactive handler");
        require(_price > 0, "price is zero");
        require(_initialRelease < 100, "only 0% to 99%");
        require(_client != address(0x00), "client is zero address");
        require(_client != address(this), "client is contract");
        require(handler.account != address(0x00), "handler is zero address");
        require(handler.account != address(this), "handler is contract");
        require(handler.account != msg.sender, "handler is contractor");

        GigStruct memory gig;
        gig.contractor = msg.sender;
        gig.client = _client;
        gig.handler = handler;
        gig.price = _price;
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
            handler,
            _price,
            _initialRelease
        );

        return true;
    }

    // client MUST HandlerXToken.approve(gig.handler.account, totalCost);
    function acceptGig(uint256 _gigId)
        public
        override
        returns (bool accepted)
    {
        require(gigDatabase.length > _gigId);
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.client == msg.sender, "only client");

        require(!gig.active, "gig active");
        require(gig.cancelled, "gig cancelled");
        require(gig.refunded, "gig refunded");
        require(gig.complete, "gig complete");

        uint256 clientAllowance = _token.allowance(msg.sender, gig.handler.account);
        uint256 totalCost = gig.price + ((gig.handler.fee * gig.price) / 1000);
        require(
            clientAllowance >= totalCost,
            "client allowance insufficient"
        );

        accepted = _token.transferFrom(msg.sender, gig.handler.account, totalCost);
        gigDatabase[_gigId].active = true;

        emit LogAcceptGig(_gigId);

        return accepted;
    }

    function cancelGig(uint256 _gigId)
        public
        override
        returns (bool)
    {
        require(gigDatabase.length > _gigId);
        GigStruct memory gig = gigDatabase[_gigId];
        require(
            gig.contractor == msg.sender ||
            gig.client == msg.sender,
            "only client or contractor "
        );
        require(gig.active, "gig inactive");
        require(!gig.cancelled, "gig cancelled");
        require(!gig.refunded, "gig refunded");
        require(!gig.complete, "gig complete");

        gigDatabase[_gigId].cancelled = true;

        emit LogCancelGig(_gigId);

        return true;
    }

    function gigComplete(uint256 _gigId)
        public
        override
        returns (bool)
    {
        require(gigDatabase.length > _gigId);
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.client == msg.sender, "only client");
        require(gig.active, "gig inactive");
        require(!gig.cancelled, "gig cancelled");
        require(!gig.refunded, "gig refunded");
        require(!gig.complete, "gig complete");

        gigDatabase[_gigId].complete = true;
        
        emit LogCompleteGig(_gigId);

        return true;
    }

    function getGig(uint256 _gigId)
        public
        view
        override
        returns (GigStruct memory)
    {
        require(gigDatabase.length > _gigId);
        return gigDatabase[_gigId];
    }

    function getGigBatch()
        public
        view
        override
        returns (GigStruct[] memory)
    {
        return gigDatabase;
    }

    function registerHandler(uint256 _fee)
        public
        override
        returns (bool)
    {
        require(_fee > 0 && _fee < 100, "invalid fee");

        HandlerStruct memory handler;
        handler.account = msg.sender;
        handler.fee = _fee;
        handler.issues = 0;
        handler.transactions = 0;

        handlerDatabase.push(handler);

        emit LogRegisterHandler(msg.sender, handlerDatabase.length, _fee);

        return true;
    }

    function deactivateHandler(uint256 _handlerId)
        public
        override
        returns (bool)
    {
        require(handlerExists(_handlerId));
        require(
            handlerDatabase[_handlerId].account == msg.sender,
            "only handler"
        );
        handlerDatabase[_handlerId].fee = 0;
        return true;
    }

    function setHandlerFee(uint256 _handlerId, uint256 _fee)
        public
        override
        returns (bool)
    {
        require(_fee > 0, "fee is zero");
        require(_fee < 100, "fee is greater than 10% (100)");
        require(handlerExists(_handlerId));
        require(
            handlerDatabase[_handlerId].account == msg.sender,
            "only handler"
        );
        handlerDatabase[_handlerId].fee = _fee;
        return true;
    }

    function getHandler(uint256 _handlerId)
        public
        view
        override
        returns (HandlerStruct memory handler)
    {
        require(handlerExists(_handlerId));
        return handlerDatabase[_handlerId];
    }

    function getHandlerBatch()
        public
        view
        override
        returns (HandlerStruct[] memory)
    {
        return handlerDatabase;
    }

    function reportHandler(uint256 _handlerId)
        public
        override
        returns (bool)
    {
        require(handlerExists(_handlerId));
        handlerDatabase[_handlerId].issues += 1;
        return true;
    }

    function handlerExists(uint256 _handlerId)
        public
        view
        override
        returns (bool)
    {
        return handlerDatabase.length > _handlerId;
    }

    // handler MUST call HandlerXToken.approve(gig.contractor, totalCost)
    function releaseInitial(uint256 _gigId)
        public
        override
        returns (bool released)
    {
        require(gigDatabase.length > _gigId);
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.handler.account == msg.sender, "only handler");
        require(gig.active, "gig inactive");
        require(!gig.cancelled, "gig cancelled");
        require(!gig.refunded, "gig refunded");
        require(!gig.complete, "gig complete");

        uint256 handlerAllowance = _token.allowance(msg.sender, gig.contractor);
        uint256 initialPayment = (gig.price * gig.initialRelease) / 100;
        require(
            handlerAllowance >= initialPayment,
            "handler allowance insufficient"
        );

        released = _token.transferFrom(msg.sender, gig.contractor, initialPayment);

        return released;
    }

    function releaseFinal(uint256 _gigId)
        public
        override
        returns (bool released)
    {
        require(gigDatabase.length > _gigId);
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.handler.account == msg.sender, "only handler");
        require(gig.active, "gig inactive");
        require(!gig.cancelled, "gig cancelled");
        require(!gig.refunded, "gig refunded");
        require(gig.complete, "gig not complete");

        uint256 handlerAllowance = _token.allowance(msg.sender, gig.contractor);
        uint256 finalPayment = (gig.price * (100 - gig.initialRelease)) / 100;

        require(
            handlerAllowance >= finalPayment,
            "handler allowance insufficient"
        );

        released = _token.transferFrom(msg.sender, gig.contractor, finalPayment);

        gigDatabase[_gigId].active = false;

        return released;
    }

    function refundFinal(uint256 _gigId)
        public
        override
        returns (bool refunded)
    {
        require(gigDatabase.length > _gigId);
        require(gigDatabase[_gigId].handler.account == msg.sender, "only handler");
        GigStruct memory gig = gigDatabase[_gigId];
        require(gig.active, "gig inactive");
        require(gig.cancelled, "gig cancelled");
        require(!gig.refunded, "gig refunded");
        require(!gig.complete, "gig complete");

        uint256 handlerAllowance = _token.allowance(msg.sender, gig.contractor);
        uint256 refundPayment = (gig.price * (100 - gig.initialRelease)) / 100;

        require(
            handlerAllowance >= refundPayment,
            "handler allowance insufficient"
        );

        refunded = _token.transferFrom(msg.sender, gig.contractor, refundPayment);

        gigDatabase[_gigId].refunded = true;

        return refunded;
    }
}