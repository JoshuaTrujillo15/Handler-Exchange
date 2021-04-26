// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC1620 {

    struct Stream {
        address sender;
        address recipient;
        address tokenAddress;
        uint256 balance;
        uint256 start;
        uint256 stop;
        uint256 payment;
        uint256 interval;
    }

    event LogCreate(
        uint256 indexed _streamId,
        address indexed _sender,
        address indexed _recipient,
        address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    );

    event LogWithdraw(
        uint256 indexed _streamId,
        address indexed _recipient,
        uint256 _funds
    );

    event LogRedeem(
        uint256 indexed _streamId,
        address indexed _sender,
        address indexed _recipient,
        uint256 _senderBalance,
        uint256 _recipientBalance
    );

    event LogConfirmUpdate(
        uint256 indexed _streamId,
        address indexed _confirmer,
        address _newTokenAddress,
        uint256 _newStopBlock,
        uint256 _newPayment,
        uint256 _newInterval
    );

    event LogRevokeUpdate(
        uint256 indexed _streamId,
        address indexed _revoker,
        address _newTokenAddress,
        uint256 _newStopBlock,
        uint256 _newPayment,
        uint256 _newInterval
    );

    event LogExecuteUpdate(
        uint256 indexed _streamId,
        address indexed _sender,
        address indexed _recipient,
        address _newTokenAddress,
        uint256 _newStopBlock,
        uint256 _newPayment,
        uint256 _newInterval
    );

    function balanceOf(
        uint256 _streamId,
        address _addr
    )
        external
        view
        returns (uint256);

    function getStream(
        uint256 _streamId
    )
        external
        view
        returns (
            address sender,
            address recipient,
            address tokenAddress,
            uint256 balance,
            uint256 startBlock,
            uint256 stopBlock,
            uint256 payment,
            uint256 interval
        );

    function create(
        address _recipient,
        address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
        external;

    function withdraw(uint256 _streamId, uint256 _funds) external;

    function redeem(uint256 _streamId) external;

    function update(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 interval
    )
        external;

    function confirmUpdate(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
        external;
}