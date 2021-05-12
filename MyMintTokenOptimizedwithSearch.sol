pragma solidity ^0.4.16;

library Listsearch {

    // Создаем функцию для просмотра массива
    function searchFor(adress[] storage self, string _adress) returns (bool){
        // Проходимся по массиву
        for (uint i = 0; i < self.length; i++){

            // Если нашли число - возвращаем его индекс
            if (self[i] == _adress) return true;

        }
        // Если не нашли число, возвращаем uint(-1)
        return false;
    }

}


contract IrishaCoin{
    using Listsearch for address;

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowance;
    address[] public whiteList;


    event Transfer(address sender , address receiver, uint tokens);
    event Approval(address sender , address receiver, uint tokens);

       function balanceOf(address tokenOwner) public view returns (uint) {
    	return balances [tokenOwner];
    }

    function _transfer(address _sender, address _receiver, uint256 _tokens) internal {
        require(_receiver != 0x0);
        require(balances[_sender] >= _tokens);
        require(balances[_receiver] + _tokens >= balances[_receiver]);
        require(whiteList.searchFor(_receiver) == true);
        balances[_receiver] += _tokens;
        balances[_sender] -= _tokens;
        Transfer(_sender, _receiver, _tokens);
    }

    function transfer(address _receiver, uint256 _tokens) public {
        _transfer(msg.sender, _receiver, _tokens);
    }

    function approve(address _receiver, uint256 _tokens) public {
        require(whiteList.searchFor(_receiver) == true);
        allowance[msg.sender][_receiver] = _tokens;
        Approval(msg.sender, _receiver, _tokens);
    }

    function transferFrom(address _sender, address _receiver, uint256 _tokens) public {
        require(_tokens <= allowance[_sender][_receiver]);
        allowance[_sender][_receiver] -= _tokens;
        _transfer(_sender, _receiver, _tokens);
    }

    function allowance(address _sender, address _receiver) public view returns (uint) {
        return allowance[_sender][_receiver];
    }
}
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  /**
   * Конструктор Ownable задаёт владельца контракта с помощью аккаунта отправителя
   */
  function Ownable() {
    owner = msg.sender;
  }
  /**
   * Выбрасывает ошибку, если вызвана любым аккаунтом, кроме владельца.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  /**
   * Позволяет текущему владельцу перевести контроль над контрактом новому владельцу.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity автоматически выбрасывает ошибку при делении на ноль, так что проверка не имеет смысла
    uint256 c = a / b;
    // assert(a == b * c + a % b); // Не существует случая, когда эта проверка не была бы пройдена
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

* Mintable token
 * Простой пример токена ERC20, с созданием mintable токена
 */
contract IrishaMintableCoin is IrishaCoin, Ownable {
    using SafeMath for uint256;
    string public name;
    string public symbol; 
   
    function  IrishaMintableCoin () public {
    uint8 public decimals = 18;
    uint256 public totalSupply; 
    string public name = "IrishaMintCoin";
    string public symbol = "Irish";
    balances[msg.sender] = totalSupply;
    }

  event Mint(address indexed to, uint256 amount);
  event MintFinished();
  bool public mintingFinished = false;
  modifier canMint() {
    require(!mintingFinished);
    _;
  }
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(address(0), _to, _amount);
    return true;
  }

  function MintState() public view returns (string) {
    if (mintingFinished == false) {
      return "minting is going on";
    }
    else {
      return "minting is finished";
    }
  }

  function finishMinting() onlyOwner public returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}