//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title Interface for Ecrow System
/// @author JoshuaTrujillo15

interface IHandlerExchange {

    struct GigStruct {
        address contractor;
        address client;
        address handler;
        uint256 price;
        uint256 handlerFee;
        uint8 initialRelease;
        bool active;
        bool cancelled;
        bool refunded;
        bool complete;
    }

    struct OfferStruct {
        address contractor;
        string personalName;
        string personalTitle;
        string service;
        string emailAddress;
        bytes4 primaryColor;
        bytes4 secondaryColor;
        bool active;
    }

    struct HandlerStruct {
        uint256 fee;
        uint256 transactions;
        uint256 issues;
    }

    event LogCreateOffer(
        uint256 indexed offerId,
        address indexed contractor,
        string personalName,
        string personalTitle,
        string service,
        string emailAddress
    );

    event LogCreateGig(
        uint256 indexed gigId,
        address indexed contractor,
        address indexed client,
        address handler,
        uint256 price,
        uint256 handlerFee,
        uint8 initialRelease
    );

    event LogAcceptGig(
        uint256 indexed gigId,
        address indexed handler
    );

    event LogCancelGig(
        uint256 indexed gigId,
        address indexed handler
    );

    event LogCompleteGig(
        uint256 indexed gigIg,
        address indexed handler
    );

    function createOffer(
        string memory _personalName,
        string memory _personalTitle,
        string memory _service,
        string memory _emailAddress,
        bytes4 _primaryColor,
        bytes4 _secondaryColor
    ) external returns (bool success);

    function createGig(
        address _client,
        address _handler,
        uint256 _price,
        uint8 _initialRelease
    ) external returns (bool success);

    function acceptGig(uint256 _gigId) external returns (bool accepted);

    function cancelGig(uint256 _gigId) external returns (bool cancelled);

    function gigComplete(uint256 _gigId) external returns (bool completed);

    function getGig(uint256 _gigId)
        external
        view
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
        );

    function activateHandler(uint256 _fee) external returns (bool activated);

    function deactivateHandler() external returns (bool deactivated);

    function setHandlerFee(uint256 _fee) external returns (bool set);

    function getHandler(address _handler)
        external
        view
        returns (HandlerStruct memory);

    function reportHandler(address _handler) external returns (bool reported);

    function releaseInitial(uint256 _gigId) external returns (bool released);

    function releaseFinal(uint256 _gigId) external returns (bool released);

    function refundFinal(uint256 _gigId) external returns (bool refunded);

}