// Версия solidity
pragma solidity ^0.4.16;

// Объявляем название библиотеки
library Listsearch {

    // Создаем функцию для просмотра массива
    function searchFor(address[] storage self, string _address) returns (bool){
        // Проходимся по массиву
        for (uint i = 0; i < self.length; i++){

            // Если нашли число - возвращаем его индекс
            if (self[i] == _address) return true;

        }
        // Если не нашли число, возвращаем uint(-1)
        return false;
    }

}
