// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interfaces/IERC1620.sol";

abstract contract ERC1620 is IERC1620 {

    mapping(address => uint256) balances;
    Stream[] streamDatabase;
    address handlerToken;

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

    constructor() { }

    function balaceOf(
        uint256 _streamId,
        address _addr
    ) 
        public
        streamActive(_streamId)
        validParticipant(_streamId, _addr)
        returns (uint256)
    {
        snapshot(_streamId);
        Stream memory stream = streamDatabase[_streamId];
        if (stream.sender == _addr) {
            return stream.payment - stream.balance;
        } else {
            return stream.balance;
        }
    }

    function getStream(
        uint256 _streamId
    )
        public
        view
        override
        streamActive(_streamId)
        returns (
        address sender,
        address recipient,
        address tokenAddress,
        uint256 balance,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 payment,
        uint256 interval
    )
    {
        return (
            streamDatabase[_streamId].sender,
            streamDatabase[_streamId].recipient,
            streamDatabase[_streamId].tokenAddress,
            streamDatabase[_streamId].balance,
            streamDatabase[_streamId].start,
            streamDatabase[_streamId].stop,
            streamDatabase[_streamId].payment,
            streamDatabase[_streamId].interval
        );
    }

    function create(
        address _recipient,
        address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
        public
        override
    {
        require(_tokenAddress == handlerToken, "incompatible token");
        require(_recipient != address(0x00), "recipient is a zero address");
        require(_recipient != address(this), "recipient is this contract");
        require(_recipient != msg.sender, "recipient is the sender");
        require(_payment > 0, "payment cannot be zero");
        require(
            _startBlock >= block.number,
            "startBlock must be a future block"
        );
        require(_stopBlock > _startBlock, "stopBlock must be after startBlock");
        require(_interval > 0, "interval must be greater than 0");
        require(
            (_stopBlock - _startBlock) % _interval == 0, 
            "interval must be divisible by the number of blocks");

        Stream memory stream;

        stream.sender = msg.sender;
        stream.recipient = _recipient;
        stream.tokenAddress = _tokenAddress;
        stream.balance = 0;
        stream.start = _startBlock;
        stream.stop = _stopBlock;
        stream.payment = _payment;
        stream.interval = _interval;

        emit LogCreate(
            streamDatabase.length,
            msg.sender,
            _recipient,
            _tokenAddress,
            _startBlock,
            _stopBlock,
            _payment,
            _interval
        );

        streamDatabase.push(stream);

    }

    function withdraw(
        uint256 _streamId,
        uint256 _funds
    )
        public
        override
        streamActive(_streamId)
    {
        require(
            msg.sender == streamDatabase[_streamId].recipient, 
            "must be recipient"
        );
        // Snapshot issues ?
    }

    function snapshot(uint256 _streamId) private {

        Stream memory stream = streamDatabase[_streamId];
        if (block.number <= stream.start || block.number >= stream.stop) {
            return;
        }
        uint256 totalBlocks = stream.stop - stream.start;
        uint256 intervalValue = stream.payment / (totalBlocks / stream.interval);
        uint256 intervalsPassed = (block.number - stream.start) / stream.interval;

        streamDatabase[_streamId].balance = intervalValue * intervalsPassed;
    }

}