
## info

soliditynode: 39.105.66.80:50051 fullnode:47.254.16.55:50051
fullnode的api主要是写操作，也有一些查询操作
soliditynode上都是读操作
两种节点的区别是fullnode上提供的查询接口返回的数据可能不是准确的，因为有可能分叉，导致数据回退

soliditynode上的查询api返回的数据是稳定且准确的
需要在客户端选择，需要考虑是请求fullnode还是solidity
客户端需要同时连接fullnode和soliditynode

the http interfaces in wallet-cli will be closed later. please use grpc
https://github.com/tronprotocol/grpc-gateway
RPGC

https://github.com/tronprotocol/tips/blob/master/TWP-001.md
这里有私钥到地址的详细转换过程

http://192.168.1.188:8090/pages/viewpage.action?pageId=5112345
交易签名流程

https://github.com/tronprotocol/protocol 这里是全部protocol定义， wallet-cli项目里有java版的使用方法。

https://github.com/tronprotocol/protocol/blob/master/api/api.proto
这是protobuf文件

http://47.254.18.49:18890/wallet/listwitnesses 这是测试网的一台机器，这个接口是把grpc的转成json的，所有接口查看protobuf定义

imToken 支持三种钱包:
1.Keystore 文件
2.助记词
3.明文私钥



https://tronscan.org/#/blockchain 这是区块链浏览器，这里可以申请账户和测试用的钱。
