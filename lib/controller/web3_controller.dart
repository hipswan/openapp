import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

enum UserType {
  buyer,
  seller,
}

class Web3Controller {
  final Web3Client ethClient;
  // final Client? httpClient = Client();

  final myAddress = "0x059Ac2d11b1B59B1e66E23D885a8E3d6b3c5Ca63";
  final EthPrivateKey privateKey;
  Web3Controller({
    required this.ethClient,
    required this.privateKey,
  });
  Future<DeployedContract> loadContract() async {
    final abi = await rootBundle.loadString("assets/contract/abi.json");
    final contractAddress = "0x79C162BfcC1Ca025a5d90Ec87aBEE6A24D3e37a1";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "BFEv4"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey cred = EthPrivateKey.fromHex(
        "0xfe6c8e3bfc0758bed739cb6f1594402db1be0f2301c781ba8403b1a713ba5f9c");

    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
      cred,
      Transaction.callContract(
          contract: contract, function: ethFunction, parameters: args),
      chainId: 3,
    );

    return result;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result =
        ethClient.call(contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    EthereumAddress ethAddress = EthereumAddress.fromHex(targetAddress);
    final balance = await query('getBalance', []);
  }
}
