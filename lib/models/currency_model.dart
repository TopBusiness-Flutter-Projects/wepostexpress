import 'dart:convert';
import 'dart:io';

class CurrencyModel {
    CurrencyModel(
            {this.id,
                this.name,
                this.symbol,
                this.exchange_rate,
                this.status,
                this.code,
                this.created_at,
                this.updated_at});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'name': name,
            'symbol': symbol,
            'exchange_rate': exchange_rate,
            'status': status,
            'code': code,
            'created_at': created_at,
            'updated_at': updated_at,
        };
    }

    static fromJson(user) {
        return CurrencyModel(
            id: user['id'].toString(),
            name: user['name'].toString(),
            symbol: user['symbol'].toString(),
            exchange_rate: user['exchange_rate'].toString(),
            status: user['status'].toString(),
            code: user['code'].toString(),
            created_at: user['created_at'].toString(),
            updated_at: user['updated_at'].toString(),
        );
    }

    final String id;
    final String name;
    final String symbol;
    final String exchange_rate;
    final String status;
    final String code;
    final String created_at;
    final String updated_at;
}