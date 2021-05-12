pragma solidity ^0.4.11;

import 'github.com/oraclize/ethereum-api/oraclizeAPI.sol';

//объявляем интерфейс
interface Token {
	function transfer(address _recepient, uint256 _value);
}
//объявляем ICO
contract MyFirstICO is usingOraclize{
	//переменная для хранения стоимости токена
	uint256 public tokenPrice;

	//переменная для хранения токена
	Token public token

	// Объявляем переменную, в которой будем хранить стоимость доллара
	uint public dollarCost;

	//функция инициализации, которая принимает значение токена
	function MyFirstICO (Token _token){
		token = _token;
		tokenPrice = dollarCost*50;
	}

	// В эту функцию ораклайзер будет присылать нам результат
	function __callback(bytes32 myid, string result) public {
		// Проверяем, что функцию действительно вызывает ораклайзер
		if (msg.sender != oraclize_cbAddress()) throw;
		// Обновляем переменную со стоимостью доллара
		dollarCost = parseInt(result, 3);
	}

	// Функция для обновления курса доллара
	function updatePrice() public payable {
		// Проверяем, что хватает средств на вызов функции
		if (oraclize_getPrice("URL") > this.balance){
			// Если не хватает, просто завершаем выполнение
			return;
		} else {
			// Если хватает - отправляем запрос в API
			oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.[0]");
		}
	}

	//функция приема эфиров
	function () payable {
		_buy (msg.sender, msg.value);
	}

	//вызываемая функция приема эфиров
	function buy(address _buyer) payable returns (uint) {
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

