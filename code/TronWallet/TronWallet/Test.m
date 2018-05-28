//
//  Test.m
//  TronWallet
//
//  Created by chunhui on 2018/5/28.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "Test.h"
#import "SecureData.h"
#import "ecdsa.h"
#include "secp256k1.h"

@implementation Test

+(void)load
{
//    [self test];
}

+(void)test
{
    
    NSString *priKeyHex = @"0xab586052ebbea85f3342dd213abbe197ab3fd70c5edf0b2ceab52bd4143e1a52";
    NSData *priKeyData = [SecureData hexStringToData:priKeyHex];
    SecureData * sprivateKey = [SecureData secureDataWithData:priKeyData];
    
    SecureData *publicKey = [SecureData secureDataWithLength:65];
    ecdsa_get_public_key65(&secp256k1, sprivateKey.bytes, publicKey.mutableBytes);
//    NSData *addressData = [[[publicKey subdataFromIndex:1] KECCAK256] subdataFromIndex:12].data;
    NSLog(@"public key is: %@",publicKey.hexString);
    
    publicKey = [publicKey subdataWithRange:NSMakeRange(1, 64)];
    
    SecureData *ak256Data = [publicKey KECCAK256];
    NSLog(@"ak256 data is: \n%@\n",ak256Data.data);
    
    SecureData *sha256Data = [publicKey SHA256];
    NSLog(@"sh256 data is: \n%@\n",[sha256Data data]);
    
//    _address = [Address addressWithData:addressData];
    
    //sha3-256(P)
    //c7bcfe2713a76a15afa7ed84f25675b364b0e45e2668c1cdd59370136ad8ec2f
}

@end
