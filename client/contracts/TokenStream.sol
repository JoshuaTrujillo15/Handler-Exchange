// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interfaces/ITokenStream.sol";
import "./HandlerXToken.sol";

/// @title Implementation of ITokenStream Interface
/// @author JoshuaTrujillo15
/// @dev `tokenAddress` is commented out until full ERC20 compatibility is complete
/// @dev This ONLY updates balance on query for now

contract TokenStream is ITokenStream {

    Stream[] streamDatabase;
    HandlerXToken handlerXToken = new HandlerXToken("Handler X Token", "HXT");
    // address handlerXTokenAddress;

    modifier streamActive(uint256 _streamId) {
        require(streamDatabase.length > _streamId, "inactive stream");
        _;
    }

    modifier validParticipant(uint256 _streamId, address _addr) {
        require(
            streamDatabase[_streamId].recipient == _addr ||
            streamDatabase[_streamId].sender == _addr,
            "address is not participating in this stream"
        );
        _;
    }

    constructor() ITokenStream() { }

    function balanceOf(
        uint256 _streamId,
        address _addr
    )
        public
        override
        streamActive(_streamId)
        validParticipant(_streamId, _addr)
        returns (uint256)
    {

        updateBalance(_streamId);

        Stream memory stream = streamDatabase[_streamId];

        if (stream.sender == _addr) {
            return stream.payment - stream.balance;
        } else {
            return stream.balance;
        }
    }

    function createStream(
        address _recipient,
        // address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment
    )
        public
        override
        returns (bool)
    {
        // require(_tokenAddress == handlerXTokenAddress, "incompatible token");
        require(_recipient != address(0x00), "recipient is a zero address");
        require(_recipient != address(this), "recipient is this contract");
        require(_recipient != msg.sender, "recipient is the sender");
        require(_payment > 0, "payment cannot be zero");
        require(
            _startBlock >= block.number,
            "startBlock must be a future block"
        );
        require(_stopBlock > _startBlock, "stopBlock must be after startBlock");
        require(
            handlerXToken.approve(msg.sender, _payment) == true,
            "erc20.approve() failed"
        );

        Stream memory stream;

        stream.sender = msg.sender;
        stream.recipient = _recipient;
        // stream.tokenAddress = _tokenAddress;
        stream.startBlock = _startBlock;
        stream.stopBlock = _stopBlock;
        stream.payment = _payment;
        stream.balance = 0;
        stream.withdrawn = 0;

        streamDatabase.push(stream);

        emit LogCreateStream(
            streamDatabase.length - 1,
            msg.sender,
            _recipient,
            // _tokenAddress,
            _startBlock,
            _stopBlock,
            _payment
        );

        return true;
    }

    function createStreamFrom(
        address _sender,
        address _recipient,
        // address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment
    )
        public
        override
        returns (bool)
    {
        // require(_tokenAddress == handlerXTokenAddress, "incompatible token");
        require(_recipient != address(0x00), "recipient is a zero address");
        require(_recipient != address(this), "recipient is this contract");
        require(_recipient != _sender, "recipient is the sender");
        require(_payment > 0, "payment cannot be zero");
        require(
            _startBlock >= block.number,
            "startBlock must be a future block"
        );
        require(_stopBlock > _startBlock, "stopBlock must be after startBlock");
        require(
            handlerXToken.approve(_sender, _payment) == true,
            "erc20.approve() failed"
        );

        Stream memory stream;

        stream.sender = _sender;
        stream.recipient = _recipient;
        // stream.tokenAddress = _tokenAddress;
        stream.startBlock = _startBlock;
        stream.stopBlock = _stopBlock;
        stream.payment = _payment;
        stream.balance = 0;
        stream.withdrawn = 0;

        streamDatabase.push(stream);

        emit LogCreateStream(
            streamDatabase.length -1,
            _sender,
            _recipient,
            // _tokenAddress,
            _startBlock,
            _stopBlock,
            _payment
        );

        return true;
    }

    function getStream(
        uint256 _streamId
    )
        public
        view
        override
        streamActive(_streamId)
        returns 
    (
        address sender,
        address recipient,
        // address tokenAddress,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 payment,
        uint256 balance,
        uint256 withdrawn
    )
    {
        return (
            streamDatabase[_streamId].sender,
            streamDatabase[_streamId].recipient,
            // streamDatabase[_streamId].tokenAddress,
            streamDatabase[_streamId].startBlock,
            streamDatabase[_streamId].stopBlock,
            streamDatabase[_streamId].payment,
            streamDatabase[_streamId].balance,
            streamDatabase[_streamId].withdrawn
        );
    }

    function withdraw(
        uint256 _streamId,
        uint256 _funds
    )
        public
        override
        streamActive(_streamId)
        returns (bool)
    {
        updateBalance(_streamId);

        require(
            msg.sender == streamDatabase[_streamId].recipient, 
            "must be recipient"
        );
        require(
            streamDatabase[_streamId].balance >= _funds,
            "insufficient balance"
        );
        require(
            handlerXToken.transferFrom(
                streamDatabase[_streamId].sender,
                msg.sender,
                _funds
            ) == true,
            "erc20.transferFrom() failed"
        );

        streamDatabase[_streamId].withdrawn += _funds;
        emit LogWithdraw(_streamId, msg.sender, _funds);
        return true;
    }

    function cancel(
        uint256 _streamId
    )
        public
        override
        validParticipant(_streamId, msg.sender)
        returns (bool) 
    {

    }

    /// @dev Updates balance based on current block header
    function updateBalance(uint256 _streamId) private {

        Stream memory stream = streamDatabase[_streamId];
        if (block.number <= stream.startBlock) return;
        else if (block.number >= stream.stopBlock) {
            stream.balance = stream.payment - stream.withdrawn;
        }
        uint256 blockValue = stream.payment / (stream.stopBlock - stream.startBlock);
        uint256 blocksPassed = block.number - stream.startBlock;
        streamDatabase[_streamId].balance = (blocksPassed * blockValue) - stream.withdrawn;
    }

}