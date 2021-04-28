//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title Interface for Ecrow System using TokenStream
/// @author JoshuaTrujillo15

interface IHandlerExchange {

    struct GigStruct {
        address contractor;
        address client;
        address handler;
        uint256 startBlock;
        uint256 stopBlock;
        uint256 price;
        uint256 handlerFee;
        bool active;
        bool cancelled;
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

    event LogCreateOffer(
        uint256 indexed offerId,
        address indexed contractor,
        string personalName,
        string personalTitle,
        string service,
        string emailAddress
    );

    event LogCreateGig();

    event LogRegisterHandler();

    event LogGigResponse();

    event LogCancelGig();

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
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _price
    ) external returns (bool success);

    function gigResponse(bool _accept) external returns (bool success);
    
    function cancelGig(uint256 _gigId) external returns (bool cancelled);

    function getGig(
        uint256 _gigId
    )
        external
        view
        returns (
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
    );

    function getHandlerFee(address _handler) external view returns (uint256 fee);

    function setHandlerFee(address _handler, uint256 _fee) external returns (bool success);

    function deactivateHandler(address _handler) external returns (bool success);
}