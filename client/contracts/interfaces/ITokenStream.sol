// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title Interface for Streaming ERC20 tokens
/// @author JoshuaTrujillo15
/// @dev `tokenAddress` is commented out until full ERC20 compatibility is complete
/// @dev This ONLY updates balance on query for now

interface ITokenStream {

    struct Stream {
        address sender;
        address recipient;
        // address tokenAddress;
        uint256 startBlock;
        uint256 stopBlock;
        uint256 payment;
        uint256 balance;
        uint256 withdrawn;
    }

    event LogCreateStream(
        uint256 indexed _streamId,
        address indexed _sender,
        address indexed _recipient,
        // address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment
    );

    event LogWithdraw(
        uint256 indexed _streamId,
        address indexed _recipient,
        uint256 _funds
    );

    /// @dev Updates balance, then queries new balance.

    function balanceOf(
        uint256 _streamId,
        address _addr
    )
        external
        returns (uint256);

    /// @dev Creates new stream by msg.sender

    function createStream(
        address _recipient,
        // address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment
    )
        external
        returns (bool success);

    /// @dev Creates new stream from external contract

    function createStreamFrom(
        address _sender,
        address _recipient,
        // address _tokenAddress,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 payment
    )
        external
        returns (bool success);

    /// @dev Updates Balance, then queries stream.

    function getStream(
        uint256 _streamId
    )
        external
        returns (
            address sender,
            address recipient,
            // address tokenAddress,
            uint256 startBlock,
            uint256 stopBlock,
            uint256 payment,
            uint256 balance,
            uint256 withdrawn
    );

    /// @dev Updates balance, reverts if _funds > newBalance, withdraws _funds

    function withdraw(uint256 _streamId, uint256 _funds) external returns (bool);

    /// @dev Cancels stream

    function cancel(uint256 _streamId) external returns (bool);

}

// FUTURE IMPLEMENTATIONS
    /*
    event LogInitiateChange(
        uint256 indexed _streamId,
        address indexed _sender,
        address indexed _recipient,
        address _newTokenAddress,
        uint256 _newStopBlock,
        uint256 _newPayment
    );

    event LogDenyChange(
        uint256 indexed _streamId,
        address indexed _revoker,
        address _newTokenAddress,
        uint256 _newStopBlock,
        uint256 _newPayment
    );

    event LogConfirmChange(
        uint256 indexed _streamId,
        address indexed _confirmer,
        address _newTokenAddress,
        uint256 _newStopBlock,
        uint256 _newPayment
    );

    function initiateChange(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment
    )
        external;

    function responseChange(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment
    )
        external;
    */