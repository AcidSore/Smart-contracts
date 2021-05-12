pragma solidity ^0.4.11;

contract IrishaCoin{
	string public name;
    string public symbol;
    uint8 public decimals;  
    uint256 public totalSupply;

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address sender , address receiver, uint tokens);
    event Approval(address sender , address receiver, uint tokens);

    function IrishaCoin() public {
        decimals = 18;
        totalSupply = 90000000 * (10 ** uint256(decimals));
  		balances[msg.sender] = totalSupply;
  	    name = "IrishaCoin";
    	symbol = "Irish";
    }

       function balanceOf(address tokenOwner) public constant returns (uint) {
    	return balances [tokenOwner];
    }

    function _transfer(address _sender, address _receiver, uint256 _tokens) internal {
        require(_receiver != 0x0);
        require(balances[_sender] >= _tokens);
        require(balances[_receiver] + _tokens >= balances[_receiver]);
        balances[_receiver] += _tokens;
        balances[_sender] -= _tokens;
        Transfer(_sender, _receiver, _tokens);
    }

    function transfer(address _receiver, uint256 _tokens) public {
        _transfer(msg.sender, _receiver, _tokens);
    }

    function approve(address _receiver, uint256 _tokens) public {
        allowance[msg.sender][_receiver] = _tokens;
        Approval(msg.sender, _receiver, _tokens);
    }

    function transferFrom(address _sender, address _receiver, uint256 _tokens) public {
        require(_tokens <= allowance[_sender][_receiver]);
        allowance[_sender][_receiver] -= _tokens;
        _transfer(_sender, _receiver, _tokens);
    }

    function allowance(address _sender, address _receiver) public constant returns (uint) {
        return allowance[_sender][_receiver];
    }
}