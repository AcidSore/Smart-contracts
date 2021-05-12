pragma solidity ^0.4.11;

//объявляем интерфейс
interface Token {
	function transfer(address _recepient, uint256 _value);
}
//объявляем ICO
contract MyFirstICO{
	//переменная для хранения стоимости токена
	uint256 public tokenPrice;

	//переменная для хранения токена
	Token public token;

	//функция инициализации, которая принимает значение токена
	function MyFirstICO (Token _token){
		token = _token;
		tokenPrice = 500 finney;
	}

	//функция приема эфиров
	function () payable {
		_buy (msg.sender, msg.value);
	}

	//вызываемая функция приема эфиров
	function buy(address _buyer) p
	ayable returns (uint) {
		uint tokens = _buy (_buyer, msg.value);
		return tokens;
	}


	//внутренння функция для покупки токенов
	function _buy(address _sender, uint256 _amount) internal returns (uint) {
		//рассчет стоимости
		uint tokens = _amount/tokenPrice;
		//вызов функции трансфер токена
		token.transfer(_sender,tokens);
		return tokens;
	}

}

